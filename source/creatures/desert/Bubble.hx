package creatures.desert;

import creatures.player.Fireball;
import creatures.player.Tux;
import flixel.graphics.frames.FlxAtlasFrames;

class Bubble extends Enemy
{
    // Jumping height
    var bounceHeight = 576;

    // Spritesheet
    var jumpyImage = FlxAtlasFrames.fromSparrow("assets/images/characters/bubble.png", "assets/images/characters/bubble.xml");

    public function new(x:Float, y:Float)
    {
        super(x, y);

        // Spritesheet and animation
        frames = jumpyImage;
        animation.addByPrefix('jump', 'jump', 8, false);

        loadWhenLevelLoads = true;
        
        // Add gravity from Enemy.hx
        acceleration.y = gravity;

        // Hitbox
        setSize(26, 26);
        offset.set(3, 6);
    }

    override private function move()
    {
        // When touching floor, jump!
        if (isTouching(FLOOR))
        {
            velocity.y = -bounceHeight;
            animation.play('jump');
        }
    }

    override public function interact(tux:Tux)
    {
        // If currently alive, damage Tux.
        if (currentState == Alive)
        {
            tux.takeDamage(1);
        }
    }

    // Kill fireball, don't take damage.
    override public function collideFireball(fireball:Fireball)
    {
        fireball.kill();
    }
}