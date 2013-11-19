package ;

import org.flixel.FlxSprite;
import org.flixel.FlxG;

class L5HealthBlock extends FlxSprite{

	public function new(xPosition:Float, yPosition:Float):Void {
		super(xPosition, yPosition);
		makeGraphic(32,32, 0xFFFF0000);
	}
	
	override public function update():Void {
		super.update();
	}

}