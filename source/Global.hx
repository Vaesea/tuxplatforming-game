package;

import states.PlayState;

class Global
{
    // Tux
    public static var coins = 0;
    public static var score = 0;
    public static var maxHealth = 3;
    public static var health = 3;

    // PlayState can now have stuff from it used from all things
    public static var PS:PlayState;

    // Levels
    public static var levels:Array<String> = ["test"];
    public static var currentLevel = 0;
    public static var levelName:String;
    public static var creatorOfLevel:String;

    // Music
    public static var currentSong:String;
}