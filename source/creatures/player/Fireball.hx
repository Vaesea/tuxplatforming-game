package creatures.player;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Fireball extends FlxSprite
{
    var moveSpeed = 440;
    var jumpHeight = 320;
    var gravity = 1000;

    public var direction = -1;

    var howManyBounces = 3;
    var bounces = 0;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        loadGraphic("assets/images/objects/fireball.png", false);

        acceleration.y = gravity;
    }

    override public function update(elapsed:Float)
    {
        velocity.x = direction * moveSpeed;

        if (justTouched(FLOOR))
        {
            velocity.y -= jumpHeight;
            bounces += 1;
        }

        if (bounces >= howManyBounces)
        {
            kill();
        }

        if (justTouched(WALL) || justTouched(CEILING))
        {
            kill();
        }

        super.update(elapsed);
    }
}