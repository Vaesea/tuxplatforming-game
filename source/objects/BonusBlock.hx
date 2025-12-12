package objects;

import creatures.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.powerups.Candle;
import objects.powerups.Crystal;

class BonusBlock extends FlxSprite
{
    public var content:String;
    public var isEmpty = false;
    var HFraycast2d:FlxSprite; // it's BASICALLY a raycast2d, right??

    var blockImage = FlxAtlasFrames.fromSparrow('assets/images/objects/bonusblock.png', 'assets/images/objects/bonusblock.xml');

    public function new(x:Float, y:Float)
    {
        super(x, y);
        solid = true;
        immovable = true;

        frames = blockImage;
        animation.addByPrefix('full', 'normal', 12, true); // I messed up and used default settings for the FNF Spritesheet and XML generator.
        animation.addByPrefix('empty', 'empty', 12, false);
        animation.play("full");

        HFraycast2d = new FlxSprite(x + 8, y + height);
        HFraycast2d.makeGraphic(Std.int(width) - 16, Std.int(height) + 3, FlxColor.TRANSPARENT); // all this STD is gonna give me a... Nevermind. Forget about it. Std.int is there because width and height need to be ints.
        HFraycast2d.immovable = true;
        HFraycast2d.solid = false;
    }

    public function hit(tux:Tux)
    {
        if (HFraycast2d.overlaps(tux) == false)
        {
            return;
        }

        if (isEmpty == false) // No more TODO :)
        {
            isEmpty = true;
            createItem();
            FlxTween.tween(this, {y: y - 4}, 0.05) .wait(0.05) .then(FlxTween.tween(this, {y: y}, 0.05, {onComplete: empty}));
        }
    }

    function empty(_)
    {
        animation.play("empty");
    }

    function createItem()
    {
        FlxG.sound.play("assets/sounds/impact.ogg");
        switch (content)
        {
            default:
                var coin:Coin = new Coin(Std.int(x), Std.int(y - 32));
                coin.setFromBlock();
                Global.PS.items.add(coin);
            
            case "candle":
                var candle:Candle = new Candle(Std.int(x + 7), Std.int(y - 42));
                Global.PS.items.add(candle);
                FlxG.sound.play("assets/sounds/powerupbox.ogg");
            
            case "crystal":
                var crystal:Crystal = new Crystal(Std.int(x - 6), Std.int(y - 32));
                Global.PS.items.add(crystal);
                FlxG.sound.play("assets/sounds/powerupbox.ogg");
        }
    }
}