package bgj8.controllers;

import dune.component.ComponentType;
import dune.component.Controller;
import dune.entity.Entity;
import dune.helper.core.BitUtils;
import dune.helper.core.DTime;
import dune.system.Settings;
import flash.geom.Point;

/**
 * ...
 * @author Namide
 */
class ControllerWasp extends Controller
{

	var _target:Entity;
	public var vel:Float = 0.1 * Settings.TILE_SIZE;
	
	var anchorTargetX:Float;
	var anchorTargetY:Float;
	
	var _wakeUp:UInt;
	
	public function ko( time:Int = 2000 ):Void
	{
		entity.transform.vX = 0;
		entity.transform.vY = 0;
		_wakeUp = DTime.getRealMS() + time;
		
		var display = entity.display;
		if ( BitUtils.has( display.type, ComponentType.DISPLAY_ANIMATED ) )
		{
			display.play( "ko" );
		}
	}
	
	public function new( target:Entity ) 
	{
		super();
		_target = target;
		anchorTargetX = Math.random() * Settings.TILE_SIZE - (Settings.TILE_SIZE >> 1);
		anchorTargetY = - 0.2 * Settings.TILE_SIZE;
		_wakeUp = DTime.getRealMS();
	}
	
	override public function execute(dt:UInt):Void 
	{
		if ( _wakeUp > DTime.getRealMS() ) return;
		
		var p:Point = new Point( 	anchorTargetX + _target.transform.x - entity.transform.x,
									anchorTargetY + _target.transform.y - entity.transform.y );
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