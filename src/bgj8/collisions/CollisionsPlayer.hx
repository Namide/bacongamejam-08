package bgj8.collisions;
import bgj8.controllers.ControllerWasp;
import bgj8.entities.EntityRessources;
import dune.entity.Entity;
import dune.system.physic.component.Body;
import dune.system.Settings;

/**
 * ...
 * @author Namide
 */
class CollisionsPlayer
{

	public function new() 
	{
		
	}

	public static function vsBodyItem( bodyPlayer:Body, bodyItem:Body ):Void
	{
		var item:Entity = bodyItem.entity;
		
		switch( item.name )
		{
			case "fly": vsFly( bodyPlayer, bodyItem );
			case "wasp": vsWasp( bodyPlayer, bodyItem );
		}
		
	}
	
	public static function vsWasp( bodyPlayer:Body, bodyItem:Body ):Void
	{
		if ( 	bodyPlayer.shape.aabbYMax < bodyItem.shape.aabbYMax &&
				bodyPlayer.entity.transform.vY > bodyItem.entity.transform.vY + 0.05 )
		{
			bodyPlayer.entity.transform.vY = -0.5 * Settings.TILE_SIZE;
			bodyItem.entity.health.health -= 0.5;
			
			if ( bodyItem.entity.health.health <= 0 )
			{
				EntityRessources.sm.removeEntity( bodyItem.entity );
			}
			else
			{
				cast(bodyItem.entity.controllers[0], ControllerWasp).ko();
			}
		}
		else
		{
			var dir:Int = (bodyItem.entity.transform.vX > 0) ? 1 : (bodyItem.entity.transform.vX < 0) ? -1 : 0;
			bodyPlayer.entity.transform.vX = dir * 0.4 * Settings.TILE_SIZE;
			bodyPlayer.entity.transform.vY = -0.25 * Settings.TILE_SIZE;
			
		}
	}
	
	public static function vsFly( bodyPlayer:Body, bodyItem:Body ):Void
	{
		if ( 	bodyPlayer.shape.aabbYMax < bodyItem.shape.aabbYMax &&
				bodyPlayer.entity.transform.vY > bodyItem.entity.transform.vY + 0.05 )
		{
			EntityRessources.sm.removeEntity( bodyItem.entity );
			bodyPlayer.entity.transform.vY = -0.5 * Settings.TILE_SIZE;
		}
	}
	
}