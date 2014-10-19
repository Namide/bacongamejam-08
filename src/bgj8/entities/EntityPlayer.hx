package bgj8.entities;

import bgj8.collisions.CollisionsPlayer;
import bgj8.controllers.ControllerAutoFire;
import dune.component.Health;
import dune.component.MultiInput;
import dune.entity.Entity;
import dune.entity.EntityPool;
import dune.input.GamepadJsHandler;
import dune.input.KeyboardHandler;
import dune.model.controller.ControllerCamera2dTracking;
import dune.model.controller.ControllerPlatformPlayer;
import dune.model.factory.DisplayFactory;
import dune.system.physic.component.Body;
import dune.system.physic.component.BodyType;
import dune.system.physic.shapes.ShapeRect;
import dune.system.Settings;
import dune.system.SysManager;
import flash.Lib;

/**
 * ...
 * @author Namide
 */
class EntityPlayer extends Entity
{

	public function new() 
	{
		super();
	}
	
	public function init( sm:SysManager ):Void
	{
		var TS:Float = Settings.TILE_SIZE;
		
		// PLAYER
		//transform.x = i;
		//transform.y = j;
			
			health = new Health();
		
		// graphic
		
			display = DisplayFactory.movieClipToDisplay2dAnim( Lib.attach( "PlayerMC" ), sm, 1.5 * Settings.TILE_SIZE / 128 );
		
		// collision
		
			var b = new Body();
			b.typeOfCollision = BodyType.COLLISION_TYPE_ACTIVE;
			b.typeOfSolid = BodyType.SOLID_TYPE_MOVER | BodyType.SOLID_TYPE_EATER;
			b.insomniac = true;
			var sr = new ShapeRect();
			sr.w = TS * 0.8;
			sr.h = TS * 0.8;
			sr.anchorX = -0.35 * TS;
			sr.anchorY = -0.6 * TS;
			b.shape = sr;
			b.onCollideItem.push( CollisionsPlayer.vsBodyItem );
			addBody( b );
		
		
		transform.centerX = sr.w * 0.5 - sr.anchorX;
		transform.centerY = sr.h * 0.5 - sr.anchorY;
	
		// Keyboard & gamepad
		
			input = new MultiInput( new KeyboardHandler(), new GamepadJsHandler() ); 
		
		// Controller platform
		
			var c1 = new ControllerPlatformPlayer();
			c1.setRun( 8, 0.06 );
			c1.setJump( 1.5, 3, 3, 6, 0.06, 0.3 );
			addController( c1 );
			
		// Camera tracking
		
			var c2 = new ControllerCamera2dTracking( sm.sysGraphic );
			c2.setAnchor( Settings.TILE_SIZE * 1.5 * 0.5, Settings.TILE_SIZE * 1.5 * 0.5 );
			addController( c2 );
			
		// Auto fire
		
			//var bulletPool:EntityPool = new EntityPool( function():Entity { return new EntityBullet1( sm ); } ); 
			//var c3 = new ControllerAutoFire( sm, bulletPool );
			//addController( c3 );
			
			
		//sm.addEntity( this );
	}
	
}