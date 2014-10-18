package bgj8.entities;

import dune.entity.Entity;
import dune.model.factory.EntityFactory;
import dune.system.physic.component.Body;
import dune.system.physic.component.BodyType;
import dune.system.physic.shapes.ShapePoint;
import dune.system.Settings;
import dune.system.SysManager;
import flash.display.Shape;

/**
 * ...
 * @author Namide
 */
class EntityBullet1 extends Entity implements IBullet
{

	public var velocity:Float = 0.5 * Settings.TILE_SIZE;
	
	public function new( sm:SysManager ) 
	{
		super();
		
		var TS:Float = Settings.TILE_SIZE;
		var size:Float = 0.1 * TS;
		
		transform.vActive = true;
		
		// graphic
		
			display = EntityFactory.getSolidDisplay( sm, size, size );
		
		// collision
		
			var b = new Body();
			var sp = new ShapePoint();
			/*psr4.w = size;
			psr4.h = size;*/
			b.shape = sp;
			b.typeOfCollision = BodyType.COLLISION_TYPE_ACTIVE;
			b.typeOfSolid = BodyType.SOLID_TYPE_ITEM;
			addBody( b );
		
		// move
	
			/*var i4:ControllerPlatform = new ControllerPlatform();
			ball.addController( i4 );*/
			
		//systemManager.addEntity( ball );
		
		b.onCollideWall.push( function(b:Body):Void { sm.removeEntity(this); } );
	}
	
	public function init( shooter:Entity, dirX:Int, dirY:Int )
	{
		transform.x = shooter.transform.x + shooter.transform.centerX;
		transform.y = shooter.transform.y + shooter.transform.centerY;
		transform.vX = dirX * velocity;
		transform.vY = dirY * velocity;
	}
	
}