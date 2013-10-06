//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2013 
// 
////////////////////////////////////////////////////////////////////////////////

package
{

	import flash.events.Event;
	import flash.display.Sprite;
	
	import ru.antkarlov.anthill.Anthill;

	/**
	 * Application entry point for AnthillGamepad.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 
	 * 9.0
	 * 
	 * @author Антон Карлов
	 * @since 03.10.2013
	 */
	[SWF(width="640", height="480", backgroundColor="#000000")]
	public class AnthillGamepad extends Sprite
	{
	
		/**
		 * @constructor
		 */
		public function AnthillGamepad()
		{
			super();
			
			var anthill:Anthill = new Anthill(GameState, 35);
			addChild(anthill);
		}
	
	}

}
