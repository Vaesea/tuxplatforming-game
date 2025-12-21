package creatures.desert;

import creatures.player.Fireball;
import creatures.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;

class SharpStone extends Enemy
{
    // Spritesheet
    var sharpStoneImage = FlxAtlasFrames.fromSparrow("assets/images/characters/sharp-stone.png", "assets/images/characters/sharp-stone.xml");

    var point:FlxSprite;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        // Spritesheet
        frames = sharpStoneImage;

        // Animations
        animation.addByPrefix('walk', 'walk', 10, true);
        animation.play('walk');

        // Hitbox
        setSize(16, 22);
        offset.set(7, 10);

        // Ground Detection Point
        point = new FlxSprite();
        point.makeGraphic(1, 1, FlxColor.TRANSPARENT);
        Global.PS.add(point);
    }

    override private function move()
    {
        // A lot of this code is from another game I'm making.

        // Ground Detector variables for point.
        // Reminder that AnatolyStev worked on that other game and this groundDetector code probably made by him? I'm not sure actually.
        var groundDetectorX = if (direction == 1) { x + this.width + 1; } else { x - 1; }
        var groundDetectorY = y + this.height + offset.y + 1;

        // If alive, set position of points.
        if (currentState == Alive)
        {
            point.setPosition(groundDetectorX, groundDetectorY);
        }

        var hasGround = false;

        // Check for no solid objects
        if (FlxG.overlap(point, Global.PS.solidObjects))
        {
            hasGround = true;
        }

        // If there's no ground at the point and the current state is alive, flip direction.
        if (!hasGround && currentState == Alive)
        {
            flipDirection();
        }

        // Make him move, Enemy.hx handles the rest of what Sharp Stone does.
        velocity.x = direction * walkSpeed;
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