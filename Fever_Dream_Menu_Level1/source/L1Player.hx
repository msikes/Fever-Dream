package ;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

class L1Player extends FlxSprite{

	public var canExit:Bool;
	public var hasPowerUp:Bool;

	private var powerUpTimeLimit:Float;
	private var powerUpCounter:Float;

	private var jumpVelocity:Float; // how high can we jump. increased with power up

	public function new(xPosition:Float, yPosition:Float):Void {
		super(xPosition, yPosition);
		loadGraphic("assets/L1Player.png", true, true, 157, 181);
		addAnimation("idle", [0], 10);
		addAnimation("walk", [2, 6, 7, 8, 2, 9, 10, 11], 10);
		powerUpCounter = 0;
		powerUpTimeLimit = 1;
		jumpVelocity = -320;
	}

	override public function update():Void {
		velocity.x = 0;
		acceleration.y = 640;

		// Power Up state
		if (hasPowerUp){
			if(powerUpCounter<powerUpTimeLimit){
				powerUpCounter += FlxG.elapsed;
				jumpVelocity = -480; // big jump
				velocity.y = jumpVelocity;
			}
			else{
				hasPowerUp=false;
				powerUpCounter=0;
			}
		}
		else {
			jumpVelocity = -320; // back to normal jump
		}

		// jumping condition
		if( isTouching(FlxObject.FLOOR) == true && FlxG.keys.UP == true){
			velocity.y = jumpVelocity;
		}

		// movement
		if (FlxG.keys.LEFT == true){
			velocity.x = -160;
			play("walk");
		}
		if (FlxG.keys.RIGHT == true){
			velocity.x = 160;
			play("walk");
		}

		// exit condition
		if(FlxG.keys.SPACE == true){
			canExit = true;
		}
		else {
			canExit = false;
		}

		super.update();

		// limit horizontal movement to screen
		if (x > FlxG.width - width){
			x = FlxG.width - width;
		}
		else if (x < 0){
			x = 0;
		}
	}
}