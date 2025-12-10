package creatures.desert;

import flixel.graphics.frames.FlxAtlasFrames;

class SandMonster extends Enemy
{
    // Spritesheet
    var sandMonsterImage = FlxAtlasFrames.fromSparrow("assets/images/characters/sandmonster.png", "assets/images/characters/sandmonster.xml");

    public function new(x:Float, y:Float)
    {
        super(x, y);

        // Spritesheet
        frames = sandMonsterImage;

        // Animations
        animation.addByPrefix('walk', 'walk', 10, true);
        animation.addByPrefix('squished', 'squished', 10, false);
        animation.play('walk');

        // Hitbox
        setSize(32, 24);
        offset.set(6, 14);
    }

    override private function move()
    {
        // Make him move, Enemy.hx handles the rest of what Sand Monster does.
        velocity.x = direction * walkSpeed;
    }
}