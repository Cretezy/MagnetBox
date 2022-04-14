package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Finish extends FlxSprite {
	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		loadGraphic(AssetPaths.star__png, true, 32, 32);
	}

	override function kill() {
		alive = false;

		// Fake rotate
		FlxTween.tween(this, {"scale.x": 0}, 0.25, {
			ease: FlxEase.circOut,
			onComplete: function(_) {
				FlxTween.tween(this, {alpha: 0, y: y - 8}, 0.5, {ease: FlxEase.circOut, onComplete: finishKill});

				FlxTween.tween(this, {"scale.x": 1}, 0.25, {
					ease: FlxEase.circOut,
					onComplete: function(_) {}
				});
			}
		});
	}

	function finishKill(_) {
		exists = false;
	}
}
