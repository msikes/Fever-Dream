package;

import openfl.Assets;
import haxe.io.Path;
import haxe.xml.Parser;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxTilemap;
import org.flixel.FlxObject;

class L3TiledLevel extends TiledMap {
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";
	
	// Array of tilemaps used for collision
	public var foregroundTiles:FlxGroup;
	public var backgroundTiles:FlxGroup;
	private var collidableTileLayers:Array<FlxTilemap>;
	
	public function new(tiledLevel:Dynamic) {
		super(tiledLevel);
		
		// Create groups to hold tile layers
		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();
		
		// Load Tile Maps
		for ( tileLayer in layers ) {
			// this will look for a layer property name called tileset
			var tileSheetName:String = tileLayer.properties.get("tileset");
			
			//	you need names for your tile layers...
			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
				
			var tileSet:TiledTileSet = null;
			for ( ts in tilesets ){
				if ( ts.name == tileSheetName){
					tileSet = ts;
					break;
				}
			}
			
			if (tileSet == null){
				throw "Tileset '" + tileSheetName + " not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?";
			}

			var imagePath 		= new Path(tileSet.imageSource);
			var processedPath 	= c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);
			

			// assumes backgrounds are not meant to be collided with, otherwise it is a foreground item (collidable)
			if (tileLayer.properties.contains("nocollide")){
				backgroundTiles.add(tilemap);
			}
			else {
				if (collidableTileLayers == null){
					collidableTileLayers = new Array<FlxTilemap>();
				}
				foregroundTiles.add(tilemap);
				collidableTileLayers.push(tilemap);
			}
		}
	}

	// load all objects into playstate
	public function loadObjects(state:L3PlayState){
		for ( group in objectGroups ){
			for ( o in group.objects ){
				loadObject(o, group, state);
			}
		}
	}
	
	// this private function is used internally to parse objects from map and add them to playstate
	private function loadObject(o:TiledObject, g:TiledObjectGroup, state:L3PlayState) {
		// get the location of the object from tiled. variables created here are "local" to this function and not shared. think: internal use only.
		var x:Int = o.x;
		var y:Int = o.y;
		
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1) {
			y -= g.map.getGidOwner(o.gid).tileHeight;
		}
		
		// check the object type from tiled and convert to lowercase. switch and case are just handy ways of doing if statements
		switch (o.type.toLowerCase()){
			
			// if there is something with this type, create a new local player object and add a copy in playstate
			case "player_start":
				var p1 = new L3Player(x, y);
				state.p1 = p1;
				state.add(p1);

			case "exit":
				state.exits.add(new L3Exit(x, y)); // for a single, generic exit

			case "powerup":
				state.powerUps.add(new L3PowerUp(x, y));

			case "enemy_start":
				var speedX:Float = Std.parseFloat(o.custom.get("speedX")); // enemy_start objects need a property named speedX to set Enemy speed. Std.parseFloat() converts it from text to a number.
				state.enemies.add(new L3Enemy(x, y, speedX, state));
		}
	}
	
	// Handles collision with layers not set to nocollision = true in tiled
	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool{
		if (collidableTileLayers != null){
			for ( map in collidableTileLayers){
				// IMPORTANT: Always collide the map with objects, not the other way around. 
				//			  This prevents odd collision errors (collision separation code off by 1 px).
				return FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate);
			}
		}
		return false;
	}
}