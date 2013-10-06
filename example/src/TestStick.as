package
{
	import ru.antkarlov.anthill.AntG;
	import ru.antkarlov.anthill.AntActor;
	import ru.antkarlov.anthill.plugins.controller.interfaces.IGamepadStick;
	
	public class TestStick extends AntActor
	{
		public var control:IGamepadStick;
		private var _roller:AntActor;
		
		/**
		 * @constructor
		 */
		public function TestStick()
		{
			super();
			
			// Добавляем фон.
			addAnimationFromCache("Joystick_mc");
			
			// Создаем бегунок.
			_roller = new AntActor();
			_roller.addAnimationFromCache("StickPoint_mc");
			add(_roller);
		}
		
		override public function update():void
		{
			if (control != null)
			{
				// Присваиваем бегунку текущее положение по осям.
				//_roller.x = _control.axisX * 38;
				//_roller.y = _control.axisY * 38;

				// Присваиваем бегунку интерполированное положение по осям.
				_roller.x = control.lerpAxisX * 38;
				_roller.y = control.lerpAxisY * 38;
				
				AntG.watchValue("axisX", control.lerpAxisX);
				AntG.watchValue("axisY", control.lerpAxisY);

				// Если стик нажат, инвертируем оси по вертикали.
				if (control.isPressed)
				{
					gotoAndStop(2);
					//_control.reverseX = !_control.reverseX;
					control.reverseY = !control.reverseY;
				}
				else if (control.isReleased)
				{
					gotoAndStop(1);
				}
			}
			
			super.update();
		}

	}

}