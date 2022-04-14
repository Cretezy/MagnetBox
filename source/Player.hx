package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;

class Player extends FlxSprite {
	static inline var MAX_SPEED:Float = 700;
	static inline var MIN_SPEED:Float = 200;
	static inline var ACCELERATION:Float = 600;
	static inline var CHECK_DISTANCE:Int = 32;
	static inline var BOUNCE_SCALE = 0.09;
	static inline var MAX_BOUNCE = 150;

	var level:Level;
	var canMove:Bool;
	var onMove:() -> Void;
	var sliding:Direction;
	var hasHitWall = false;
	var lastAnimationPosition:FlxPoint;

	var hitWallSound1:FlxSound;
	var hitWallSound2:FlxSound;
	var slideSound:FlxSound;

	var lastVelocity:FlxPoint;
	var pistonAnimation = false;
	var lastDirection:Direction;
	var lastWallHitWasPiston = false;

	public function new(level:Level, onMove:() -> Void, x:Float = 0, y:Float = 0) {
		super(x, y);
		this.level = level;
		this.onMove = onMove;

		loadGraphic(AssetPaths.player__png, true, 32, 32);
		animation.add("static", [0], 6, false);
		animation.add("u", [1], 6, false);
		animation.add("r", [2], 6, false);
		animation.add("d", [3], 6, false);
		animation.add("l", [4], 6, false);
		animation.add("u_piston", [5], 6, false);
		animation.add("r_piston", [6], 6, false);
		animation.add("d_piston", [7], 6, false);
		animation.add("l_piston", [8], 6, false);

		setSize(32, 32);
		offset.set(0, 0);

		canMove = true;

		maxVelocity.x = MAX_SPEED;
		maxVelocity.y = MAX_SPEED;

		hitWallSound1 = FlxG.sound.load(AssetPaths.anvil1__ogg);
		hitWallSound2 = FlxG.sound.load(AssetPaths.anvil2__ogg);
		slideSound = FlxG.sound.load(AssetPaths.slide__wav);
	}

	override function update(elapsed:Float) {
		updateMovement();
		super.update(elapsed);

		drag.x = level.frozen ? 1000 : 0;
		drag.y = level.frozen ? 1000 : 0;

		lastVelocity = FlxPoint.get().copyFrom(velocity);
	}

	function updateMovement() {
		if (!canMove || level.frozen) {
			return;
		}

		// Keyboard support
		var up = FlxG.keys.anyPressed([UP, W]);
		var down = FlxG.keys.anyPressed([DOWN, S]);
		var left = FlxG.keys.anyPressed([LEFT, A]);
		var right = FlxG.keys.anyPressed([RIGHT, D]);

		// Virtual pad support
		var virtualPad = level.virtualPad;
		if (virtualPad != null) {
			up = up || virtualPad.buttonUp.pressed;
			down = down || virtualPad.buttonDown.pressed;
			left = left || virtualPad.buttonLeft.pressed;
			right = right || virtualPad.buttonRight.pressed;
		}

		// Gamepad support
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		if (gamepad != null) {
			up = up || gamepad.pressed.DPAD_UP;
			down = down || gamepad.pressed.DPAD_DOWN;
			left = left || gamepad.pressed.DPAD_LEFT;
			right = right || gamepad.pressed.DPAD_RIGHT;
		}

		// Only allow one direction at a time
		var hasMultiple = Lambda.fold([up, down, left, right], function(direction, directionCount) {
			return direction ? directionCount + 1 : directionCount;
		}, 0) > 1;

		if (hasMultiple) {
			up = down = left = right = false;
		}

		var move:Direction = null;

		if (up) {
			move = Direction.UP;
		} else if (right) {
			move = Direction.RIGHT;
		} else if (down) {
			move = Direction.DOWN;
		} else if (left) {
			move = Direction.LEFT;
		}

		if (move != null) {
			lastDirection = move;
			lastWallHitWasPiston = false;

			var moveVector = Direction.VECTORS[move];

			if (lastAnimationPosition != null) {
				setPosition(lastAnimationPosition.x, lastAnimationPosition.y);
				lastAnimationPosition = null;
			}

			// Raytrace block in movement direction
			var origin = FlxPoint.get(getMidpoint().x + (moveVector.x * (width / 2)), getMidpoint().y + (moveVector.y * (height / 2)));
			var point = FlxPoint.get(origin.x + (moveVector.x * CHECK_DISTANCE * level.tileSize), origin.y + (moveVector.y * CHECK_DISTANCE * level.tileSize));

			var result = FlxPoint.get();
			var noHit = level.walls.ray(origin, point, result);

			if (!noHit) {
				var alreadyTouching = new FlxRect(x, y, width, height).overlaps(new FlxRect(result.x - 1, result.y - 1, 2, 2));

				var tile = level.walls.getTile(Math.floor((result.x + moveVector.x) / level.tileSize), Math.floor((result.y + moveVector.y) / level.tileSize));

				// 1 is metal wall
				if (tile == 1 && !alreadyTouching) {
					slide(move);
					lastWallHitWasPiston = false;
					onMove();
				} else {
					playAnimation(move);
				}
			} else {
				var origin = FlxPoint.get(getMidpoint().x + (moveVector.x * (width / 2)), getMidpoint().y + (moveVector.y * (height / 2)));

				for (i in 0...CHECK_DISTANCE) {
					var point = FlxPoint.get(origin.x + (moveVector.x * i * level.tileSize), origin.y + (moveVector.y * i * level.tileSize));

					var foundDoor = false;

					for (door in level.doors) {
						if (door.getMidpoint() == point) {
							slide(move);
							lastWallHitWasPiston = false;
							onMove();
							foundDoor = true;
							break;
						}
					}

					if (!foundDoor) {
						playAnimation(move);
					}
				}
			}
		} else {
			if (sliding == null) {
				resetAnimation();
			}
		}
	}

	function slide(direction:Direction) {
		sliding = direction;
		lastDirection = direction;
		hasHitWall = false;
		var moveVector = Direction.VECTORS[direction];

		acceleration.x = moveVector.x * ACCELERATION;
		acceleration.y = moveVector.y * ACCELERATION;
		velocity.x = moveVector.x * MIN_SPEED;
		velocity.y = moveVector.y * MIN_SPEED;
		canMove = false;

		playAnimation(direction);
		slideSound.play(true);
	}

	function playAnimation(direction:Direction) {
		angle = 0;
		switch (direction) {
			case UP:
				animation.play(!pistonAnimation ? "u" : "u_piston");
			case RIGHT:
				animation.play(!pistonAnimation ? "r" : "r_piston");
			case DOWN:
				animation.play(!pistonAnimation ? "d" : "d_piston");
			case LEFT:
				animation.play(!pistonAnimation ? "l" : "l_piston");
		}
	}

	function resetAnimation() {
		animation.play("static");
		angle = 0;
		for (i in 0...lastDirection) {
			angle += 90;
		}

		if (lastWallHitWasPiston) {
			angle += 180;
		}
	}

	public function hitWall() {
		if (hasHitWall) {
			return;
		}

		slideSound.stop();

		pistonAnimation = false;
		hasHitWall = true;
		sliding = null;
		velocity.x = 0;
		velocity.y = 0;
		canMove = true;
		resetAnimation();

		var activatedPiston = false;

		for (direction in Direction.VALUES) {
			var checkVector = Direction.VECTORS[direction];
			var x = getMidpoint().x + (checkVector.x * level.tileSize);
			var y = getMidpoint().y + (checkVector.y * level.tileSize);

			level.pistons.forEach(function(piston) {
				if (piston.getMidpoint().x == x && piston.getMidpoint().y == y && piston.direction == Direction.opposite(direction)) {
					pistonAnimation = true;
					lastWallHitWasPiston = true;
					slide(Direction.opposite(direction));
					piston.playAnimation();
					activatedPiston = true;
				}
			});
		}

		if (!activatedPiston) {
			lastAnimationPosition = getPosition();

			Math.random() < 0.5 ? hitWallSound1.play(true) : hitWallSound2.play(true);

			var currentVelocity = FlxPoint.get().copyFrom(lastVelocity).scale(-BOUNCE_SCALE);
			currentVelocity.x = Math.min(currentVelocity.x, MAX_BOUNCE);
			currentVelocity.y = Math.min(currentVelocity.y, MAX_BOUNCE);

			velocity = currentVelocity;
		}
	}

	public function finish() {
		drag = FlxPoint.get(800, 800);
		acceleration = FlxPoint.get(0, 0);
	}
}
