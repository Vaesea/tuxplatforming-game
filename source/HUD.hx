package;

import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class HUD extends FlxState
{
    var scoreText:FlxText;
    var coinText:FlxText;
    var healthText:FlxText;

    public function new()
    {
        super();

        // Create Score Text
        scoreText = new FlxText(4, 4, 0, "Score: " + Global.score, 14);
        scoreText.setFormat(null, 14, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        scoreText.scrollFactor.set();
        scoreText.borderSize = 1.25;

        // Create Coin Text
        coinText = new FlxText(0, 4, 640, "Coins: " + Global.coins, 14);
        coinText.setFormat(null, 14, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        coinText.scrollFactor.set();
        coinText.borderSize = 1.25;

        // Create Health Text (Replace with image at some point)
        healthText = new FlxText(0, 4, 636, "Health: " + Global.health, 14);
        healthText.setFormat(null, 14, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        healthText.scrollFactor.set();
        healthText.borderSize = 1.25;

        // Add all text
        add(scoreText);
        add(coinText);
        add(healthText);
    }

    override public function update(elapsed:Float)
    {
        // Update Score Text
        scoreText.text = "Score:\n" + 
        StringTools.lpad(Std.string(Global.score), "0", 5);

        // Update Coin Text
        coinText.text = "Coins: " + (Global.coins);

        // Update Health Text
        healthText.text = "Health: " + (Global.health);

        super.update(elapsed);
    }
}