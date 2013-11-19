package ;

import org.flixel.FlxSprite;

class L4Exit extends FlxSprite{

	public function new(xPosition:Float, yPosition:Float):Void {
		super(xPosition, yPosition);
		makeGraphic(32,64, 0xFF111111);
	}
	
	override public function update():Void {
		super.update();
	}

}