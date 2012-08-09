package 
{
    import org.flixel.*;
    /**
     * Player-controlled entity
     * @author Ryan Hamlet
     */
    public class Player extends Entity
    {
        /**
         * Constructor
         * @param   X   X location of the entity
         * @param   Y   Y location of the entity
         */
        public function Player(X:Number=100, Y:Number=100, W:Number=32, H:Number=16):void {
            super(X, Y, W, H);
			//loadGraphic(
				//Assets.SHIP_SPRITE, // image to use
				//true, // animated
				//false, // don't generate "flipped" images since they're already in the image
				//TopDownEntity.SIZE.x, // width of each frame (in pixels)
				//TopDownEntity.SIZE.y // height of each frame (in pixels)
			//);
        }
		
		/**
		* Check for user input to control this entity
		*/
		override protected function updateControls():void {
			super.updateControls();
			// check keys
			// NOTE: this accounts for someone pressing multiple arrow keys at the same time (even in opposite directions)
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
		}
    }
}