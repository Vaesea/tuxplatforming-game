package creatures.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

enum TuxStates
{
    Normal;
    Fire;
}

class Tux extends FlxSprite
{
    // Movement
    var tuxAcceleration = 2000;
    var deceleration = 1600;
    var gravity = 1000;
    public var minJumpHeight = 512;
    public var maxJumpHeight = 576;
    var walkSpeed = 320;

    // Health System
    var canTakeDamage = true;
    var invFrames = 1.0;

    // Direction
    public var direction = 1;

    // Holding Enemies
    public var heldEnemy:Enemy = null;

    // Current State
    public var currentState = Normal;

    // Fireball shooting variables
    public var canShoot = true;
    public var shootCooldown = 1.0;

    // Spritesheet
    var bigTuxImage = FlxAtlasFrames.fromSparrow("assets/images/characters/tux/tux.png", "assets/images/characters/tux/tux.xml");

    public function new()
    {
        super();

        // Spritesheet
        frames = bigTuxImage;
        animation.addByPrefix("stand", "stand", 10, false);
        animation.addByPrefix("walk", "walk", 10, true);
        animation.addByPrefix("jump", "jump", 10, false);
        animation.addByPrefix("duck", "duck", 10, false);
        animation.play("stand");
        
        // Hitbox
        setSize(22, 48);
        offset.set(15, 12);

        // Acceleration, deceleration and max velocity.
        drag.x = deceleration;
        acceleration.y = gravity;
        maxVelocity.x = walkSpeed;
    }

    override public function update(elapsed:Float)
    {
        // Stop Tux from falling off the map through the left
        if (x < 0)
        {
            x = 0;
        }

        // Kill Tux when he falls into the void
        if (y > Global.PS.map.height - height)
        {
            die();
        }

        // Functions
        move();
        animate();
        shootBall();

        if (heldEnemy != null)
        {
            if (FlxG.keys.justReleased.CONTROL)
            {
                throwEnemy();
            }
        }

        // Put this after everything
        super.update(elapsed);
    }

    // Animate Tux
    function animate()
    {
        // If Tux is on the floor and staying where he is, do stand animation
        if (velocity.x == 0 && isTouching(FLOOR))
        {
            animation.play("stand");
        }
        
        // If Tux is on the floor and not staying where he is, do walk animation
        if (velocity.x != 0 && isTouching(FLOOR))
        {
            animation.play("walk");
        }

        // If Tux is not on the floor, do jump animation
        // TODO: Is velocity.y != 0 needed?
        if (velocity.y != 0 && !isTouching(FLOOR))
        {
            animation.play("jump");
        }
    }

    function move()
    {
        // Speed is 0 at beginning
        acceleration.x = 0;

        // If player presses left keys, walk left
        if (FlxG.keys.anyPressed([LEFT, A]))
        {
            flipX = true;
            direction = -1;
            acceleration.x -= tuxAcceleration;
        }
        // If player presses right keys, walk right
        else if (FlxG.keys.anyPressed([RIGHT, D]))
        {
            flipX = false;
            direction = 1;
            acceleration.x += tuxAcceleration;
        }

        // If player pressing jump keys and is on ground, jump
        if (FlxG.keys.anyJustPressed([SPACE, W, UP]) && isTouching(FLOOR))
        {
            if (velocity.x == walkSpeed || velocity.x == -walkSpeed)
            {
                velocity.y = -maxJumpHeight;
            }
            else
            {
                velocity.y = -minJumpHeight;
            }

            FlxG.sound.play("assets/sounds/jump.ogg");
        }
        
        // Variable Jump Height
        if (velocity.y < 0 && FlxG.keys.anyJustReleased([SPACE, W, UP]))
        {
            velocity.y -= velocity.y * 0.5;
        }
    }

    // Name explains it
    public function holdEnemy(enemy:Enemy)
    {
        // If there's already a held enemy, don't do the rest of the function.
        if (heldEnemy != null)
        {
            return;
        }

        // If there's no held enemy and player is pressing control, pick up holdable enemy.
        if (FlxG.keys.pressed.CONTROL)
        {
            heldEnemy = enemy;
            enemy.pickUp(this);
        }
    }

    // Name explains it
    public function throwEnemy()
    {
        // If there's no held enemy, don't do the rest of the function.
        if (heldEnemy == null)
        {
            return;
        }

        // Throw enemy
        heldEnemy.enemyThrow();
        heldEnemy = null;
    }

    // Tux takes damage!
    public function takeDamage(damageAmount:Int)
    {
        // Shakes the camera, decreases health, plays a sound and does invincibility frames stuff. If Tux's health is 1 and he gets damaged, he dies.
        if (canTakeDamage)
        {
            if (currentState == Fire)
            {
                currentState = Normal;
                reloadGraphics();
            }
            Global.PS.camera.shake(0.05, 0.1);
            canTakeDamage = false;
            Global.health -= damageAmount;

            FlxG.sound.play("assets/sounds/tuxhurt.ogg");

            new FlxTimer().start(invFrames, function(_) 
            {
                canTakeDamage = true;
            }, 1);

            if (Global.health <= 0)
            {
                die();
            }
        }
    }

    // Heals Tux by increasing health.
    public function heal(healAmount:Int)
    {
        // If Global.health is less than Global.maxHealth, increase health by healAmount.
        if (Global.health < Global.maxHealth)
        {
            Global.health += healAmount;
        }
    }

    // Tux dies, will likely be changed to be a death animation similar to Super Mario Bros.
    public function die()
    {
        FlxG.resetState();
        currentState = Normal;
        reloadGraphics();
        Global.health = Global.maxHealth;
    }

    // Does what the name says, reloads graphics. This is taken from my other game I'm making.
    public function reloadGraphics()
    {
        animation.reset();

        switch(currentState)
        {
            case Normal:
                // Spritesheet
                var fixedMaybeOne = FlxAtlasFrames.fromSparrow("assets/images/characters/tux/tux.png", "assets/images/characters/tux/tux.xml");
                frames = fixedMaybeOne;
                animation.addByPrefix('stand', 'stand', 10, false);
                animation.addByPrefix('walk', 'walk', 10, true);
                animation.addByPrefix('jump', 'jump', 10, false);
                animation.addByPrefix('duck', 'duck', 10, false);
                animation.play('stand');

                // Hitbox
                setSize(22, 48);
                offset.set(15, 12);

            case Fire:
                // Spritesheet
                var fixedMaybeTwo = FlxAtlasFrames.fromSparrow("assets/images/characters/tux/firetux.png", "assets/images/characters/tux/firetux.xml");
                frames = fixedMaybeTwo;
                animation.addByPrefix('stand', 'stand', 10, false);
                animation.addByPrefix('walk', 'walk', 10, true);
                animation.addByPrefix('jump', 'jump', 10, false);
                animation.addByPrefix('duck', 'duck', 10, false);
                animation.play('stand');

                // Hitbox
                setSize(22, 48);
                offset.set(15, 12);
            
        }
    }

    public function fireTux()
    {
        currentState = Fire;
        reloadGraphics();
    }

    function shootBall()
    {
        if (currentState != Fire)
        {
            return;
        }

        if (FlxG.keys.justPressed.CONTROL && canShoot)
        {
            var fireball:Fireball = new Fireball(x + 8, y + 16);
            fireball.direction = direction;
            Global.PS.items.add(fireball);
            FlxG.sound.play("assets/sounds/fireball.ogg");

            canShoot = false;
            new FlxTimer().start(shootCooldown, function(_) canShoot = true);
        }
    }
}