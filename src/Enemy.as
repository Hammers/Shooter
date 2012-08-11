package
{
	import flash.geom.Point;

	import org.flixel.*;

	public class Enemy extends FlxSprite
	{

		//References to other game objects:
		protected var _player:Player;		//The player object
		protected var _bullets:FlxGroup;	//A group of enemy bullet objects (Enemies shoot these out)

		//We use this number to figure out how fast the ship is flying
		protected var _thrust:Number;

		//These are "timers" - numbers that count down until we want something interesting to happen.
		protected var _timer:Number;		//Helps us decide when to fly and when to stop flying.
		protected var _shotClock:Number;	//Helps us decide when to shoot.

		//This object isn't strictly necessary, and is only used with getMidpoint().
		//By passing this object, we can avoid a potentially costly allocation of
		//a new FlxPoint() object by the getMidpoint() function.
		protected var _playerMidpoint:FlxPoint;

		//This is the constructor for the enemy class.  Because we are
		//recycling enemies, we don't want our constructor to have any
		//required parameters.
		public function Enemy()
		{
			super();
			//loadRotatedGraphic(ImgBot,64,0,false,true);
			makeGraphic(12,12,0xffff0000)
			//We want the enemy's "hit box" or actual size to be
			//smaller than the enemy graphic itself, just by a few pixels.
			width = 12;
			height = 12;
			centerOffsets();

			//These parameters help control the ship's
			//speed and direction during the update() loop.
			maxAngular = 120;
			angularDrag = 400;
			drag.x = 35;
			_thrust = 0;
			_playerMidpoint = new FlxPoint();
		}

		//Each time an Enemy is recycled (in this game, by the Spawner object)
		//we call init() on it afterward.  That allows us to set critical parameters
		//like references to the player object and the ship's new position.
		public function init(xPos:int,yPos:int,Bullets:FlxGroup,ThePlayer:Player):void
		{
			_player = ThePlayer;
			_bullets = Bullets;

			reset(xPos - width/2,yPos - height/2);
			angle = angleTowardPlayer();
			health = 1;	//Enemies take 2 shots to kill
			_timer = 0;
			_shotClock = 0;
		}

		//Called by flixel to help clean up memory.
		override public function destroy():void
		{
			super.destroy();

			_player = null;
			_bullets = null;

			_playerMidpoint = null;
		}

		//This is the main flixel update function or loop function.
		//Most of the enemy's logic or behavior is in this function here.
		override public function update():void
		{
			//Then, rotate toward that angle.
			//We could rotate instantly toward the player by simply calling:
			//angle = angleTowardPlayer();
			//However, we want some less predictable, more wobbly behavior.
			var da:Number = angleTowardPlayer();
			if(da < angle)
				angularAcceleration = -angularDrag;
			else if(da > angle)
				angularAcceleration = angularDrag;
			else
				angularAcceleration = 0;

			//Set the bot's movement speed and direction
			//based on angle and whether the jets are on.
			_thrust = FlxU.computeVelocity(_thrust,90,drag.x,60);
			FlxU.rotatePoint(0,_thrust,0,0,angle,velocity);

			//Shooting - three shots every few seconds
			if(onScreen())
			{
				var shoot:Boolean = false;
				var os:Number = _shotClock;
				_shotClock += FlxG.elapsed;
				if((os < 4.0) && (_shotClock >= 4.0))
				{
					_shotClock = 0;
					shoot = true;
				}
				else if((os < 3.5) && (_shotClock >= 3.5))
					shoot = true;
				else if((os < 3.0) && (_shotClock >= 3.0))
					shoot = true;

				//If we rolled over one of those time thresholds,
				//shoot a bullet out along the angle we're currently facing.
				if(shoot)
				{
					//First, recycle a bullet from the bullet pile.
					//If there are none, recycle will automatically create one for us.
					var b:EnemyBullet = _bullets.recycle(EnemyBullet) as EnemyBullet;
					//Then, shoot it from our midpoint out along our angle.
					b.shoot(getMidpoint(_point),angle);
				}
			}

			//Then call FlxSprite's update() function, to automate
			// our motion and animation and stuff.
			super.update();
			
		}

		//Even though we updated the jets after we updated the Enemy,
		//we want to draw the jets below the Enemy, so we call _jets.draw() first.
		override public function draw():void
		{
			super.draw();
		}

		//This function is called when player bullets hit the Enemy.
		//The enemy is told to flicker, points are awarded to the player,
		//and damage is dealt to the Enemy.
		override public function hurt(Damage:Number):void
		{
			//FlxG.play(SndHit);
			//flicker(0.2);
			FlxG.score += 10;
			super.hurt(Damage);
		}

		//Called to kill the enemy.  A cool sound is played,
		//the jets are turned off, bits are exploded, and points are rewarded.
		override public function kill():void
		{
			if(!alive)
				return;
			//FlxG.play(SndExplode);
			super.kill();
			//flicker(0);
			FlxG.score += 200;
		}

		//A helper function that returns the angle between
		//the Enemy's midpoint and the player's midpoint.
		protected function angleTowardPlayer():Number
		{
			return FlxU.getAngle(getMidpoint(_point),_player.getMidpoint(_playerMidpoint));
		}
	}
}