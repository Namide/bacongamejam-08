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
	public var vel:Float = 0.1 * Settings.TILE_SIZE;
	
	public function new( target:Entity ) 
	{
		super();
		_target = target;
	}
	
	override public function execute(dt:UInt):Void 
	{
		var p:Point = new Point( 	_target.transform.x - entity.transform.x,
									_target.transform.y - entity.transform.y );
		p.normalize( vel );
		
		entity.transform.vX = p.x;
		entity.transform.vY = p.y;
		
		
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