package
{
    import org.flixel.*;
 
    /**
     * A moveable object in the game (player, enemy, NPC, etc)
     * @author Ryan Hamlet
     */
    public class Entity extends FlxSprite
    {
        /**
         * Constants
         */

		public static const MAXSPEED:Number = 120;
		public var size:FlxPoint = new FlxPoint();
        /**
		* Constructor
		* @param   X   X location of the entity
		* @param   Y   Y location of the entity
		*/
		public function Entity(X:Number = 100, Y:Number = 100, W:Number = 16, H:Number = 16):void {
			super(X, Y);
			size.x = W;
			size.y = H;
			makeGraphic(W, H, 0xFFFF0000); // default to a placeholder box
			// movement
			maxVelocity = new FlxPoint(MAXSPEED, MAXSPEED);
			drag = new FlxPoint(MAXSPEED * 8, MAXSPEED * 8);
			// animations
			createAnimations();
		}
 
		/**
		* Create the animations for this entity
		*/
		protected function createAnimations():void {
			addAnimation("idle", [2, 3], 4);
			addAnimation("move_up", [0, 1], 4); 
			addAnimation("move_right", [2, 3], 4);
			addAnimation("move_down", [4,5],4);
			addAnimation("move_left", [6,7],4);
		}
 
		/**
		* Update each timestep
		*/
		public override function update():void {
			updateControls();
			updateAnimations();
			super.update();
		}
 
        /**
         * Check keyboard/mouse controls
         */
        protected function updateControls():void {
            acceleration.x = acceleration.y = 0; // no gravity or drag by default
        }
		
		/**
		* Based on current state, show the correct animation
		* FFV: use state machine if it gets more complex than this
		*/
		protected function updateAnimations():void {
			// use abs() so that we can animate for the dominant motion
			// ex: if we're moving slightly up and largely right, animate right
			var absX:Number = Math.abs(velocity.x);
			var absY:Number = Math.abs(velocity.y);
			// determine facing
			if (velocity.y < 0 && absY >= absX)
				facing = UP;
			else if (velocity.y > 0 && absY >= absX)
				facing = DOWN;
			else if (velocity.x > 0 && absX >= absY)
				facing = RIGHT;
			else if (velocity.x < 0 && absX >= absY)
				facing = LEFT
			// up
			if (facing == UP) {
				play("move_up");
			}
			// down
			else if (facing == DOWN) {
				play("move_down");
			}
			// right
			else if (facing == RIGHT) {
				play("move_right");
			}
			// left
			else if (facing == LEFT) {
				play("move_left");
			}
		}
    }
}