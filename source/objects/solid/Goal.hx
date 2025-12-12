package objects.solid;

// Worldmap support by AnatolyStev

import creatures.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import worldmap.WorldmapState.WorldMapState; // TODO: Change spelling of WorldMapState to WorldmapState

class Goal extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        solid = true;
        immovable = true;
        makeGraphic(2, FlxG.height * 16, FlxColor.TRANSPARENT);
    }

    public function reach(tux:Tux)
    {
        if (solid)
        {
            solid = false;
            
            Global.tuxState = tux.currentState;

            if (!Global.completedLevels.contains(Global.currentLevel))
            {
                Global.completedLevels.push(Global.currentLevel);
            }

            if (FlxG.sound.music != null) // Check if song is playing, if it is, stop song. This if statement is here just to avoid a really weird crash.
            {
                FlxG.sound.music.stop();
            }

            Global.saveProgress();
            FlxG.switchState(WorldMapState.new);
        }
    }
}