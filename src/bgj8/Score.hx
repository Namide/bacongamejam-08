package bgj8;
import dune.system.SysManager;
import hxd.Res;

/**
 * ...
 * @author Namide
 */
class Score
{

	static public var points(default, set):Float = 0;
	static function set_points( val:Float ):Float
	{
		points = val;
		_tf.text = Std.string( points ) + " pts";
		trace(points);
		return points;
	}
	
	static var _tf:h2d.Text;
	
	public function new() 
	{
		throw "static class!";
	}
	
	static public function getScoreSprite( sm:SysManager ):h2d.Text
	{
		var f = hxd.Res.trueTypeFont;
		var font = f.build(40);
		_tf = new h2d.Text( font, sm.sysGraphic.s2d );
		_tf.textColor = 0xFFFFFF;
		//tf.dropShadow = { dx : 3, dy : 3, color : 0xFF0000, alpha : 0.8 };
		//_tf.text

		// set the text position
		_tf.x = 30;
		_tf.y = 30;//s2d.height - 80;

		points = 0;
		//trace(points);
		return _tf;
		
		//var font = hxd.Res.customFont.toFont();
	}
	
}