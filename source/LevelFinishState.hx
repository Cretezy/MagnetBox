import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class LevelFinishState extends FlxTypedGroup<FlxSprite> {
	static inline var STATS_PADDING = 10;

	var nextButton:MetalButton;
	var background:FlxSprite;
	var levelStats:StatDisplay;
	var onNext:() -> Void;

	public function new(onNext:() -> Void, levelFoundCoins:Int, levelTotalCoins:Int, levelTimer:Float, levelMoves:Int) {
		super();
		this.onNext = onNext;

		Utils.showMouse();

		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x55000000);
		add(background);

		nextButton = new MetalButton(0, 0, "NEXT LEVEL", onNext);
		nextButton.screenCenter();
		nextButton.onUp.sound = FlxG.sound.load(AssetPaths.click__ogg);
		add(nextButton);

		levelStats = new StatDisplay(0, nextButton.y + nextButton.height + STATS_PADDING,true, "Level", levelFoundCoins, levelTotalCoins, levelTimer, levelMoves);
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
