package objects.powerups;

import creatures.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;

class Crystal extends FlxSprite
{
    var scoreAmount = 75;
    var gravity = 1000;
    var direction = 1;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        
        // Load image
        loadGraphic('assets/images/objects/powerups/crystal.png', false);

        // Make sure it's solid
        solid = true;

        // Add gravity
        acceleration.y = gravity;

        // Hitbox
        setSize(44, 32);
        offset.set(10, 0);
    }

    // Called when Tux touches a crystal
    public function collect(tux:Tux)
    {
        // Play sound
        FlxG.sound.play('assets/sounds/tuxyay.ogg');

        // Kill power-up (so it doesn't stay)
        kill();

        // Heal Tux
        tux.heal(1);

        // Add scoreAmount to Global.score
        Global.score += scoreAmount;
    }
}