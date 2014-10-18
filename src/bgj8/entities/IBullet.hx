package bgj8.entities;
import dune.entity.Entity;
import dune.system.SysManager;

/**
 * @author Namide
 */

interface IBullet 
{
	public function init( shooter:Entity, dirX:Int, dirY:Int ):Void;
}