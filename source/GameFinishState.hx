import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class GameFinishState extends FlxTypedGroup<FlxSprite> {
	static inline var COINS_TEXT_PADDING = 10;
	static inline var TITLE_TEXT_PADDING = 24;
	static inline var STATS_PADDING = 14;

	var nextButton:MetalButton;
	var titleText:FlxText;
	var levelStats:StatDisplay;
	var gameStats:StatDisplay;
	var background:FlxSprite;
	var onNext:() -> Void;

	public function new(onNext:() -> Void, levelFoundCoins:Int, levelTotalCoins:Int, gameFoundCoins:Int, gameTotalCoins:Int, levelTimer:Float,
			gameTimer:Float, levelMoves:Int, gameMoves:Int) {
		super();
		this.onNext = onNext;

		Utils.showMouse();

		// Background
		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x55000000);
		add(background);

		// Title
		titleText = new FlxText(0, 0, 0, "Finished game!", 16);
		titleText.screenCenter();
		titleText.y -= (titleText.height / 2) + TITLE_TEXT_PADDING;
		add(titleText);

		// Next
		nextButton = new MetalButton(0, 0, "BACK TO MENU", onNext);
		nextButton.screenCenter();
		nextButton.onUp.sound = FlxG.sound.load(AssetPaths.click__ogg);
		add(nextButton);

		// Stats
		gameStats = new StatDisplay(0, nextButton.y + nextButton.height + STATS_PADDING, false, "Game", gameFoundCoins, gameTotalCoins, gameTimer, gameMoves);
		gameStats.screenCenter(X);
		add(gameStats);

		levelStats = new StatDisplay(0, gameStats.y + gameStats.height + STATS_PADDING, false, "Level", levelFoundCoins, levelTotalCoins, levelTimer,
			levelMoves);
		levelStats.screenCenter(X);
		add(levelStats);

		// Sound
		FlxG.sound.load(AssetPaths.finish__ogg).play();

		// Don't scroll
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);


		if (FlxG.keys.anyPressed([SPACE, ENTER]) || (FlxG.gamepads.lastActive != null && FlxG.gamepads.lastActive.pressed.A)) {
			onNext();
		}
	}
}
