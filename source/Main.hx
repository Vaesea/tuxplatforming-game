package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.MainMenuState;

class Main extends Sprite
{
	public function new()
	{
		super();

		// Initialize save and load progress
		Global.initSave();
		Global.loadProgress();
		
		// Loading worldmaps (Will cause a crash if not done!)
		Global.loadWorldmaps();

		// Load game
		addChild(new FlxGame(0, 0, MainMenuState));
	}
}
