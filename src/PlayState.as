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
        public var player:Player;
        public var playerStart:FlxPoint = new FlxPoint(160, 160);
		
        /**
         * Create state
         */
        override public function create():void {
            FlxG.mouse.show();
            createPlayer();
		}
		
		protected function createPlayer():void {
            player = new Player(playerStart.x, playerStart.y);
			add(player)
        }
		
	}

}