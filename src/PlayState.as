package
{
	/**
	 * ...
	 * @author One More Machine
	 */
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		
		/**
         * Player
         */
        public var _player:Player;
        public var playerStart:FlxPoint = new FlxPoint(100, 100);
		
		public var _enemy:Enemy;
		
		
		//Groups
		protected var _enemies:FlxGroup;
		protected var _bullets:FlxGroup;
		protected var _enemyBullets:FlxGroup;
		protected var _hazards:FlxGroup;
		
        /**
         * Create state
         */
        override public function create():void {
            FlxG.mouse.show();
			
			//Create Groups
			_enemies = new FlxGroup();
			_bullets = new FlxGroup();
			_enemyBullets = new FlxGroup();
			add(_enemies);
			add(_bullets);
			add(_enemyBullets);
			
			//Now that we have references to the bullets,
			//we can create the player object.
			_player = new Player(playerStart.x, playerStart.y, _bullets);
			add(_player);
			_enemy = new Enemy()
			_enemy.init(400, 100, _enemyBullets, _player)
			add(_enemy)
			
			//Finally we are going to sort things into a couple of helper groups.
			//We don't add these groups to the state, we just use them for collisions later!
			_hazards = new FlxGroup();
			_hazards.add(_enemyBullets);
			_hazards.add(_enemy);
			_hazards.add(_enemies);
		}
		
		override public function update():void
		{
			super.update()
			FlxG.overlap(_hazards,_player,overlapped);
			FlxG.overlap(_bullets,_hazards,overlapped);
		}
		
		//This is an overlap callback function, triggered by the calls to FlxU.overlap().
		protected function overlapped(Sprite1:FlxSprite,Sprite2:FlxSprite):void
		{
			if((Sprite1 is EnemyBullet) || (Sprite1 is Bullet))
				Sprite1.kill();
			Sprite2.hurt(1);
		}
		
		override public function destroy():void
		{
			super.destroy();

			_bullets = null;
			_player = null;

		}
		
	}

}