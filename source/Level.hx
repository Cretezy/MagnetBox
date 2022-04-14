import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxShader;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.display.StageQuality;
import openfl.errors.Error;
import openfl.filters.ShaderFilter;

class Level extends FlxGroup {
	public var player:Player;
	public var map:FlxOgmo3Loader;

	var playState:PlayState;

	var coins:FlxTypedGroup<Coin>;
	var keys:FlxTypedGroup<Key>;

	public var doors:FlxTypedGroup<Door>;

	var tutorialTexts:FlxTypedGroup<TutorialText>;
	var finish:Finish;
	var foundCoins = 0;
	var startTimer = 0.0;
	var started = false;

	public var walls:FlxTilemap;
	public var tileSize:Float;

	public var pistons:FlxTypedGroup<Piston>;

	public var virtualPad:FlxVirtualPad;

	public var frozen = true;

	public function new(playState:PlayState, levelJson:String) {
		super();
		this.playState = playState;

		// Map. Load empty map, then load it from the argument JSON
		map = new FlxOgmo3Loader(AssetPaths.MagnetBox__ogmo, AssetPaths.placeholder__json);
		Reflect.setProperty(map, "level", Json.parse(levelJson));

		// Walls
		walls = map.loadTilemap(AssetPaths.box__png, "Walls");

		// Tile 1: Wall box, collide
		walls.setTileProperties(1, ANY);
		// Tile 2: Floor box, don't collide
		walls.setTileProperties(2, NONE);
		// Tile 3: Wood box, collide
		walls.setTileProperties(3, ANY);

		FlxG.camera.pixelPerfectRender = true;
		FlxG.game.stage.quality = StageQuality.LOW;
		add(walls);

		// Tile size
		var tile = walls.tileToSprite(0, 0, -1);
		if (tile.width != tile.height) {
			throw new Error("Tile width and height must be equal");
		}
		tileSize = tile.width;

		// Counts
		coins = new FlxTypedGroup<Coin>();
		add(coins);

		// Tutorial texts
		tutorialTexts = new FlxTypedGroup<TutorialText>();
		add(tutorialTexts);

		// Pistons
		pistons = new FlxTypedGroup<Piston>();
		add(pistons);

		// Doors
		doors = new FlxTypedGroup<Door>();
		add(doors);

		// Keys
		keys = new FlxTypedGroup<Key>();
		add(keys);

		// Player
		player = new Player(this, onMove);
		map.loadEntities(placeEntities, "Entities");
		add(player);
		add(finish);

		// Camera
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.camera.follow(player, TOPDOWN_TIGHT, 1);
		var cameraPadding = tileSize;
		FlxG.camera.setScrollBoundsRect(walls.x
			- cameraPadding, walls.y
			- cameraPadding
			- Hud.HEIGHT, walls.width
			+ (cameraPadding * 2),
			walls.height
			+ (cameraPadding * 2)
			+ Hud.HEIGHT, true);

		// Virtual pad
		var useVirtualPad = false;
		#if js
		if (FlxG.html5.onMobile) {
			useVirtualPad = true;
		}
		#end
		#if mobile
		useVirtualPad = true;
		#end

		if (useVirtualPad) {
			virtualPad = new FlxVirtualPad(FULL, NONE);
			virtualPad.alpha = 0.55;
			add(virtualPad);
		}

		Utils.hideMouse();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		// Wait half a second to start
		startTimer += elapsed;
		if (startTimer > 0.5 && !started) {
			frozen = false;
			started = true;
		}

		if (FlxG.collide(walls, player) || FlxG.collide(doors, player)) {
			player.hitWall();
		}

		FlxG.overlap(player, coins, playerTouchCoin);
		FlxG.overlap(player, keys, playerTouchKey);
		FlxG.overlap(player, finish, playerTouchFinish);
	}

	function playerTouchCoin(player:Player, coin:Coin) {
		if (player.alive && player.exists && coin.alive && coin.exists) {
			coin.kill();
			foundCoins++;
			// coinSound.play(true);
			playState.collectCoin();
		}
	}

	function playerTouchFinish(player:Player, finish:Finish) {
		if (player.alive && player.exists && finish.alive && finish.exists) {
			player.finish();
			frozen = true;
			finish.kill();
			if (virtualPad != null) {
				virtualPad.kill();
			}

			// Don't play sound when killing (unloading) after level
			for (key in keys) {
				key.alive = false;
			}
			for (coin in coins) {
				coin.alive = false;
			}

			playState.finishLevel(foundCoins, coins.length);

		
		}
	}

	function playerTouchKey(player:Player, key:Key) {
		if (player.alive && player.exists && key.alive && key.exists) {
			key.kill();
			for (door in doors) {
				if (door.id == key.door) {
					door.kill();
					break;
				}
			}
		}
	}

	function placeEntities(entity:EntityData) {
		var x = entity.x;
		var y = entity.y;

		switch (entity.name) {
			case "Player":
				player.setPosition(x, y);

			case "Coin":
				coins.add(new Coin(x, y));

			case "TutorialText":
				tutorialTexts.add(new TutorialText(x, y, entity.width, entity.values.text, entity.values.alignment));

			case "Piston":
				pistons.add(new Piston(x, y, Direction.fromString(entity.values.direction)));

			case "Key":
				keys.add(new Key(x, y, entity.values.door));

			case "Door":
				doors.add(new Door(x, y, entity.values.id));

			case "Finish":
				// Only one finish
				if (finish != null) {
					return;
				}

				finish = new Finish(x, y);
		}
	}

	function onMove() {
		if (player.alive && player.exists) {
			playState.addMove();
		}
	}
}
