package states;

import creatures.Enemy;
import creatures.player.Fireball;
import creatures.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import objects.BonusBlock;
import objects.Coin;
import objects.powerups.Candle;
import objects.powerups.Crystal;
import states.substates.LevelIntro;

class PlayState extends FlxState
{
	public var map:FlxTilemap;

	// Add things part 1
	public var collision(default, null):FlxTypedGroup<FlxSprite>;
	public var enemies(default, null):FlxTypedGroup<Enemy>;
	public var tux(default, null):Tux;
	public var items(default, null):FlxTypedGroup<FlxSprite>;
	public var blocks(default, null):FlxTypedGroup<FlxSprite>;
	private var hud:HUD;
	private var entities:FlxGroup;

	override public function create()
	{
		// Just so Global.PS actually works...
		Global.PS = this;

		// Add things part 2
		entities = new FlxGroup();
		collision = new FlxTypedGroup<FlxSprite>();
		enemies = new FlxTypedGroup<Enemy>();
		tux = new Tux();
		items = new FlxTypedGroup<FlxSprite>();
		blocks = new FlxTypedGroup<FlxSprite>();
		hud = new HUD();

		LevelLoader.loadLevel(this, "test");

		// Add things part 3
		entities.add(items);
		entities.add(blocks);
		entities.add(enemies);
		add(collision);
		add(entities);
		add(tux);
		add(hud);

		// Camera
		FlxG.camera.follow(tux, PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);

		// Start the Level Intro
		openSubState(new LevelIntro(FlxColor.BLACK));
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Tux collision
		FlxG.collide(collision, tux);
		FlxG.overlap(entities, tux, collideEntities);
		FlxG.collide(tux, blocks, collideEntities);

		// Enemy + Entity collision
		FlxG.collide(collision, entities);
		FlxG.overlap(entities, enemies, function (entity:FlxSprite, enemy:Enemy)
		{
			if (Std.isOfType(entity, Enemy))
			{
				enemy.collideOtherEnemy(cast entity);
			}
			if (Std.isOfType(entity, Fireball))
			{
				enemy.collideFireball(cast entity);
			}
		} );

		// Item collision
		FlxG.collide(collision, items);
		FlxG.collide(items, blocks);
	}

	function collideEntities(entity:FlxSprite, tux:Tux)
	{
		if (Std.isOfType(entity, Coin))
		{
			(cast entity).collect();
		}

		if (Std.isOfType(entity, Enemy))
		{
			(cast entity).interact(tux);
		}

		if (Std.isOfType(entity, BonusBlock))
		{
			(cast entity).hit(tux);
		}

		if (Std.isOfType(entity, Candle) || Std.isOfType(entity, Crystal))
		{
			(cast entity).collect(tux);
		}
	}
}
