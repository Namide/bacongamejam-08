package bgj8;

import dune.component.ComponentType;
import dune.component.Transform;
import dune.entity.Entity;
import dune.helper.core.UrlUtils;
import dune.model.controller.ControllerPlatform;
import dune.model.controller.ControllerPlatformPlayer;
import dune.model.controller.ControllerGravity;
import dune.model.controller.ControllerMobile;
import dune.model.factory.EntityFactory;
import dune.system.graphic.component.Display2dSprite;
import dune.system.physic.component.Body;
import dune.system.physic.component.BodyType;
import dune.system.physic.shapes.ShapeRect;
import dune.system.physic.shapes.ShapeType;
import dune.system.Settings;
import dune.system.SysManager;
import h2d.comp.Input;
import haxe.Timer;
import hxd.Stage;
import hxd.System;
import bgj8.level.LevelGen;

/**
 * ...
 * @author Namide
 */
class Game
{
	
	public var systemManager:SysManager;
	
	private var _entity1:Entity;
	
	public function new() 
	{
		//hxd.Res.initEmbed();
		//hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create());
		systemManager = new SysManager( run );
		
		//systemManager.sysGraphic.onInit = run;

	}
	
	public function run()
	{
		var rootURL:String = UrlUtils.getCurrentSwfDir() + "/";
		
		var levelGen:LevelGen = new LevelGen( systemManager );
		levelGen.load( rootURL + "level/level-1.json", function( levelGen:LevelGen ):Void
		{
			levelGen.generateLevel();
			systemManager.draw();
			haxe.Timer.delay( systemManager.start, 500 );
			
			//systemManager.start();
			//systemManager.draw();
		} );
		
	}
	
	private function addBounceBall():Void
	{
		var TS:Float = Settings.TILE_SIZE;
		var size:Float = ( Math.random() + 0.5 ) * TS;
		
		var ball = new Entity();
		ball.transform.x = ( 1 + Math.random() * 10 ) * TS;
		ball.transform.y = -size;
		ball.transform.vX = Math.random() * 5;
		
		// graphic
		
			ball.display = EntityFactory.getSolidDisplay( systemManager, size, size );
		
		// collision
		
			var b4:Body = new Body();
			var psr4:ShapeRect = new ShapeRect();
			psr4.w = size;
			psr4.h = size;
			b4.shape = psr4;
			b4.typeOfCollision = BodyType.COLLISION_TYPE_ACTIVE;
			b4.typeOfSolid = BodyType.SOLID_TYPE_MOVER;
			ball.addBody( b4 );
		
		// move
	
			var i4:ControllerPlatform = new ControllerPlatform();
			ball.addController( i4 );
		
		systemManager.addEntity( ball );
		
	}
	
}