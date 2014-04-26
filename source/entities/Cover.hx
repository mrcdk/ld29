package entities;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import nape.constraint.DistanceJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;

/**
 * ...
 * @author MrCdK
 */
class Cover extends NapeMouseSprite {

	private static inline var FLIP_TIME:Float = 0.6;
	
	private var canBeFlipped:Bool = false;
	private var flipped(default, null):Bool = false;
	
	private var targetScale:FlxPoint;
	
	private static var hitSprite:FlxSprite;
	
	public function new(X:Float = 0, Y:Float = 0, W:Int = 256, H:Int = 256) {
		super(X, Y, false);
		
		if (hitSprite == null) {
			hitSprite = new FlxSprite(0, 0, AssetPaths.hit__png);
		}
		
		loadGraphic(AssetPaths.cover1__png, true, 128, 128, true);
		targetScale = FlxPoint.get(W / frameWidth, H / frameHeight);
		initialize();
		
		scale.x = targetScale.x;
		scale.y = targetScale.y;
		updateHitbox();
		body.scaleShapes(targetScale.x, targetScale.y);
		body.translateShapes(Vec2.weak( -offset.x, -offset.y));
		body.position.x = x + _halfWidth;
		body.position.y = y + _halfHeight;
		trace(x, y, width, height, body.position);
		addMouseEvents(false);
		
		if (FlxRandom.chanceRoll(20)) flipX = true;
		if (FlxRandom.chanceRoll(17)) flipY = true;
		
		animation.add("fg", [0]);
		animation.add("bg", [1]);
		animation.play("fg");
	}
	
	override public function update():Void {
		if (health <= 0) body.allowMovement = true;
		if (canBeFlipped && FlxG.keys.justPressed.SPACE) {
			FlxTween.tween(scale, { x : 0 }, FLIP_TIME / 2, { complete: flipCover } );
		}
		super.update();
	}
	
	override public function destroy():Void {
		targetScale.put();
		super.destroy();
	}
	
	override function initialize() {
		super.initialize();
		
		body.allowMovement = false;
		body.allowRotation = false;
		body.gravMass = 0;		
		body.setShapeFilters(new InteractionFilter(1, ~2));
	}
	
	override function onMouseDown(_) {
		if (health > 0) {
			health--;
			if (FlxRandom.chanceRoll(60)) hitSprite.flipX = true;
			if (FlxRandom.chanceRoll(40)) hitSprite.flipY = true;
			hitSprite.scale.x = FlxRandom.floatRanged(0.9, 1.4);
			hitSprite.scale.y = FlxRandom.floatRanged(0.9, 1.4);
			hitSprite.updateHitbox();
			stamp(hitSprite, FlxRandom.intRanged(0, Std.int(frameWidth - hitSprite.width)), FlxRandom.intRanged(0, Std.int(frameHeight- hitSprite.height)));
		} 
		if (health <= 0) {
			if (!flipped) color = FlxColorUtil.brighten(FlxColor.GREEN, 0.8);
			canBeFlipped = true;
		}
		super.onMouseDown(_);
	}
	override function onMouseUp(_) {
		canBeFlipped = false;
		super.onMouseUp(_);
	}
	
	private inline function flipCover(_) {
		if (flipped) {
			//show fg
			animation.play("fg");
			flipped = false;
		} else {
			//show bg
			animation.play("bg");
			flipped = true;
		}
		FlxTween.tween(scale, { x : targetScale.x }, FLIP_TIME / 2);
	}
}