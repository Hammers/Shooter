package
{
	import org.flixel.*;

	public class EnemyBullet extends Bullet
	{

		public function EnemyBullet()
		{
			makeGraphic(2, 2, 0xFFCC9933); 
			width = 2;
			height = 2;
			speed = 120;
		}
		
	}
}