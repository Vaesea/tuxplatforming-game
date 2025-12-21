package worldmap;

// Made by AnatolyStev, loads Worldmap.

// More comments will be added soon.

import flixel.FlxState;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.tile.FlxTilemap;
import objects.solid.Solid;
import worldmap.Level;
import worldmap.WorldmapState;

class WorldmapLoader extends FlxState
{
    public static function loadWorldmap(state:WorldMapState, worldmap:String)
    {
        // Load worldmap
        var tiledMap = new TiledMap("assets/data/worldmaps/" + worldmap + ".tmx");

        // Get properties from worldmap file
        var song = tiledMap.properties.get("Music");
        var worldmapName = tiledMap.properties.get("Worldmap Name");
        var worldmapCreator = tiledMap.properties.get("Worldmap Creator");

        // Set worldmap name to Tiled worldmap's worldmap name. May be used for the HUD.
        // Set worldmap creator to Tiled worldmap's worldmap creator. May be used for the HUD.
        // Set current song to Tiled worldmap's song. Used for playing the correct song in-game.
        Global.worldmapName = worldmapName;
        Global.worldmapCreator = worldmapCreator;
        Global.currentSong = song;

        // Water
        var waterLayer:TiledTileLayer = cast tiledMap.getLayer("Water");

        var waterMap = new FlxTilemap();
        waterMap.loadMapFromArray(waterLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 1);
        waterMap.solid = false;

        // Main
        var mainLayer:TiledTileLayer = cast tiledMap.getLayer("Main");

        state.map = new FlxTilemap();
        state.map.loadMapFromArray(mainLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 1);
        state.map.solid = false;

        // Foreground 1
        var foregroundOneLayer:TiledTileLayer = cast tiledMap.getLayer("Decorations");
        
        var foregroundOneMap = new FlxTilemap();
        foregroundOneMap.loadMapFromArray(foregroundOneLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 1);
        foregroundOneMap.solid = false;

        // Foreground 2
        var foregroundTwoLayer:TiledTileLayer = cast tiledMap.getLayer("Decorations 2");
        
        var foregroundTwoMap = new FlxTilemap();
        foregroundTwoMap.loadMapFromArray(foregroundTwoLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 1);
        foregroundTwoMap.solid = false;

        // Foreground 3
        var foregroundThreeLayer:TiledTileLayer = cast tiledMap.getLayer("Decorations 3");
        
        var foregroundThreeMap = new FlxTilemap();
        foregroundThreeMap.loadMapFromArray(foregroundThreeLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 1);
        foregroundThreeMap.solid = false;

        // Foreground 4
        var foregroundFourLayer:TiledTileLayer = cast tiledMap.getLayer("Decorations 4");
        
        var foregroundFourMap = new FlxTilemap();
        foregroundFourMap.loadMapFromArray(foregroundFourLayer.tileArray, tiledMap.width, tiledMap.height, "assets/images/tiles.png", 32, 32, 1);
        foregroundFourMap.solid = false;

        // Add tiles
        state.add(waterMap);
        state.add(state.map);
        state.add(foregroundOneMap);
        state.add(foregroundTwoMap);
        state.add(foregroundThreeMap);
        state.add(foregroundFourMap);

        // For anything in solid, add solid square.
        for (solid in getLevelObjects(tiledMap, "Solid"))
        {
            var solidSquare = new Solid(solid.x, solid.y, solid.width, solid.height); // Need this because width and height.
            state.collision.add(solidSquare);
        }

        // For anything in levels, add Level Square
        for (object in getLevelObjects(tiledMap, "Levels"))
        {
            var levelPath = object.properties.get("path");
            var section = object.properties.get("section");
            var displayName = object.properties.get("displayName"); // Unused for now

            var levelDot = new Level(object.x, object.y - 32);
            levelDot.setup(levelPath, section, displayName);
            state.levels.add(levelDot);
        }

        // For anythng in rocks, add rock. Make sure that when you add a rock, it has a section.
        for (object in getLevelObjects(tiledMap, "Rocks"))
        {
            var section = object.properties.get("section");
            
            var rock = new Rock(object.x, object.y - 32);
            rock.theRock(section);
            state.rocks.add(rock);
        }

        // Don't know why this is named tuxPosition? Could just be named Tux in my opinion.
        // Used for code below.
        var tuxPosition:TiledObject = getLevelObjects(tiledMap, "Player")[0];
        
        // If Global.tuxWorldmapX and Y are 0, set Tux's position to Tux's position in the worldmap's Tiled file - 6. The number 6 should be changed soon, but that's not a priority, as long as it works.
        if (Global.tuxWorldmapX == 0 && Global.tuxWorldmapY == 0)
        {
            state.tux.setPosition(tuxPosition.x, tuxPosition.y - 6);
        }
        else
        {
            state.tux.setPosition(Global.tuxWorldmapX, Global.tuxWorldmapY);
        }
    }

    // Get level objects, if there's a missing object layer, print something. 
    public static function getLevelObjects(map:TiledMap, layer:String):Array<TiledObject>
    {
        if ((map != null) && (map.getLayer(layer) != null))
        {
            var objLayer:TiledObjectLayer = cast map.getLayer(layer);
            return objLayer.objects;
        }
        else
        {
            trace("Object layer " + layer + " not found! Also credits to Discover Haxeflixel.");
            return [];
        }
    }
}