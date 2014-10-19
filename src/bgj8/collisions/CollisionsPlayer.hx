package bgj8.collisions;
import bgj8.controllers.ControllerWasp;
import bgj8.entities.EntityRessources;
import dune.entity.Entity;
import dune.model.factory.DisplayFactory;
import dune.system.physic.component.Body;
import dune.system.Settings;
import flash.geom.Point;
import h2d.Sprite;
import tweenx909.EaseX;
import tweenx909.EventX;
import tweenx909.TweenX;

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
				//EntityRessources.SM.removeEntity( bodyItem.entity );
				
				var x:Float = bodyItem.entity.transform.x;
				var y:Float = bodyItem.entity.transform.y;
				
				EntityRessources.SM.removeEntity( bodyItem.entity );
				bodyPlayer.entity.transform.vY = -0.5 * Settings.TILE_SIZE;
				
				var sm = EntityRessources.SM;
				var sd = DisplayFactory.assetMcToSprite( "WaspDeadMC", sm, 1.5 * Settings.TILE_SIZE / 64, Settings.TEXT_QUALITY, new Point( 0.5 * Settings.TILE_SIZE, 0.5 * Settings.TILE_SIZE ) );
				var display = sd.sprite;
				deadFall( display, x, y );
				
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
			var x:Float = bodyItem.entity.transform.x;
			var y:Float = bodyItem.entity.transform.y;
			
			EntityRessources.SM.removeEntity( bodyItem.entity );
			bodyPlayer.entity.transform.vY = -0.5 * Settings.TILE_SIZE;
			
			var sm = EntityRessources.SM;
			var sd = DisplayFactory.assetMcToSprite( "FlyDeadMC", sm, 1.5 * Settings.TILE_SIZE / 64, Settings.TEXT_QUALITY, new Point( 0.5 * Settings.TILE_SIZE, 0.5 * Settings.TILE_SIZE ) );
			var display = sd.sprite;
			deadFall( display, x, y );
		}
		
		
	}
	
	static function deadFall( display:Sprite, x:Float, y:Float ):Void
	{
		var sm = EntityRessources.SM;
		
		display.y = y;
		display.scaleX = (Math.random() > 0.5) ? -1 : 1;
		display.x = x + ( (display.scaleX < 0) ? Settings.TILE_SIZE : 0.0 );
		sm.sysGraphic.camera2d.display.addChild( display );
		
		var xMove:Float = ( Math.random() * 2 * Std.int(Settings.TILE_SIZE) - Std.int(Settings.TILE_SIZE) );
		var yMove:Float = Std.int(10 * Settings.TILE_SIZE);
		var rotMove:Float = (Math.random() * 2 * Math.PI - Math.PI);
		
		TweenX.to( display, { scaleX:2, scaleY:2 } )
			.time( 0.7 )
			.ease( EaseX.linear );
		
		TweenX.to( display, { 	x:(xMove * 0.5), 
								y:(-yMove / 4)
							} )
			.time( 0.2 )
			.ease( EaseX.circOut );
		
		TweenX.to( display, { 	x:xMove, 
								y:(yMove) } )
			.delay( 0.2 )
			.time( 0.3 )
			.ease( EaseX.circIn )
			.onFinish( function():Void { sm.sysGraphic.camera2d.display.removeChild( display ); } );
	}
}