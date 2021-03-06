package dune.system.core;

import dune.component.Transform;
import dune.helper.core.FloatUtils;
import dune.system.core.SpaceGrid.Grid;
import dune.system.core.SpaceGrid.Node;
import dune.system.physic.component.Body;
import dune.system.physic.component.BodyType;
import dune.system.physic.shapes.ShapeUtils;

class Grid
{
	public var minTileX(default, null):Int;
	public var minTileY(default, null):Int;
	public var maxTileX(default, null):Int;
	public var maxTileY(default, null):Int;
	
	var _grid:Array<Array<Array<Node>>>;
	
	public function new( minTileX:Int, minTileY:Int, maxTileX:Int, maxTileY:Int )
	{
		this.minTileX = minTileX;
		this.minTileY = minTileY;
		this.maxTileX = maxTileX;
		this.maxTileY = maxTileY;
		
		_grid = [];
		var x:Int = -1;
		for ( i in minTileX...maxTileX )
		{
			_grid[++x] = [];
			var y:Int = -1;
			for ( j in minTileY...maxTileY )
			{
				_grid[x][++y] = [];
			}
		}
	}
	
	public inline function remove( i:Int, j:Int, node:Node ):Void
	{
		if ( 	i >= minTileX && i < maxTileX &&
				j >= minTileY && j < maxTileY )
		{
			_grid[i-minTileX][j-minTileY].remove( node );
		}
	}
	
	public inline function push( i:Int, j:Int, node:Node ):Void
	{
		if ( 	i >= minTileX && i < maxTileX &&
				j >= minTileY && j < maxTileY )
		{
			_grid[i-minTileX][j-minTileY].push( node );
		}
	}

	public inline function getNodes( i:Int, j:Int ):Array<Node>
	{
		return ( i >= minTileX && i < maxTileX && j >= minTileY && j < maxTileY ) ? _grid[i - minTileX][j - minTileY] : [];
	}
	
	public function getContacts( n:Node ):Array<Node>
	{
		var c:Array<Node> = [n];
		for ( i in n.minTileX...n.maxTileX )
		{
			for ( j in n.minTileY...n.maxTileY )
			{
				for ( n2 in getNodes( i, j ) )
				{
					if ( !Lambda.has( c, n2 ) ) c.push( n2 );
				}
			}
		}
		c.remove( n );
		return c;
	}
}

class Node
{
	public var body(default, null):Body;
	
	public var lastX(default, default):Float;
	public var lastY(default, default):Float;
	
	public var minTileX(default, default):Int;
	public var minTileY(default, default):Int;
	public var maxTileX(default, default):Int;
	public var maxTileY(default, default):Int;
	
	public function new( body:Body )
	{
		this.body = body;
	}
	
	public function init( pitchExpX:Int, pitchExpY:Int, grid:Grid )
	{
		minTileX = -1;
		minTileY = -1;
		maxTileX = -1;
		maxTileY = -1;
		
		refresh( pitchExpX, pitchExpY, grid );
	}
	
	public function removeFromGrid( grid:Grid )
	{
		for ( i in minTileX...maxTileX )
		{
			for ( j in minTileY...maxTileY )
			{
				grid.remove( i, j, this );
			}
		}
	}
	
	public function refresh( pitchExpX:Int, pitchExpY:Int, grid:Grid ):Void
	{
		var nXMin:Int = (Math.floor(body.shape.aabbXMin) >> pitchExpX);
		var nYMin:Int = (Math.floor(body.shape.aabbYMin) >> pitchExpY);
		var nXMax:Int = (Math.ceil(body.shape.aabbXMax) >> pitchExpX) + 1;
		var nYMax:Int = (Math.ceil(body.shape.aabbYMax) >> pitchExpY) + 1;
		
		if ( 	nXMin != minTileX ||
				nYMin != minTileY ||
				nXMax != maxTileX ||
				nYMax != maxTileY )
		{
			for ( i in minTileX...maxTileX )
			{
				for ( j in minTileY...maxTileY )
				{
					grid.remove( i, j, this );
				}
			}
			
			for ( i in nXMin...nXMax )
			{
				for ( j in nYMin...nYMax )
				{
					grid.push( i, j, this );
				}
			}
			
			minTileX = nXMin;
			minTileY = nYMin;
			maxTileX = nXMax;
			maxTileY = nYMax;
		}
	}
	
}

/**
 * ...
 * @author Namide
 */
class SpaceGrid implements ISpace
{
	public var all(default, null):List<Body>;
	
	public var _active(default, null):Array<Node>;
	public var _activeSleeping(default, null):Array<Node>;
	public var _passive(default, null):Array<Node>;
	
	public var _pitchX:Int;
	public var _pitchY:Int;
	public var _grid:Grid;
	
	var _pitchXExp:Int;
	var _pitchYExp:Int;
	
	public function new() 
	{
		_active = [];
		_activeSleeping = [];
		_passive = [];
		all = new List<Body>();
		init();
	}
	
	public function init( 	minX:Int = Settings.X_MIN,
							minY:Int = Settings.Y_MIN,
							maxX:Int = Settings.X_MAX,
							maxY:Int = Settings.Y_MAX,
							pitchX:Int = Settings.TILE_SIZE,
							pitchY:Int = Settings.TILE_SIZE ):Void
	{
		_pitchX = FloatUtils.getNextPow( pitchX );
		_pitchY = FloatUtils.getNextPow( pitchY );
		
		_pitchXExp = FloatUtils.getExposantInt( _pitchX );
		_pitchYExp = FloatUtils.getExposantInt( _pitchY );
		
		_grid = new Grid( 	minX >> _pitchXExp,
							minY >> _pitchYExp,
							maxX >> _pitchXExp,
							maxY >> _pitchYExp );
		
		for ( node in _passive )
		{
			node.init( _pitchXExp, _pitchYExp, _grid );
		}
		
		for ( node in _active )
		{
			node.init( _pitchXExp, _pitchYExp, _grid );
		}
	}
	
	public function testSleeping():Void
	{
		for ( node in _active )
		{
			if ( node.body.insomniac ) continue;
			var t:Transform = node.body.entity.transform;
			if ( node.lastX == t.x && node.lastY == t.y )
			{
				_active.remove( node );
				_activeSleeping.push( node );
				//trace("sleep! active:" + _active.length + "/" + (_active.length+_activeSleeping.length) );
			}
			else
			{
				node.lastX = t.x;
				node.lastY = t.y;
			}
			
		}
		
		for ( node in _activeSleeping )
		{
			var t:Transform = node.body.entity.transform;
			if ( node.lastX != t.x || node.lastY != t.y )
			{
				_activeSleeping.remove( node );
				_active.push( node );
				
				node.lastX = t.x;
				node.lastY = t.y;
				//trace("walk!");
			}
		}
	}
	
	public function hitTest():List<Body>
	{
		var affected:List<Body> = new List<Body>();
		
		
		for ( node in _passive )
		{
			node.body.shape.updateAABB( node.body.entity.transform );
			node.refresh( _pitchXExp, _pitchYExp, _grid );
		}
		
		for ( node in _activeSleeping )
		{
			var t:Transform = node.body.entity.transform;
			if ( node.lastX != t.x || node.lastY != t.y )
			{
				_activeSleeping.remove( node );
				_active.push( node );
				//trace("walk!");
			}
		}
		
		for ( node in _active )
		{
			var b:Body = node.body;
			node.lastX = b.entity.transform.x;
			node.lastY = b.entity.transform.y;
			
			var isAffected:Bool = false;
			b.contacts.clear();
			b.shape.updateAABB( b.entity.transform );
			
			node.refresh( _pitchXExp, _pitchYExp, _grid );
			var contacts:Array<Node> = _grid.getContacts( node );
			for ( node2 in contacts )
			{
				if ( ShapeUtils.hitTest( b.shape, node2.body.shape ) )
				{
					b.contacts.push( node2.body );
					if ( !isAffected )
					{
						isAffected = true;
						affected.push( b );
					}
				}
			}
		}
		
		return affected;
	}
	
	/**
	 * Add a body in this system
	 * 
	 * @param	body			Body to add in the system
	 */
	public function addBody( body:Body ):Void
	{
		var node:Node = new Node( body );
		node.init( _pitchX, _pitchY, _grid );
		
		if ( body.typeOfCollision == BodyType.COLLISION_TYPE_PASSIVE )
		{
			_passive.push( node );
		}
		else
		{
			_active.push( node );
		}
		all.push( body );
	}
	
	/**
	 * Remove the body of the system
	 * 
	 * @param	body			Body to add
	 * @param	rebuildGrid		Clear the grid and buid it
	 */
	public function removeBody( body:Body ):Void
	{
		if ( body.typeOfCollision == BodyType.COLLISION_TYPE_PASSIVE )
		{
			var node:Node = Lambda.find( _passive, function( n:Node ):Bool { return n.body == body; } );
			node.removeFromGrid( _grid );
			_passive.remove( node );
		}
		else
		{
			var node:Node = Lambda.find( _active, function( n:Node ):Bool { return n.body == body; } );
			node.removeFromGrid( _grid );
			_active.remove( node );
		}
		all.remove( body );
	}
	
	#if (debugHitbox && (flash || openfl ))
	
		public function draw(scene:flash.display.Sprite):Void
		{
			scene.graphics.lineStyle( 1, 0xCCCCCC, 0.5 );
			
			for ( i in _grid.minTileX..._grid.maxTileX )
			{
				for ( j in _grid.minTileY..._grid.maxTileY )
				{
					scene.graphics.beginFill( 0xFFFFFF, _grid.getNodes( i, j ).length / 4 );
					scene.graphics.drawRect( 	i * _pitchX,
												j * _pitchY,
												_pitchX,
												_pitchX );
				}
			}
		}
		
	#end
	
}