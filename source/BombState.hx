package ;

import entities.Trash;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import nape.geom.Vec2;

/**
 * ...
 * @author MrCdK
 */
class BombState extends FlxNapeState {

	var trashGroup:FlxTypedGroup<Trash>;
	
	override public function create():Void {
		super.create();
		
		//createWalls();
		FlxG.plugins.add(new MouseEventManager());
		
		trashGroup = new FlxTypedGroup<Trash>();
		add(trashGroup);

		spawnTrash(20);
		//var timer = new FlxTimer(3, function(_) { trashGroup.forEachAlive(function(t) { t.body.applyImpulse( Vec2.weak(-50000, -60000)); }); spawnTrash(20, -50000, -60000); } );
	}
	
	
	private function spawnTrash(number:Int, ?minImpX:Float = 0, ?maxImpX:Float = 0, ?minImpY:Float = 0, ?maxImpY:Float = 0) {
		var sprite:Trash;
		var x:Float, y:Float;
		for (i in 0...number) {
			x = FlxRandom.floatRanged(0, FlxG.width);	
			y = FlxRandom.floatRanged(0, FlxG.height);
			
			sprite = trashGroup.recycle(Trash, [x, y]);
			//sprite.color = FlxRandom.color();
			sprite.body.rotation = FlxAngle.asRadians(FlxRandom.floatRanged(0, 360));
			trashGroup.add(sprite);
		}
	}
	
	private inline function wind(?x:Float = 0, ?y:Float = 0) {
		FlxNapeState.space.gravity.set(Vec2.weak(x,y));
	}
	
	override public function update():Void {
		if (FlxRandom.chanceRoll(0.5)) {
			wind(FlxRandom.floatRanged(-600, 600), FlxRandom.floatRanged(-600, 600));
		} else if (FlxRandom.chanceRoll(1)) {
			wind(0, 0);
		}
		super.update();
	}
	
	override public function destroy():Void {
		super.destroy();
	}
}