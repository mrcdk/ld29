package entities;

import entities.Bomb.Leaf;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;

/**
 * ...
 * @author MrCdK
 */
class Bomb extends FlxSpriteGroup {
	
	var background:FlxSprite;
	
	var leafs:Array<Leaf>;

	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) {
		super(X, Y, MaxSize);
		
		background = new FlxSprite(40, 40).makeGraphic(720, 520, FlxColor.GRAY);
		add(background);
		
		var timerSprite:TimerSprite = new TimerSprite(40 + 40, 40 + 30);
		add(timerSprite);
		
		leafs = [];
		generateCovers();
		
		/*
		var button = new FlxButton(110, 110);
		add(button);
		var cover = new Cover(100, 100);
		cover.body.position.x = 100 + cover._halfWidth;
		cover.body.position.y = 100 + cover._halfHeight;
		cover.health = 10;
		add(cover);
		^*/
		
	}
	
	private function generateCovers():Void {		
		var root:Leaf = new Leaf(Std.int(background.x), Std.int(background.y), Std.int(background.width), Std.int(background.height));
		leafs.push(root);
		
		var did_split:Bool = true;
		while (did_split) {
			did_split = false;
			for (leaf in leafs) {
				if (leaf.leftChild == null && leaf.rightChild == null) {
					if (leaf.width > Leaf.MAX_LEAF_SIZE || leaf.height > Leaf.MAX_LEAF_SIZE || FlxRandom.chanceRoll(75)) {
						if (leaf.split()) {
							leafs.push(leaf.leftChild);
							leafs.push(leaf.rightChild);
							did_split = true;
						}
					}
				}
			}
		}
		
		createCovers(root);
	}
	
	public function createCovers(leaf:Leaf):Void {
		if (leaf.leftChild != null || leaf.rightChild != null) {
			if (leaf.leftChild != null) {
				createCovers(leaf.leftChild);
			} 
			if (leaf.rightChild != null) {
				createCovers(leaf.rightChild);
			}
		} else if(FlxRandom.chanceRoll(75)) {
			trace(leaf);
			var offset = FlxRandom.intRanged(10, 20);
			var cover = new Cover(leaf.x + offset, leaf.y + offset, leaf.width - offset, leaf.height - offset);
			cover.health = FlxRandom.intRanged(3, 10);
			add(cover);
		}
	}
	
}

class Leaf {
	public static inline var MIN_LEAF_SIZE:Int = 128;
	public static inline var MAX_LEAF_SIZE:Int = 512;
	
	public var x:Int; 
	public var y:Int;
	public var width:Int;
	public var height:Int;
	
	public var leftChild:Leaf;
	public var rightChild:Leaf;
	
	public function new(X:Int, Y:Int, Width:Int, Height:Int) {
		x = X;
		y = Y;
		width = Width;
		height = Height;
	}
	
	public function split():Bool {
		if (leftChild != null || rightChild != null) {
			return false; //already splitted
		}
		
		var splitH:Bool = FlxRandom.chanceRoll();
		
		if (width > height && height / width >= 0.05) {
			splitH = false;
		} else if (height > width && width / height >= 0.05) {
			splitH = true;
		}
		
		var max:Int = (splitH ? height : width) - MIN_LEAF_SIZE;
		if (max <= MIN_LEAF_SIZE) {
			return false; // to small to split
		}
		
		var split:Int = FlxRandom.intRanged(MIN_LEAF_SIZE, max);
		
		if (splitH) {
			leftChild = new Leaf(x, y, width, split);
			rightChild = new Leaf(x, y + split, width, height - split);
		} else {
			leftChild = new Leaf(x, y, split, height);
			rightChild = new Leaf(x + split, y, width - split, height);
		}
		
		return true;
	}
	
	public function toString():String {
		return "x: " + x + " y: " + y + " w: " + width + " h: " + height;
	}
}