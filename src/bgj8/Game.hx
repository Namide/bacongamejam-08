package bgj8;

import bgj8.entities.EntityFly;
import bgj8.entities.EntityRessources;
import bgj8.entities.EntityWasp;
import bgj8.entities.EntityWasp;
import dune.component.ComponentType;
import dune.component.Transform;
import dune.entity.Entity;
import dune.helper.core.DTime;
import dune.helper.core.UrlUtils;
import dune.model.controller.ControllerPlatform;
import dune.model.controller.ControllerPlatformPlayer;
import dune.model.controller.ControllerGravity;
import dune.model.controller.ControllerMobile;
import dune.model.factory.DisplayFactory;
import dune.model.factory.EntityFactory;
import dune.system.graphic.component.Display2dSprite;
import dune.system.physic.component.Body;
import dune.system.physic.component.BodyType;
import dune.system.physic.shapes.ShapeRect;
import dune.system.physic.shapes.ShapeType;
import dune.system.Settings;
import dune.system.SysManager;
import flash.events.Event;
import flash.Lib;
import flash.utils.SetIntervalTimer;
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
	public dynamic function onEnd():Void {}
	
	var _intervalWasp:Timer;
	var _intervalFly:Timer;
	var _levelGen:LevelGen;
	
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
		hxd.Res.initEmbed();
		
		//systemManager.sysGraphic.camera2d.zoom( 2 );
		
		_levelGen = new LevelGen( systemManager );
		_levelGen.load( rootURL + "level/level-1.json", function( levelGen:LevelGen ):Void
		{
			_levelGen.generateLevel();
			systemManager.draw();
			systemManager.start();
			//haxe.Timer.delay( systemManager.start, 500 );
			
			flash.Lib.current.stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			//systemManager.start();
			//systemManager.draw();
			addFly();
			//haxe.Timer.delay( addWasp, 8000 );
			
			_intervalWasp = new Timer( 8000 );
			_intervalWasp.run = addWasp;
		} );
		
	}
	
	function onEnterFrame( e:Event ):Void
	{
		if ( EntityRessources.PLAYER.transform.y > Settings.LIMIT_DOWN )
		{
			flash.Lib.current.stage.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			onEnd();
		}
	}
	
	function addFly():Void
	{
		var ef = new EntityFly();
		ef.transform.x = Math.random() * Settings.LIMIT_RIGHT;
		ef.transform.y = systemManager.sysGraphic.camera2d.y;
		ef.init( systemManager );
		
		systemManager.addEntity( ef );
		
		var delay:Float = Math.min( 0.5, (systemManager.time.getSec() / (60 * 5)) );
		delay = 1500 * (1 - delay) + 500;
		//haxe.Timer.delay( addFly, Math.round(delay) );
		//_intervalIdFly = flash.utils.SetIntervalTimer( addFly, Math.round(delay), false );
		if ( _intervalFly != null ) _intervalFly.stop();
		_intervalFly = new Timer( Math.round(delay) );
		_intervalFly.run = addFly;
	}
	
	function addWasp():Void
	{
		var ew = new EntityWasp();
		ew.transform.x = Math.random() * Settings.LIMIT_RIGHT;
		ew.transform.y = systemManager.sysGraphic.camera2d.y;
		ew.init( systemManager );
		
		systemManager.addEntity( ew );
		
		//haxe.Timer.delay( addWasp, 6000 );
		//_intervalIdWasp = flash.utils.SetIntervalTimer( addWasp, 6000, false );
		
		if ( _intervalWasp != null ) _intervalWasp.stop();
		_intervalWasp = new Timer( 6000 );
		_intervalWasp.run = addWasp;
	}
	
	public function dispose():Void
	{
		if ( _intervalWasp != null ) _intervalWasp.stop();
		if ( _intervalFly != null ) _intervalFly.stop();
		systemManager.dispose();
		DisplayFactory.clear();
	}
	
}