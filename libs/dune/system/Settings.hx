package dune.system;

/**
 * ...
 * @author ...
 */
class Settings
{
	public static inline var FRAME_DELAY:UInt = 20; // =20; - 50 FPS => 1000 / 50
	public static inline var GRAVITY:Float =  40 / Settings.FRAME_DELAY;
	
	public static inline var TEXT_QUALITY:Float =  1;
	//public static inline var FRAME_ANIM:UInt = 100;
	
	public static inline var TILE_SIZE:UInt = 60;
	//public inline static var TILE_SIZE:UInt = 32;
	
	public static inline var X_MIN:UInt = - TILE_SIZE;
	public static inline var Y_MIN:UInt = - TILE_SIZE;
	public static inline var X_MAX:UInt = 50 * TILE_SIZE;
	public static inline var Y_MAX:UInt = 50 * TILE_SIZE;
	
	public static var LIMIT_LEFT:UInt = 0;
	public static var LIMIT_RIGHT:UInt = 12 * TILE_SIZE;
	public static var LIMIT_TOP:UInt = 0;
	public static var LIMIT_DOWN:UInt = 50 * TILE_SIZE;
	
	public function new() 
	{
		throw "Static class!";
	}
	
	
	
}