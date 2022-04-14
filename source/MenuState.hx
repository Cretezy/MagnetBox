package;

import flash.events.Event;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import lime.utils.Assets;
#if html5
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.net.FileFilter;
import openfl.net.FileReference;
#end

class MenuState extends FlxState {
	var playButton:MetalButton;
	var title:FlxSprite;
	var fullscreenButton:MetalButton;
	var musicButton:MetalButton;
	var loadLevelButton:MetalButton;

	override public function create() {
		Utils.showMouse();

		// Play
		playButton = new MetalButton(0, 0, "PLAY GAME", onPlay, 120, 30, 12);
		playButton.screenCenter();
		playButton.onUp.sound = FlxG.sound.load(AssetPaths.click__ogg);
		add(playButton);

		// Title
		title = new FlxSprite(0, 0, AssetPaths.title__png);
		title.screenCenter(X);
		title.y = playButton.y - title.height - 10;
		add(title);

		// Music button
		musicButton = new MetalButton(0, playButton.y + playButton.height + 8, "", clickMusic, 100);
		musicButton.screenCenter(X);
		musicButton.onUp.sound = FlxG.sound.load(AssetPaths.click__ogg);
		add(musicButton);

		// Fullscreen button
		#if (desktop || html5)
		musicButton.x = musicButton.x - (musicButton.width / 2) - 8;

		fullscreenButton = new MetalButton(musicButton.x + musicButton.width + (8 * 2), playButton.y + playButton.height + 8, getFullscreenButtonText(),
			clickFullscreen, 100);

		fullscreenButton.onUp.sound = FlxG.sound.load(AssetPaths.click__ogg);
		add(fullscreenButton);
		#end

		// Start music
		clickMusic();

		// Load level button
		#if html5
		loadLevelButton = new MetalButton(0, musicButton.y + musicButton.height + 8, "LOAD LEVEL", clickLoadLevel, 100);
		loadLevelButton.screenCenter(X);
		loadLevelButton.onUp.sound = FlxG.sound.load(AssetPaths.click__ogg);
		add(loadLevelButton);

		var levelEditorText = new FlxText(0, loadLevelButton.y + loadLevelButton.height + 8, "See project page for level editor", 8);
		levelEditorText.screenCenter(X);
		add(levelEditorText);
		#end

		super.create();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.anyPressed([SPACE, ENTER]) || (FlxG.gamepads.lastActive != null && FlxG.gamepads.lastActive.pressed.A)) {
			onPlay();
		}
	}

	function onPlay() {
		FlxG.switchState(new PlayState([
			Assets.getText(AssetPaths.Level_1__json),
			Assets.getText(AssetPaths.Level_2__json),
			Assets.getText(AssetPaths.Level_3__json)
		]));
	}

	function clickFullscreen() {
		FlxG.fullscreen = !FlxG.fullscreen;
		fullscreenButton.text = getFullscreenButtonText();
	}

	function getFullscreenButtonText() {
		return FlxG.fullscreen ? "EXIT FULLSCREEN" : "FULLSCREEN";
	}

	function clickMusic() {
		if (FlxG.sound.music == null) {
			FlxG.sound.playMusic(AssetPaths.music__ogg, 0.2, true);
		} else {
			FlxG.sound.music.stop();
			FlxG.sound.music = null;
		}

		musicButton.text = getMusicButtonText();
	}

	function getMusicButtonText() {
		return FlxG.sound.music != null ? "STOP MUSIC" : "PLAY MUSIC";
	}

	function clickLoadLevel() {
		#if html5
		var fr:FileReference = new FileReference();
		fr.addEventListener(Event.SELECT, _onSelect, false, 0, true);
		var filters:Array<FileFilter> = new Array<FileFilter>();
		filters.push(new FileFilter("JSON Files", "*.json"));
		fr.browse(filters);
		#end
	}

	function _onSelect(E:Event):Void {
		#if html5
		var fr:FileReference = cast(E.target, FileReference);
		fr.addEventListener(Event.COMPLETE, _onLoad, false, 0, true);
		fr.load();
		#end
	}

	function _onLoad(E:Event):Void {
		#if html5
		var fr:FileReference = cast E.target;
		fr.removeEventListener(Event.COMPLETE, _onLoad);

		FlxG.switchState(new PlayState([fr.data.toString()]));
		#end
	}
}
