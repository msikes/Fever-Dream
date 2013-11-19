package ;

import org.flixel.FlxSprite;
import org.flixel.FlxG;

class L4PowerUp extends FlxSprite{

	public var consumed:Bool;
	private var powerUpTimeLimit:Float;
	private var powerUpCounter:Float;
	private var startXPosition:Float;

	public function new(xPosition:Float, yPosition:Float):Void {
		super(xPosition, yPosition);
		makeGraphic(32,32, 0xFFFF7700);

		startXPosition = xPosition;

		powerUpCounter = 0;
		powerUpTimeLimit = 4;
	}
	
	override public function update():Void {

		//Consumed state. Hides off screen for a bit and then reappears in original position
		if (consumed){
			if(powerUpCounter<powerUpTimeLimit){
				powerUpCounter += FlxG.elapsed;
				x = -200; // hide off screen for a bit
			}
			else{
				consumed=false;
				powerUpCounter=0;
				x = startXPosition;
			}
		}

		super.update();
	}

}