package bgj8.entities;
import bgj8.controllers.ControllerFly;
import dune.entity.Entity;
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
class EntityFly extends Entity
{
	public function new() 
	{
		super("fly");
	}
	
	public function init( sm:SysManager ):Void
	{
		var TS:Float = Settings.TILE_SIZE;
		transform.vActive = true;
		
		// PLAYER
		//transform.x = i;
		//transform.y = j;
			
		// graphic
		
			//display = DisplayFactory.movieClipToDisplay2dAnim( Lib.attach( "FlyMC" ), sm, 1.5 * Settings.TILE_SIZE / 64 );
			display = DisplayFactory.assetMcToDisplay2dAnim( "FlyMC", sm, 1.5 * Settings.TILE_SIZE / 64 );
			
			
		// collision
		
			var b = new Body();
			//b.typeOfCollision = BodyType.COLLISION_TYPE_ACTIVE;
			//b.typeOfSolid = BodyType.SOLID_TYPE_MOVER;
			b.typeOfSolid = BodyType.SOLID_TYPE_ITEM;// | BodyType.SOLID_TYPE_PLATFORM;
			//b.insomniac = true;
			var sr = new ShapeRect();
			sr.w = TS * 0.5;
			sr.h = TS * 0.5;
			sr.anchorX = -0.5 * TS;
			sr.anchorY = -0.5 * TS;
			b.shape = sr;
			addBody( b );
		
		
		//transform.centerX = sr.w * 0.5 - sr.anchorX;
		//transform.centerY = sr.h * 0.5 - sr.anchorY;
	
		// Keyboard & gamepad
		
			//input = new MultiInput( new KeyboardHandler(), new GamepadJsHandler() ); 
		
		// Controller platform
		
			var c1 = new ControllerFly( EntityRessources.SUSHI );//ControllerPlatformPlayer();
			addController( c1 );
			
		// Camera tracking
		
			/*var c2 = new ControllerCamera2dTracking( sm.sysGraphic );
			c2.setAnchor( Settings.TILE_SIZE * 1.5 * 0.5, Settings.TILE_SIZE * 1.5 * 0.5 );
			addController( c2 );*/
			
		// Auto fire
		
			//var bulletPool:EntityPool = new EntityPool( function():Entity { return new EntityBullet1( sm ); } ); 
			//var c3 = new ControllerAutoFire( sm, bulletPool );
			//addController( c3 );
			
			
		//sm.addEntity( this );
	}
	
}