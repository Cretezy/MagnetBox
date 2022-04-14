package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxColor;

class PlayState extends FlxState {
	var level:Level;

	var money:Int = 0;
	var moves:Int = 0;
	var hud:Hud;
	var timer:Float;
	var levelTimer:Float;
	var levelMoves:Int;
	var finishedState:FlxTypedGroup<FlxSprite>;
	var totalCoins = 0;

	var levelIndex = 0;

	var levels:Array<String>;

	public function new(levels:Array<String>) {
		super();
		this.levels = levels;
	}

	override public function create() {
		hud = new Hud();
		loadLevel();

		super.create();

		// FlxG.debugger.drawDebug = true;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (level != null && !level.frozen) {
			timer += elapsed;
			levelTimer += elapsed;
			updateHud();
		}
	}

	public function collectCoin() {
		money++;
		updateHud();
	}

	public function addMove() {
		moves++;
		levelMoves++;
		updateHud();
	}

	public function updateHud() {
		hud.updateHud(money, moves, timer);
	}

	public function finishLevel(levelFoundCoins:Int, levelTotalCoins:Int) {
		totalCoins += levelTotalCoins;

		if (levels.length == levelIndex + 1) {
			finishedState = new GameFinishState(function() {
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, onReset);
			}, levelFoundCoins, levelTotalCoins, money, totalCoins, levelTimer,
				timer, levelMoves, moves);
			add(finishedState);
		} else {
			finishedState = new LevelFinishState(function() {
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, onNext);
			}, levelFoundCoins, levelTotalCoins, levelTimer, levelMoves);
			add(finishedState);
		}

		levelMoves = 0;
	}

	function onNext() {
		finishedState.kill();
		levelIndex++;
		loadLevel();
	}

	function onReset() {
		FlxG.switchState(new MenuState());
	}

	public function loadLevel() {
		if (level != null) {
			level.kill();
		}

		level = new Level(this, levels[levelIndex]);
		add(level);

		remove(hud, true);
		add(hud);

		levelTimer = 0;
	}
}
