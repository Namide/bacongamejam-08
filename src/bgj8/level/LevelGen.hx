package bgj8.level;

import bgj8.entities.EntityPlayer;
import bgj8.entities.EntityRessources;
import dune.entity.Entity;
import dune.model.controller.ControllerCamera2dTracking;
import dune.model.factory.DisplayFactory;
import dune.model.controller.ControllerMobile;
import dune.model.controller.ControllerPlatformPlayer;
import dune.model.factory.EntityFactory;
import dune.system.physic.component.Body;
import dune.system.physic.component.BodyType;
import dune.system.physic.shapes.ShapeRect;
import dune.system.Settings;
import dune.system.SysManager;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.Lib;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Object;
import haxe.Json;

class TileData
{
	public var id:UInt;
	public var type:String;
	public var datas:Dynamic;
	public var dir:String;
	
	public function new( dat:Dynamic ) 
	{
		id = dat.id;
		type = dat.type;
		datas = dat.datas;
		dir = (dat.dir != null) ? dat.dir : "h";
	}
}

class LevelData
{
	var _tiles:Array<TileData>;	
	public var grid(default, null):Array<Array<UInt>>;
	
	public function new( dat:Dynamic ) 
	{
		_tiles = [];
		
		var datTiles:Array<Dynamic> = cast( dat.tiles, Array<Dynamic> );
		
		for ( tileDyn in datTiles )
		{
			_tiles.push( new TileData( tileDyn ) );
		}
		
		grid = dat.grid;
	}
	
	public function getTile(i:Int, j:Int):TileData
	{
		var getTile:TileData->Bool = function( td:TileData ):Bool { return td.id == grid[j][i]; };
		
		if ( 	j < grid.length &&
				i < grid[j].length &&
				Lambda.exists( _tiles, getTile )
				)
		{
			return Lambda.find( _tiles, getTile );
		}
		return null;
	}
}

/**
 * ...
 * @author Namide
 */
class LevelGen
{
	var _sm:SysManager;
	var _levelData:LevelData;
	
	public function new( sm:SysManager ) 
	{
		_sm = sm;
	}
	
	public function load( uriJson:String, onJsonLoaded:LevelGen->Void ):Void
	{
		var req:URLRequest = new URLRequest(uriJson);
		var load:URLLoader = new URLLoader(req);
		load.addEventListener( IOErrorEvent.IO_ERROR, function( e:IOErrorEvent ):Void { throw e.text; } );
		load.addEventListener( Event.COMPLETE, function( e:Event ):Void
		{
			var loader:URLLoader = e.target;
			var dat:Dynamic = Json.parse( Std.string(loader.data) );
			
			_levelData = new LevelData( dat );
			onJsonLoaded( this );
			
			var cam = _sm.sysGraphic.camera2d;
			var layer0 = DisplayFactory.assetMcToSprite( "Bg0MC", _sm, 1 * Settings.TILE_SIZE / 64 ).sprite;
			layer0.scale(2);
			layer0.x -= 10 * Settings.TILE_SIZE;
			layer0.y -= 10 * Settings.TILE_SIZE;
			cam.addLayer( layer0, 0 );
			
			var layer1 = DisplayFactory.assetMcToSprite( "Bg1MC", _sm, 1 * Settings.TILE_SIZE / 64 ).sprite;
			layer1.scale(2);
			layer1.x -= 10 * Settings.TILE_SIZE;
			layer1.y -= 10 * Settings.TILE_SIZE;
			cam.addLayer( layer1, 0.3 );
			
			var layer2 = DisplayFactory.assetMcToSprite( "Bg2MC", _sm, 1 * Settings.TILE_SIZE / 64 ).sprite;
			layer2.scale(2);
			layer2.x -= 10 * Settings.TILE_SIZE;
			layer2.y -= 10 * Settings.TILE_SIZE;
			cam.addLayer( layer2, 0.7 );
		});
	}
	
	/*public static function listLevels( uri:String, callback:Array<String> -> Void ):Void
	{
		var load:URLLoader = new URLLoader(new URLRequest(uri));
		load.addEventListener( IOErrorEvent.IO_ERROR, function( e:IOErrorEvent ):Void { throw e.text; } );
		load.addEventListener( Event.COMPLETE, function( e:Event ):Void
		{
			var loader:URLLoader = e.target;
			var dat:Dynamic = Json.parse( Std.string(loader.data) );
			
			var list:Array<String> = [];
			for ( levelObj in cast( dat, Array<Dynamic> ) )
			{
				list.push( levelObj.path );
			}
			
			callback( list );
		});
	}*/
	
	public inline function generateLevel():Void
	{
		if ( _levelData == null ) throw "Level JSON is'nt loaded";
		gridAnalyse(_levelData);
	}
	
	function gridAnalyse( levelDatas:LevelData ):Void
	{
		var constructed:Array<String> = [];
		
		var iMax:Int = 0;
		var jMax:Int = 0;
		
		for ( j in 0...levelDatas.grid.length )
		{
			for ( i in 0...levelDatas.grid[j].length )
			{
				tileAnalyseSize( levelDatas, i, j, constructed );
				if ( i > iMax ) iMax = i;
			}
			if ( j > jMax ) jMax = j;
		}
		
		Settings.LIMIT_LEFT = 0;
		Settings.LIMIT_RIGHT = (iMax+1) * Settings.TILE_SIZE;
		Settings.LIMIT_TOP = -0xFFFFFF;
		Settings.LIMIT_DOWN = (jMax+1) * Settings.TILE_SIZE;
	}
	
	function tileAnalyseSize( levelDatas:LevelData, iMin:Int, jMin:Int, c:Array<String> ):Void
	{
		var i:Int = iMin;
		var j:Int = jMin;
		
		var tile:TileData = levelDatas.getTile( i, j );
		if ( tile == null ) return;
		
		if ( Lambda.has( c, posToStr(i, j) ) ) return;
		
		var iMax:Int = iMin;
		var jMax:Int = jMin;
		var dir:String = levelDatas.getTile(i, j).dir;
		
		if ( dir == "h" && levelDatas.getTile( i+1, j ) == tile && !Lambda.has( c, posToStr(i,j) ) )
		{
			while ( levelDatas.getTile( i, j ) == tile && !Lambda.has( c, posToStr(i,j) ) )
			{
				iMax = i;
				c.push( posToStr(i, j) );
				i++;
			}
		}
		
		if ( dir == "v" && levelDatas.getTile( i, j+1 ) == tile && !Lambda.has( c, posToStr(i,j) ) )
		{
			while ( levelDatas.getTile( i, j ) == tile && !Lambda.has( c, posToStr(i,j) ) )
			{
				jMax = j;
				c.push( posToStr(i, j) );
				j++;
			}
		}
		
		tileAnalyseType( iMin, jMin, 1 + iMax - iMin, 1 + jMax - jMin, tile );
	}
	
	function tileAnalyseType( xTile:Int, yTile:Int, wTile:Int, hTile:Int, tile:TileData ):Void
	{
		var TS:Float = Settings.TILE_SIZE;
		
		//trace(tile.type);
		
		if ( tile.type == "platform" )
		{
			EntityFactory.addSolid( _sm, xTile * TS, yTile * TS, wTile * TS, hTile * TS, BodyType.SOLID_TYPE_PLATFORM );
		}
		else if ( tile.type == "wall" )
		{
			EntityFactory.addSolid( _sm, xTile * TS, yTile * TS, wTile * TS, hTile * TS, BodyType.SOLID_TYPE_WALL );
		}
		else if ( tile.type == "sushi" )
		{
			var display = DisplayFactory.assetMcToDisplay2d( "SushiMC", _sm, 1 * Settings.TILE_SIZE / 64 );
			EntityRessources.SUSHI = EntityFactory.addSolid( _sm, xTile * TS, yTile * TS, wTile * TS, hTile * TS, BodyType.SOLID_TYPE_PLATFORM, display );
		}
		else if ( tile.type == "mushHead" )
		{
			var display = DisplayFactory.assetMcToDisplay2d( "MushHeadMC", _sm, 1 * Settings.TILE_SIZE / 64 );
			var e = EntityFactory.addSolid( _sm, xTile * TS, yTile * TS, wTile * TS, hTile * TS, BodyType.SOLID_TYPE_PLATFORM, display );
			display.setX( e.transform.x - 5 );
			display.setY( e.transform.y - 10 );
		}
		else if ( tile.type == "mushBody" )
		{
			var display = DisplayFactory.assetMcToDisplay2d( "MushBodyMC", _sm, 1 * Settings.TILE_SIZE / 64 );
			var e = EntityFactory.addSolid( _sm, xTile * TS, yTile * TS, wTile * TS, hTile * TS, BodyType.SOLID_TYPE_PLATFORM, display );
			display.setX( e.transform.x );
			display.setY( e.transform.y - 20 );
		}
		else if ( tile.type == "spawn" )
		{
			addPlayer( xTile * TS, yTile * TS );
		}
		/*else if ( tile.type == "mobile" )
			addMobile( xTile * TS, yTile * TS, wTile * TS, hTile * TS, tile.datas );*/
	}
	
	/*function addMobile( i:Float, j:Float, w:Float, h:Float, datas:Dynamic ):Void
	{
		var e2 = new Entity();
		e2.transform.x = i;
		e2.transform.y = j;
		
		var tweens:Dynamic =
		{
			cos:ControllerMobile.TYPE_COS,
			linear:ControllerMobile.TYPE_LINEAR,
			sin:ControllerMobile.TYPE_SIN
		}
		
		var solidType:Dynamic =
		{
			wall:BodyType.SOLID_TYPE_WALL,
			platform:BodyType.SOLID_TYPE_PLATFORM
		}
		
			// graphic
			
				//var spr2 = new h2d.Sprite( systemManager.sysGraphic.s2d );
				//var bmp2 = new h2d.Bitmap(tile, spr2);
				//e2.display = new CompDisplay2dSprite( spr2 );
				e2.display = EntityFactory.getSolidDisplay( _sm, w, h );
			
			// move
			
				var i2:ControllerMobile = new ControllerMobile();
				
				if ( datas.moveX != null )
					i2.initX( tweens[datas.moveX.type], datas.moveX.dist * Settings.TILE_SIZE, datas.moveX.time );
				
				if ( datas.moveY != null )
					i2.initY( tweens[datas.moveY.type], datas.moveY.dist * Settings.TILE_SIZE, datas.moveY.time );
				
				
				e2.addController( i2 );
				
			// collision
			
				var b2:Body = new Body();
				var psr2:ShapeRect = new ShapeRect();
				psr2.w = w;
				psr2.h = h;
				b2.shape = psr2;
				b2.typeOfCollision = BodyType.COLLISION_TYPE_PASSIVE;
				b2.typeOfSolid = solidType[datas.type];
				e2.addBody( b2 );
				
		_sm.addEntity( e2 );
	}*/
	
	function addPlayer( i:Float, j:Float ):Void
	{
		var player:EntityPlayer = new EntityPlayer();
		player.transform.x = i;
		player.transform.y = j;
		player.init( _sm );
		_sm.addEntity( player );
		
		EntityRessources.PLAYER = player;
	}
	
	function posToStr( i:Int, j:Int ):String
	{
		return Std.string(i) + "-" + Std.string(j);
	}
	
}