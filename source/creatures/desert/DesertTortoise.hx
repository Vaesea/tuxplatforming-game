package creatures.desert;

import flixel.graphics.frames.FlxAtlasFrames;

class DesertTortoise extends Enemy
{
    var desertTortoiseImage = FlxAtlasFrames.fromSparrow("assets/images/characters/desert-tortoise.png", "assets/images/characters/desert-tortoise.xml");

    public function new (x:Float, y:Float)
    {
        super(x, y);

        frames = desertTortoiseImage;
        animation.addByPrefix('walk', 'walk', 10, true);
        animation.addByPrefix('flat', 'flat', 10, false);
        animation.play('walk');

        setSize(32, 29);
        offset.set(13, 7);

        canBeHeld = true;
    }

    override private function move()
    {
        if (currentHeldEnemyState == MovingSquished)
        {
            velocity.x = direction * walkSpeed * 6;
        }
        else if (currentHeldEnemyState == Squished || currentHeldEnemyState == Held)
        {
            velocity.x = 0;

            if (currentHeldEnemyState == Held)
            {
                velocity.y = 0;
            }
        }
        else
        {
            velocity.x = direction * walkSpeed;
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (currentHeldEnemyState == Held && held != null)
        {
            if (held.flipX == true)
            {
                x = held.x - 11;
            }
            else if (held.flipX == false)
            {
                x = held.x + 11;
            }

            y = held.y;
            flipX = !held.flipX;
        }
    }
}