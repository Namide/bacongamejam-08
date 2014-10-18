package bgj8;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Namide
 */

class Main 
{
	static var _g:Game;
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		
		var s = new net.hires.debug.Stats();
		s.x = 800 - 69;
		Lib.current.addChild( s );
		
		_g = new Game();
	}
	
}