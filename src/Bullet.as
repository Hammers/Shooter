package
{
	import org.flixel.*;
	/**
     * Bullet
     * @author Ryan Hamlet
     */
	public class Bullet extends FlxSprite
	{
		public var speed:Number;

		public function Bullet()
		{
			super();
			//loadGraphic(ImgBullet,true);
			makeGraphic(2, 2, 0xFF999900); // use this if you want a generic box graphic by default
			width = 2;
			height = 2;
			offset.x = 1;
			offset.y = 1;

			//addAnimation("up",[0]);
			//addAnimation("down",[1]);
			//addAnimation("left",[2]);
			//addAnimation("right",[3]);
			//addAnimation("poof",[4, 5, 6, 7], 50, false);

			speed = 360;
		}

		override public function update():void
		{
			if(touching || !onScreen())
				kill();
		}

		override public function kill():void
		{
			if(!alive)
				return;
			velocity.x = 0;
			velocity.y = 0;
			//if(onScreen())
				//FlxG.play(SndHit);
			alive = false;
			solid = false;
			exists = false;
			//play("poof");
		}
		
		public function shoot(Location:FlxPoint, Angle:Number):void
		{
			//FlxG.play(SndShoot,0.5);
			super.reset(Location.x-width/2,Location.y-height/2);
			FlxU.rotatePoint(0,speed,0,0,Angle,_point);
			velocity.x = _point.x;
			velocity.y = _point.y;
			solid = true;
			//play("idle");
		}
	}
}