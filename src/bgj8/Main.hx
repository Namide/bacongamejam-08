package bgj8;

import flash.display.MovieClip;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import flash.text.TextField;
import hxd.Timer;
import tweenx909.TweenX;

/**
 * ...
 * @author Namide
 */

class Main 
{
	static var _g:Game;
	static var _start:MovieClip;
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		
		/*var s = new net.hires.debug.Stats();
		s.x = 800 - 69;
		Lib.current.addChild( s );*/
		
		getStart();
	}
	
	static function getStart():Void
	{
		if ( _g != null )
		{
			_g.dispose();
			TweenX.clear();
			_g = null;
		}
		
		_start = Lib.attach( "StartScreenMC" );
		Lib.current.stage.addChild( _start );
		
		var txt:TextField = cast( _start.getChildByName("scoreT"), TextField );
		if ( Score.points == 0 ) 	txt.text = "";
		else						txt.text = "last score " + Std.string(Score.points) + " pts";
		
		Lib.current.stage.addEventListener( Event.RESIZE, resizeMC );
		_start.addEventListener( MouseEvent.CLICK, getGame );
		resizeMC();
	}
	
	static function resizeMC(e:Event = null):Void
	{
		var stage:Stage = Lib.current.stage;
		var prop:Float = 1280 / 720;
		var sProp:Float = stage.stageWidth / stage.stageHeight;
		
		var s:Float;
		if ( prop > sProp )
		{
			s = stage.stageWidth / 1280;
		}
		else
		{
			s = stage.stageHeight / 720;
		}
		s = Math.fround( s * 128 ) / 128;
		_start.scaleX = _start.scaleY = s;
		_start.x = Math.round( ( stage.stageWidth - 1280 * s ) * 0.5 );
		_start.y = Math.round( ( stage.stageHeight - 720 * s ) * 0.5 );
	}
	
	static function getGame( e:Dynamic = null ):Void
	{
		if ( _start != null )
		{
			Lib.current.stage.removeEventListener( Event.RESIZE, resizeMC );
			_start.removeEventListener( MouseEvent.CLICK, getGame );
			_start.parent.removeChild( _start );
			_start = null;
		}
		
		_g = new Game();
		_g.onEnd = getStart;
	}
	
}