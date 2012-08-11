package 
{
    import org.flixel.*;
    /**
     * Player-controlled entity
     * @author Ryan Hamlet
     */
    public class Player extends FlxSprite
    {
        
		public static const MAXSPEED:Number = 120;
		
		protected var _bullets:FlxGroup;
		protected var _restart:Number;
		 
        //This is the player object class.  Most of the comments I would put in here
		//would be near duplicates of the Enemy class, so if you're confused at all
		//I'd recommend checking that out for some ideas!
		public function Player(X:int,Y:int,Bullets:FlxGroup)
		{
			super(X,Y);
			loadGraphic(Assets.PLAYER_SHIP,true,true,14,12);
			_restart = 0;

			//bounding box tweaks
			width = 12;
			height = 10;
			offset.x = 1;
			offset.y = 1;

			//basic player physics
			maxVelocity.x = MAXSPEED;
			maxVelocity.y = MAXSPEED;
			drag = new FlxPoint(MAXSPEED * 8, MAXSPEED * 8);
			

			//bullet stuff
			_bullets = Bullets;
		}

		override public function destroy():void
		{
			super.destroy();
			_bullets = null;
		}

		override public function update():void
		{
			//game restart timer
			if(!alive)
			{
				_restart += FlxG.elapsed;
				if(_restart > 2)
					FlxG.resetState();
				return;
			}
			acceleration.x = acceleration.y = 0; 
			var movement:FlxPoint = new FlxPoint();
			if (FlxG.keys.pressed("LEFT"))
				movement.x -= 1;
			if (FlxG.keys.pressed("RIGHT"))
				movement.x += 1;
			if (FlxG.keys.pressed("UP"))
				movement.y -= 1;
			if (FlxG.keys.pressed("DOWN"))
				movement.y += 1;
			// check final movement direction
			if (movement.x < 0)
				acceleration.x = MAXSPEED * -8;
			else if (movement.x > 0)
				acceleration.x = MAXSPEED * 8;
			if (movement.y < 0)
				acceleration.y = MAXSPEED * -8;
			else if (movement.y > 0)
				acceleration.y = MAXSPEED * 8;

			//SHOOTING
			if(FlxG.keys.justPressed("SPACE"))
			{
				getMidpoint(_point);
				for (var i:Number = 0; i < 8; i++)
				{
					(_bullets.recycle(Bullet) as Bullet).shoot(_point, 45*i);
				}
			}
		}

		override public function hurt(Damage:Number):void
		{
			Damage = 0;
			if(flickering)
				return;
			//FlxG.play(SndHurt);
			flicker(1.3);
			if(FlxG.score > 1000) FlxG.score -= 1000;
			if(velocity.x > 0)
				velocity.x = -maxVelocity.x;
			else
				velocity.x = maxVelocity.x;
			super.hurt(Damage);
		}

		override public function kill():void
		{
			if(!alive)
				return;
			solid = false;
			//FlxG.play(SndExplode);
			//FlxG.play(SndExplode2);
			super.kill();
			flicker(0);
			exists = true;
			visible = false;
			velocity.make();
			acceleration.make();
			FlxG.camera.shake(0.005,0.35);
			FlxG.camera.flash(0xffd8eba2,0.35);
		}
		
    }
}