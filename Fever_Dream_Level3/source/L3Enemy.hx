package ;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

class L3Enemy extends FlxSprite{

	public var directionX:Float;
	private var speedX:Float;
	private var level:L3PlayState; // Use this to refer back to player. Alternative to cast()

	public function new(xPosition:Float, yPosition:Float, sX:Float, state:L3PlayState):Void {
		super(xPosition, yPosition);
		makeGraphic(32,32,0xFF0000FF);
		directionX = 1;
		speedX = sX;
		level = state;
	}

	override public function update():Void {

		velocity.x = speedX * directionX;
		super.update();

	}
}