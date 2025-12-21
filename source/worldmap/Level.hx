package worldmap;

// Made by AnatolyStev

import flixel.FlxSprite;

class Level extends FlxSprite
{
    // "Settings"
    public var ldLevelPath:String;
    public var ldSection:String;
    public var isCompleted = false;
    public var ldDisplayName:String;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        
        // Load spritesheet (32x32 spritesheet so it doesn't need to be an xml spritesheet)
        loadGraphic("assets/images/worldmap/levelsquares.png", true, 32, 32);

        // Add animations, frame 3 (would be 2 here) is unused, was meant for a "Hard Level" type of level.
        animation.add("red", [0], 1.0, true);
        animation.add("green", [1], 1.0, true);
    }

    // Setup the level square
    public function setup(levelPath:String, section:String, displayName:String)
    {
        ldLevelPath = levelPath;
        ldSection = section;
        ldDisplayName = displayName;
    }

    // When level is completed, turn green.
    public function completeLevel()
    {
        isCompleted = true;
        animation.play("green");
    }

    // Make sure that if it's completed, turn green. If not completed, stay red.
    override public function update(elapsed:Float)
    {
        if (isCompleted == true)
        {
            animation.play("green");
        }
        else
        {
            animation.play("red");
        }
    }
}