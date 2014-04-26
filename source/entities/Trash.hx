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
class Trash extends NapeMouseSprite {

	private static var TRASH_GRAPHICS(get, never):Array<String>;
	private static inline function get_TRASH_GRAPHICS():Array<String> {
		return [
			AssetPaths.trash_art_expo__png,
			AssetPaths.trash_cinema__png,
			AssetPaths.trash_money__png,
			AssetPaths.trash_news_paper__png,
		];
	}
	
	public function new(X:Float=0, Y:Float=0) {
		super(X, Y);
	}
	
	override function initialize() {
		loadGraphic(FlxRandom.getObject(TRASH_GRAPHICS));
		super.initialize();
		addMouseEvents();
		body.gravMass = FlxRandom.floatRanged(1, 100);
		body.setShapeFilters(new InteractionFilter(2, ~3));
	}
}