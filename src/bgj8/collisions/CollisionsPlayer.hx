package bgj8.collisions;
import bgj8.controllers.ControllerWasp;
import bgj8.entities.EntityRessources;
import bgj8.Score;
import dune.entity.Entity;
import dune.model.factory.DisplayFactory;
import dune.system.physic.component.Body;
import dune.system.Settings;
import flash.geom.Point;
import h2d.Sprite;
import haxe.Timer;
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
	
	public static function hurt( bodyPlayer:Body ):Void
	{
		bodyPlayer.entity.health.heart();
		
		var x:Float = bodyPlayer.entity.transform.x - Std.int(1 * Settings.TILE_SIZE);
		var y:Float = bodyPlayer.entity.transform.y - Std.int(1 * Settings.TILE_SIZE);
		
		var sm = EntityRessources.SM;
		var anim = DisplayFactory.assetMcToAnim( "HurtMC", sm, 1 * Settings.TILE_SIZE / 64 );
		
		anim.setPos( x, y );
		sm.sysGraphic.camera2d.display.addChild( anim );
		
		anim.onAnimEnd = function():Void { sm.sysGraphic.camera2d.display.removeChild( anim ); };
		
		//TweenX.to(anim).time(1).onFinish(function():Void { trace("deleted"); sm.sysGraphic.camera2d.display.removeChild( anim ); } );
		//haxe.Timer.delay( function():Void { sm.sysGraphic.camera2d.display.removeChild( anim ); }, 1000 );
	}
	
	public static function addPt( bodyPlayer:Body, pts:Float = 1 ):Void
	{
		Score.points += pts;
			
		var x:Float = bodyPlayer.entity.transform.x + Std.int(0.5 * Settings.TILE_SIZE);
		var y:Float = bodyPlayer.entity.transform.y + Std.int(0.5 * Settings.TILE_SIZE);
		
		var sm = EntityRessources.SM;
		
		var sd;
		if ( pts > 4 ) 			sd = DisplayFactory.assetMcToSprite( "Point8MC", sm, 1.5 * Settings.TILE_SIZE / 64 );
		else if ( pts > 1 ) 	sd = DisplayFactory.assetMcToSprite( "Point4MC", sm, 1.5 * Settings.TILE_SIZE / 64 );
		else 					sd = DisplayFactory.assetMcToSprite( "PointMC", sm, 1.5 * Settings.TILE_SIZE / 64 );
		
		var display = sd.sprite;
		
		var rot:Float = (Math.random() * Math.PI * 0.25 - Math.PI * 0.125);
		display.setPos( x, y );
		display.rotation = rot;
		sm.sysGraphic.camera2d.display.addChild( display );
		
		var xMove:Float = Std.int(2 * Settings.TILE_SIZE) * Math.cos( rot - Math.PI * 0.5 );
		var yMove:Float = Std.int(2 * Settings.TILE_SIZE) * Math.sin( rot - Math.PI * 0.5 );
		
		TweenX.to( display, { 	x:xMove, 
								y:yMove
							} )
			.time( 0.5 )
			.ease( EaseX.circOut )
			.onFinish( function():Void { sm.sysGraphic.camera2d.display.removeChild( display ); } );
	}
	
	public static function vsWasp( bodyPlayer:Body, bodyItem:Body ):Void
	{
		if ( 	bodyPlayer.shape.aabbYMax < bodyItem.shape.aabbYMax &&
				bodyPlayer.entity.transform.vY > bodyItem.entity.transform.vY + 0.05 )
		{
			bodyPlayer.entity.transform.vY = -0.25 * Settings.TILE_SIZE;
			bodyItem.entity.health.health -= 0.5;
			
			
			if ( bodyItem.entity.health.health <= 0 )
			{
				//EntityRessources.SM.removeEntity( bodyItem.entity );
				
				var x:Float = bodyItem.entity.transform.x;
				var y:Float = bodyItem.entity.transform.y;
				
				EntityRessources.SM.removeEntity( bodyItem.entity );
				bodyPlayer.entity.transform.vY = -0.25 * Settings.TILE_SIZE;
				
				var sm = EntityRessources.SM;
				var sd = DisplayFactory.assetMcToSprite( "WaspDeadMC", sm, 1.5 * Settings.TILE_SIZE / 64 );
				var display = sd.sprite;
				deadFall( display, x, y );
				
				addPt( bodyPlayer, 10 );
			}
			else
			{
				cast(bodyItem.entity.controllers[0], ControllerWasp).ko();
				
				addPt( bodyPlayer, 5 );
			}
		}
		else if( !bodyPlayer.entity.health.isHearted() )
		{
			var dir:Int = (bodyItem.entity.transform.vX > 0) ? 1 : (bodyItem.entity.transform.vX < 0) ? -1 : 0;
			bodyPlayer.entity.transform.vX = dir * 0.2 * Settings.TILE_SIZE;
			bodyPlayer.entity.transform.vY = -0.3 * Settings.TILE_SIZE;
			hurt( bodyPlayer );
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
			bodyPlayer.entity.transform.vY = -0.25 * Settings.TILE_SIZE;
			
			var sm = EntityRessources.SM;
			var sd = DisplayFactory.assetMcToSprite( "FlyDeadMC", sm, 1.5 * Settings.TILE_SIZE / 64 );
			var display = sd.sprite;
			deadFall( display, x, y );
			
			addPt( bodyPlayer );
			//Score.points++;
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