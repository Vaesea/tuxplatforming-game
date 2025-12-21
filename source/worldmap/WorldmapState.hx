package worldmap;

// Made by AnatolyStev, worldmap PlayState.
// Improved by Vaesea to remove rock position stuff.

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import states.PlayState;

class WorldMapState extends FlxState
{
    // Create map
    public var map:FlxTilemap;

    // Load Objects
	public var collision(default, null):FlxTypedGroup<FlxSprite>;
	public var tux(default, null):WMTux;
	public var levels(default, null):FlxTypedGroup<Level>;
    public var rocks(default, null):FlxTypedGroup<Rock>;

    // Load HUD
    var hud:WorldmapHUD;

    override public function create()
    {
        // Mouse should not be visible.
        FlxG.mouse.visible = false;
        
        // Check if song is playing, if it is, stop song. This if statement is here just to avoid a really weird crash.
        if (FlxG.sound.music != null)
        {
            FlxG.sound.music.stop();
        }

        // Make sure Global.WMS works
        Global.WMS = this;

        // Add things part 1
        collision = new FlxTypedGroup<FlxSprite>();
        levels = new FlxTypedGroup<Level>();
        rocks = new FlxTypedGroup<Rock>();
        tux = new WMTux();
        
        // Load worldmap part 1
        var numberOfWorldmap = Global.worldmaps[Global.currentWorldmap];

        // Load worldmap part 2
        WorldmapLoader.loadWorldmap(this, numberOfWorldmap);
        
        // Check whether any rocks have been unlocked
        checkRockUnlocks();

        // Add things part 2
        hud = new WorldmapHUD();
        add(collision);
        add(levels);
        add(rocks);
        add(tux);
        add(hud);

        // Set Tux's position
        if (Global.tuxWorldmapX != 0 || Global.tuxWorldmapY != 0)
        {
            tux.x = Global.tuxWorldmapX;
            tux.y = Global.tuxWorldmapY;
        }

        // Create camera
        FlxG.camera.follow(tux, TOPDOWN, 1.0);
        FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);

        // If it's null and this isn't done, the game will crash.
        if (Global.currentSong != null)
        {
            FlxG.sound.playMusic(Global.currentSong, 1.0, true);
        }
    }

    // This checks whether any sections are completed, if yes, remove rock for that section.
    public function checkRockUnlocks()
    {
        for (rock in rocks)
        {
            if (rock.isGone) 
            {
                continue;
            }

            if (sectionCompleted(rock.rockSection))
            {
                rock.removeRock();
            }
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        // Tux collision
        FlxG.collide(collision, tux);
        FlxG.collide(rocks, tux);
        FlxG.overlap(tux, levels, overlapLevels);

        for (square in levels)
        {
            if (Global.completedLevels.contains(square.ldLevelPath))
            {
                square.completeLevel();
            }
        }

        // Is this needed? This might be able to be replaced with checkRockUnlocks()?
        for (rock in rocks)
        {
            if (rock.isGone)
            {
                continue;
            }

            if (sectionCompleted(rock.rockSection))
            {
                rock.removeRock();
            }
        }
    }

    // If Tux presses ENTER or SPACE on a Level Square, set Tux's position to level, save progress and start level.
    function overlapLevels(tux:WMTux, square:FlxSprite)
    {
        if (Std.isOfType(square, Level))
        {
            var level:Level = cast square; // I did a REALLY complicated thing here and I'm NOT even sure if it's needed

            Global.dotLevelName = level.ldDisplayName;

            if (FlxG.keys.anyJustPressed([SPACE, ENTER]))
            {
                Global.tuxWorldmapX = tux.x;
                Global.tuxWorldmapY = tux.y;
                Global.saveProgress();

                Global.currentLevel = level.ldLevelPath;
                Global.currentSection = level.ldSection;

                FlxG.switchState(PlayState.new);
            }
        }
    }

    // Check if section is completed
    function sectionCompleted(section:String)
    {
        for (square in levels)
        {
            if (square.ldSection == section && !Global.completedLevels.contains(square.ldLevelPath))
            {
                return false;
            }
        }
        return true;
    }

    // Never heard of this before, ask AnatolyStev.
    override public function destroy() 
    {
        Global.saveProgress();
        super.destroy();
    }
}