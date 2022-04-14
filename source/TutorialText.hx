package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class TutorialText extends FlxText {
	static inline var PADDING = 1;

	public function new(x:Float = 0, y:Float = 0, width:Float = 0, text:String, alignment:FlxTextAlign) {
		super(x + PADDING, y + PADDING, width - (PADDING * 2));
		this.text = text;
		this.alignment = alignment;
	}
}
