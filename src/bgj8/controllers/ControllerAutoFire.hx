package bgj8.controllers ;

import bgj8.entities.EntityBullet1;
import bgj8.entities.IBullet;
import dune.component.Controller;
import dune.entity.Entity;
import dune.entity.EntityPool;
import dune.system.SysManager;

/**
 * ...
 * @author Namide
 */
class ControllerAutoFire extends Controller
{

	public var _delay:UInt = 100;
	
	var _t:UInt = 0;
	var _nextFireT:UInt = 0;
	
	var _sm:SysManager;
	var _pool:EntityPool;
	
	public function new( sm:SysManager, pool:EntityPool ) 
	{
		super();
		_sm = sm;
		_pool = pool;
	}
	
	override public function execute(dt:UInt):Void 
	{
		_t += dt;
		if ( _t >= _nextFireT )
		{
			_nextFireT = _t + _delay;
			fire();
		}
	}
	
	function fire():Void
	{
		//trace("fire");
		var bullet:IBullet = cast( _pool.get(), IBullet );
		bullet.init( entity, entity.transform.dirX, entity.transform.dirY );
		_sm.addEntity( cast( bullet, Entity ) /*new EntityBullet1( _sm, entity, entity.transform.dirX, entity.transform.dirY )*/ );
	}
	
}