package;

import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxGroup;
import org.flixel.FlxText;
import org.flixel.FlxObject;

class L5PlayState extends FlxState {

	// must be public for tiledlevel to use
	public var p1:L5Player;
	public var exits:FlxGroup;
	public var enemies:FlxGroup;
	public var powerUps:FlxGroup;
	private var level:L5TiledLevel;
	private var bgImage:FlxSprite;
	private var healthBar:L5HealthBar;

	override public function create():Void {
		

		level = new L5TiledLevel("assets/tiled/Level5.tmx");
		add(level.backgroundTiles);
		add(level.foregroundTiles);

		// add exits after background and foreground, but before player
		exits = new FlxGroup();
		add(exits);

		// consumable items
		powerUps = new FlxGroup();
		add(powerUps);

		enemies = new FlxGroup();
		add(enemies);

		// load objects based on tiled layout
		level.loadObjects(this);

		healthBar = new L5HealthBar(20,20, 40, Reg.lives);
		add(healthBar);

		super.create();
	}
	
	override public function update():Void {
		super.update();
		level.collideWithLevel(p1);
		FlxG.overlap(p1, exits, exitLevel);
		FlxG.overlap(p1, powerUps, powerUp);
		FlxG.collide(p1, enemies, hitEnemy);
	}	

	public function exitLevel(p:L5Player, e:L5Exit):Void {
		if(p.canExit == true){
			FlxG.switchState(new EndState()); // switch to a new playstate if space is pressed
		}	
	}

	public function powerUp(p:L5Player, c:L5PowerUp):Void{
		c.consumed = true;
		p.hasPowerUp = true;
	}

	public function hitEnemy(p:L5Player, e:L5Enemy):Void{

		// If you jump on top of enemy, it will die
		if(e.isTouching(FlxObject.UP)==true){
			e.kill();
		}
		else { // otherwise, you die!
			Reg.lives--;
			if(Reg.lives > 0){
				FlxG.resetState();
			}
			else {
				FlxG.resetGame();
			}
			
		}
	}
}