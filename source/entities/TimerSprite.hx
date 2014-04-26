package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxStringUtil;

/**
 * ...
 * @author MrCdK
 */
class TimerSprite extends FlxSpriteGroup{

	var timeText:FlxText;
	public var time:Float = 100;
	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) {
		super(X, Y, MaxSize);
		
		
		var bg = new FlxSprite(0, 0).makeGraphic(500, 60, FlxColorUtil.darken(FlxColor.RED, 0.4));
		add(bg);
		
		timeText = new FlxText(0, 4, 480, "01:00");
		timeText.setFormat(AssetPaths.PressStart2P__ttf, 56, FlxColor.RED, "right");
		add(timeText);
	}
	
	override public function update():Void {
		time -= FlxG.elapsed;
		
		timeText.text = FlxStringUtil.formatTime(time, true);
		super.update();
	}
	
}