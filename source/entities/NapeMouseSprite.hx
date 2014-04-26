package entities;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;
import nape.constraint.DistanceJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;

/**
 * ...
 * @author MrCdK
 */
class NapeMouseSprite extends FlxNapeSprite{

	private var joint:DistanceJoint;
	
	public function new(X:Float=0, Y:Float=0) {
		super(X, Y);
		revive();
	}
	
	override public function update():Void {
		super.update();
		if (joint.active) {
			joint.anchor1.set(Vec2.weak(FlxG.mouse.x, FlxG.mouse.y));
			// todo move to cover
			if (FlxG.keys.justPressed.A) {
				body.rotation = FlxAngle.asRadians(FlxAngle.asDegrees(body.rotation) - 90);
			}
			if (FlxG.keys.justPressed.D) {
				body.rotation = FlxAngle.asRadians(FlxAngle.asDegrees(body.rotation) + 90);
			}
			//
			if (FlxG.mouse.justReleased) {
				joint.active = false;
			}
		}
		
		if (body.isSleeping && !isOnScreen()) {
			trace("killing");
			kill();
		}
	}
	
	override public function destroy():Void {
		MouseEventManager.remove(this);
		joint.space = null;
		joint = null;
		super.destroy();
	}
	
	override public function kill():Void {
		MouseEventManager.remove(this);
		joint.space = null;
		joint = null;
		super.kill();
	}
	
	override public function revive():Void {
		initialize();
		super.revive();
	}
	
	private function initialize() {
		//makeGraphic(FlxRandom.intRanged(32, 256), FlxRandom.intRanged(32, 256));
		var drag = FlxRandom.floatRanged(0.8, 0.95);
		setDrag(drag, drag);
		createRectangularBody(width, height);
		
		body.setShapeFilters(new InteractionFilter(2, ~2));
		joint = new DistanceJoint(FlxNapeState.space.world, body, Vec2.weak(), Vec2.weak(), 0, 0);
								  
								  
		joint.stiff = false;
		joint.damping = 1;
		joint.frequency = 2;
		joint.space = FlxNapeState.space;
		joint.active = false;
		MouseEventManager.add(this, onMouseDown, onMouseUp, onMouseOver, onMouseOut);
	}
	
	private function onMouseDown(_) {
		//trace("mouse down");
		joint.anchor2.set(body.worldPointToLocal(Vec2.weak(FlxG.mouse.x, FlxG.mouse.y)));
		joint.active = true;
	}
	
	private function onMouseUp(_) {
		//trace("mouse up");
		joint.active = false;
	}
	
	private function onMouseOver(_) {
		//trace("mouse over");
	}
	
	private function onMouseOut(_) {
		//trace("mouse out");
	}
	
}