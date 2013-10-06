package
{
	import ru.antkarlov.anthill.AntActor;
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	
	public class TestButton extends AntActor
	{
		
		public var control:IGamepadButton;
		
		/**
		 * @constructor
		 */
		public function TestButton()
		{
			super();
		}
		
		override public function update():void
		{
			if (control != null)
			{
				// Если кнопка нажата.
				if (control.isPressed)
				{
					gotoAndStop(2);
				}
				// Иначе если кнопка отпущена.
				else if (control.isReleased)
				{
					gotoAndStop(1);
				}
			}
			
			super.update();
		}

	}

}