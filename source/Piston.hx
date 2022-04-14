package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;

class Piston extends FlxSprite {
	static inline var ANIMATION_DISTANCE = 8;

	public var direction:Direction;

	var sound:FlxSound;

	public function new(x:Float = 0, y:Float = 0, direction:Direction) {
		super(x, y);
		this.direction = direction;

		loadGraphic(AssetPaths.piston__png, true, 32, 32);
		sound = FlxG.sound.load(AssetPaths.whoosh__ogg);

		// Rotate piston in place. +3 is to compensate for sprite being already rotated
		for (i in 0...direction + 3) {
			angle += 90;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function playAnimation() {
		var vector = Direction.VECTORS[direction];

		var initialX = x;
		var initialY = y;

		sound.play();

		// FlxTween.tween(this, {
		// 	x: x + vector.x * ANIMATION_DISTANCE,
		// 	y: y + vector.y * ANIMATION_DISTANCE
		// }, 0.33, {
		// 	ease: FlxEase.circOut,
		// 	onComplete: function(_) {
		// 		FlxTween.tween(this, {x: initialX, y: initialY}, 0.33, {ease: FlxEase.circOut});
		// 	},
		// });
	}
}
