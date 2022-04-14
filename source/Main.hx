package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.system.scaleModes.StageSizeScaleMode;
import openfl.display.Sprite;

class Main extends Sprite {
	public static var HEIGHT = 528;
	public static var WIDTH = 297;

	public function new() {
		super();
		addChild(new FlxGame(HEIGHT, WIDTH, MenuState));
	}
}
