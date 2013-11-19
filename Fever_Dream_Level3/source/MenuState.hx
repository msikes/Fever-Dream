package;

import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxG;

class MenuState extends FlxState {

	private var title:FlxText;

	override public function create():Void {
		super.create();
		title = new FlxText(0,300,800,"Fever Dream\nPress SPACE to start");
		title.alignment = "center";
		add(title);

		Reg.lives = 3; // RESET PLAYER LIVES AT MENU SCREEN
	}
	
	override public function update():Void {
		super.update();
		if(FlxG.keys.SPACE){
			FlxG.switchState(new L3PlayState());
		}
	}	
}