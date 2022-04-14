package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class StatDisplay extends FlxSpriteGroup {
	var titleText:FlxText;
	var timerText:FlxText;
	var coinText:FlxText;
	var movesText:FlxText;

	public static inline var HEIGHT = 32;
	static inline var MONEY_PADDING = 4;
	static inline var MONEY_TEXT_SIZE = 8;
	static inline var MONEY_ICON_TEXTURE_SIZE = 32;
	static inline var MONEY_ICON_RIGHT_PADDING = 4;
	static inline var TIMER_PADDING = 16;

	public function new(x:Float = 0, y:Float = 0, vertical:Bool = true, title:String, foundCoins:Int, totalCoins:Int, timer:Float, moves:Int) {
		super(x, y);

		function flow(previous:FlxSprite, next:FlxSprite, padding = 8) {
			if (vertical) {
				next.x = previous.getMidpoint().x - (next.width / 2);
				next.y = previous.y + previous.height + padding;
			} else {
				next.x = previous.x + previous.width + padding;
				next.y = previous.getMidpoint().y - (next.height / 2);
			}
		}

		titleText = new FlxText(0, 0, 0, title + ":", MONEY_TEXT_SIZE);
		add(titleText);

		coinText = new FlxText(0, 0, 0, "Found " + foundCoins + " of " + totalCoins + " coins!");
		add(coinText);
		flow(titleText, coinText);

		timerText = new FlxText(0, 0, 0, Utils.floatToStringPrecision(timer, 3) + "s");
		add(timerText);
		flow(coinText, timerText);

		movesText = new FlxText(0, 0, 0, moves + " moves");
		add(movesText);
		flow(timerText, movesText);

		if (vertical) {
			// Offset so all elements are positive x from x = [Inf, Inf] to x = [0, Inf]
			var biggestWidth = 0.0;
			var biggestOffset = 0.0;

			for (i in group.members) {
				if (i.width > biggestWidth) {
					biggestWidth = i.width;
					biggestOffset = i.x;
				}
			}
			for (i in group.members) {
				i.x -= biggestOffset;
			}
		}
	}
}
