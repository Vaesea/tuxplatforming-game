package worldmap;

import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class WorldmapHUD extends FlxState
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

        // Add all text
        add(scoreText);
        add(coinText);
    }

    override public function update(elapsed:Float)
    {
        // Update Score Text
        scoreText.text = "Score:\n" + 
        StringTools.lpad(Std.string(Global.score), "0", 5);

        // Update Coin Text
        coinText.text = "Coins: " + (Global.coins);

        super.update(elapsed);
    }
}