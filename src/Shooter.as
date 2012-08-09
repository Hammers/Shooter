package
{
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	[SWF(width="1024", height="400", backgroundColor="#000000")] //Set the size and color of the Flash file
 
	public class Shooter extends FlxGame
	{
		public function Shooter()
		{
			super(512,200,PlayState,2); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
		}
	}
}