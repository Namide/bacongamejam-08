package bgj8.collisions;
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
			
		}
		
	}
	
	public static function vsFly( bodyPlayer:Body, bodyItem:Body ):Void
	{
		if ( 	bodyPlayer.shape.aabbYMax < bodyItem.shape.aabbYMax &&
				bodyPlayer.entity.transform.vY > 0 )
		{
			bodyPlayer.entity.transform.vY = -0.5 * Settings.TILE_SIZE;
			EntityRessources.sm.removeEntity( bodyItem.entity );
		}
		
		/*var player:Entity = EntityRessources.player;
		if ( player.transform.y < fly.transform.y )
		{
			player.transform.vY = -0.5 * Settings.TILE_SIZE;
			EntityRessources.sm.removeEntity( fly );
		}*/
	}
	
}