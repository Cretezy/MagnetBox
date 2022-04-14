package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Coin extends FlxSprite {
	var pickupSound:FlxSound;

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		loadGraphic(AssetPaths.coin__png, true, 32, 32);
		pickupSound = FlxG.sound.load(AssetPaths.pickup__ogg);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	override function kill() {
		// Don't play sound if already dead
		if (!alive)
			return;

		alive = false;
		pickupSound.play();

		FlxTween.tween(this, {alpha: 0, y: y - 8}, 0.33, {ease: FlxEase.circOut, onComplete: finishKill});
	}

	function finishKill(_) {
		exists = false;
	}
}
