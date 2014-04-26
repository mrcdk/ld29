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
	
	public function new(X:Float = 0, Y:Float = 0, initialize:Bool = true ) {
		super(X, Y);
		if(initialize)
			revive();
	}
	
	override public function update():Void {
		super.update();
		if (joint.active) {
			joint.anchor1.set(Vec2.weak(FlxG.mouse.x, FlxG.mouse.y));
			if (FlxG.mouse.justReleased) {
				onMouseUp(null);
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
		addMouseEvents();
		super.revive();
	}
	
	private function initialize() {
		var drag = FlxRandom.floatRanged(0.8, 0.95);
		setDrag(drag, drag);
		createRectangularBody(width, height);
		joint = new DistanceJoint(FlxNapeState.space.world, body, Vec2.weak(), Vec2.weak(), 0, 0);
		joint.stiff = false;
		joint.damping = 1;
		joint.frequency = 2;
		joint.space = FlxNapeState.space;
		joint.active = false;
	}
	
	private inline function addMouseEvents(pixelPerfect:Bool = true):Void {
		MouseEventManager.add(this, onMouseDown, onMouseUp, onMouseOver, onMouseOut, false, true, pixelPerfect);
	}
	
	private function onMouseDown(_) {
		
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