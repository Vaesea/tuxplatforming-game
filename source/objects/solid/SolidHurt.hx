package objects.solid;

import creatures.player.Tux;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class SolidHurt extends FlxSprite
{
    public function new(x:Float, y:Float, width:Int, height:Int)
    {
        super(x, y);
        makeGraphic(width, height, FlxColor.TRANSPARENT);
        solid = true;
        immovable = true;
    }

    public function interact(tux:Tux)
    {
        tux.takeDamage(1);
    }
}