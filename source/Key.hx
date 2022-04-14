package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Key extends FlxSprite {
	public var door:Int;

	var pickupSound:FlxSound;

	public function new(x:Float = 0, y:Float = 0, door:Int) {
		super(x, y);
		this.door = door;

		loadGraphic(AssetPaths.key__png, true, 32, 32);
		pickupSound = FlxG.sound.load(AssetPaths.pickup__ogg);
	}

	override function kill() {
		// Don't play sound if already dead
		if (!alive)
			return;

		alive = false;
		pickupSound.play();

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
