package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Hud extends FlxTypedGroup<FlxSprite> {
	public var background:FlxSprite;
	var moneyCounter:FlxText;
	var moneyIcon:FlxSprite;
	var movesCounter:FlxText;
	var timerCounter:FlxText;

	public static inline var HEIGHT = 32;
	static inline var MONEY_PADDING = 4;
	static inline var MONEY_TEXT_SIZE = 8;
	static inline var MONEY_ICON_TEXTURE_SIZE = 32;
	static inline var MONEY_ICON_RIGHT_PADDING = 4;
	static inline var TIMER_PADDING = 16;

	public function new() {
		super();

		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, HEIGHT, FlxColor.BLACK);
		// Bottom white 1px border
		background.drawRect(0, HEIGHT - 1, FlxG.width, 1, FlxColor.WHITE);
		add(background);

		moneyIcon = new FlxSprite(FlxG.width - MONEY_ICON_TEXTURE_SIZE - MONEY_ICON_RIGHT_PADDING, (HEIGHT / 2) - (MONEY_ICON_TEXTURE_SIZE / 2),
			AssetPaths.coin__png);
		add(moneyIcon);

		moneyCounter = new FlxText(0, 0, 0, "0", MONEY_TEXT_SIZE);
		moneyCounter.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);

		// Put money counter to the right of the icon, centered
		moneyCounter.alignment = RIGHT;
		moneyCounter.x = moneyIcon.x - moneyCounter.width - MONEY_PADDING;
		moneyCounter.y = (HEIGHT / 2) - (moneyCounter.height / 2);
		add(moneyCounter);

		movesCounter = new FlxText(0, 0, 0, "Moves: 0", MONEY_TEXT_SIZE);
		movesCounter.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		movesCounter.y = (HEIGHT / 2) - (movesCounter.height / 2);
		add(movesCounter);

		timerCounter = new FlxText(0, 0, 0, "", MONEY_TEXT_SIZE);
		timerCounter.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		timerCounter.x = movesCounter.x + movesCounter.width + TIMER_PADDING;
		timerCounter.y = (HEIGHT / 2) - (timerCounter.height / 2);
		add(timerCounter);

		updateHud(0, 0, 0);

		// Don't scroll
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	public function updateHud(money:Int, moves:Int, timer:Float) {
		moneyCounter.text = Std.string(money);
		movesCounter.text = Std.string("Moves: " + moves);
		timerCounter.text = Utils.floatToStringPrecision(timer, 2) + "s";
	}
}
