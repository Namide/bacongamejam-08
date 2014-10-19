package bgj8.controllers;

import dune.component.ComponentType;
import dune.component.Controller;
import dune.entity.Entity;
import dune.helper.core.BitUtils;
import dune.system.Settings;
import flash.geom.Point;

/**
 * ...
 * @author Namide
 */
class ControllerFly extends Controller
{

	var _target:Entity;
	
	//public var vel:Float = 0.1 * Settings.TILE_SIZE;
	public var velMax:Float = 0.1 * Settings.TILE_SIZE;
	public var velAcc:Float = 0.005 * Settings.TILE_SIZE;
	
	var anchorTargetX:Float;
	var anchorTargetY:Float;
	
	public function new( target:Entity ) 
	{
		super();
		_target = target;
		anchorTargetX = Math.random() * Settings.TILE_SIZE - (Settings.TILE_SIZE >> 1);
		anchorTargetY = Math.random() * Settings.TILE_SIZE - (Settings.TILE_SIZE >> 1) - 1.5 * Settings.TILE_SIZE;
	}
	
	override public function execute(dt:UInt):Void 
	{
		var p:Point = new Point( 	anchorTargetX + _target.transform.x - entity.transform.x,
									anchorTargetY + _target.transform.y - entity.transform.y );
		/*p.normalize( vel );
		
		entity.transform.vX = p.x;
		entity.transform.vY = p.y;*/
		if ( p.x < 0 ) entity.transform.vX -= velAcc;
		else if ( p.x > 0 ) entity.transform.vX += velAcc;
		
		if ( p.y < 0 ) entity.transform.vY -= velAcc;
		else if ( p.y > 0 ) entity.transform.vY += velAcc;
		
		entity.transform.vY = Math.max( Math.min( entity.transform.vY, velMax ), -velMax );
		entity.transform.vX = Math.max( Math.min( entity.transform.vX, velMax ), -velMax );
		
		// ANIMATIONS
		
		var display = entity.display;
		
		if ( entity.transform.vX < 0 )			display.setToRight( false );
		else if ( entity.transform.vX > 0 ) 	display.setToRight( true );
		
		if ( BitUtils.has( display.type, ComponentType.DISPLAY_ANIMATED ) )
		{
			if ( entity.transform.vX == 0 && entity.transform.vY == 0 ) 	display.play( "stand" );
			else															display.play( "fly" );
		}
	}
	
}