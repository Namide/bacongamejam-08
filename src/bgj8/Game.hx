package bgj8;

import bgj8.entities.EntityFly;
import bgj8.entities.EntityRessources;
import bgj8.entities.EntityWasp;
import bgj8.entities.EntityWasp;
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
		EntityRessources.SM = systemManager;
		
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
			systemManager.start();
			//haxe.Timer.delay( systemManager.start, 500 );
			
			//systemManager.start();
			//systemManager.draw();
			addFly();
			addWasp();
		} );
		
	}
	
	function addFly():Void
	{
		var ef = new EntityFly();
		ef.transform.x = Math.random() * Settings.LIMIT_RIGHT;
		ef.transform.y = systemManager.sysGraphic.camera2d.y;
		ef.init( systemManager );
		
		systemManager.addEntity( ef );
		
		haxe.Timer.delay( addFly, 1000 );
	}
	
	function addWasp():Void
	{
		var ew = new EntityWasp();
		ew.transform.x = Math.random() * Settings.LIMIT_RIGHT;
		ew.transform.y = systemManager.sysGraphic.camera2d.y;
		ew.init( systemManager );
		
		systemManager.addEntity( ew );
		
		haxe.Timer.delay( addWasp, 2000 );
	}
	
}