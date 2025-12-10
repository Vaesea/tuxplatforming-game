package states.substates;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class LevelIntro extends FlxSubState
{
    var readyText:FlxText;
    var titleText:FlxText;
    var creatorText:FlxText;

    var gameOver = false;
    var waitTime = 2;

    override public function create()
    {
        super.create();

        // Check if song is playing, if it is, stop song. This if statement is here just to avoid a really weird crash.
        if (FlxG.sound.music != null)
        {
            FlxG.sound.music.stop();
        }

        // Create Title Text
        titleText = new FlxText(0, 5, 0, Global.levelName, 18);
        titleText.setFormat(null, 18, FlxColor.BLACK, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
        titleText.scrollFactor.set();
        titleText.screenCenter(X);
        titleText.borderSize = 1.25;

        // Create Creator Text
        creatorText = new FlxText(0, 25, 0, Global.creatorOfLevel, 18);
        creatorText.setFormat(null, 18, FlxColor.BLACK, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
        creatorText.scrollFactor.set();
        creatorText.screenCenter(X);
        creatorText.borderSize = 1.25;

        // Create Ready Text
        readyText = new FlxText(0, 0, 0, "Get Ready!", 18);
        readyText.setFormat(null, 18, FlxColor.BLACK, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
        readyText.scrollFactor.set();
        readyText.screenCenter();
        readyText.borderSize = 1.25;

        // Add all text
        add(titleText);
        add(creatorText);
        add(readyText);

        // Start a timer, when it's done, play the music and close the substate.
        new FlxTimer().start(waitTime, function(_)
        {
            if (Global.currentSong != null) // If it's null and this isn't done, the game will crash.
            {
                FlxG.sound.playMusic(Global.currentSong, 1.0, true);
            }
            close();
        } , 1);
    }
}