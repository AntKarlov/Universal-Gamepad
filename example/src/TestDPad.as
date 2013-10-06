package
{
	import ru.antkarlov.anthill.AntActor;
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	
	public class TestDPad extends AntActor
	{
		public var control:IGamepadDPad;
		
		private var _up:AntActor;
		private var _down:AntActor;
		private var _left:AntActor;
		private var _right:AntActor;
		
		/**
		 * @constructor
		 */
		public function TestDPad()
		{
			super();
			
			// Добавляем фон.
			addAnimationFromCache("Joystick_mc");
			
			// Создаем актеры которые будут отображать нажатые кнопки.
			_up = makeActor("DPadUp_mc", 0, -25);
			_down = makeActor("DPadDown_mc", 0, 25);
			_left = makeActor("DPadLeft_mc", -25, 0);
			_right = makeActor("DPadRight_mc", 25, 0);
		}
		
		/**
		 * Метод помошник для быстрого создания актеров.
		 */
		private function makeActor(aAnimName:String, aX:int, aY:int):AntActor
		{
			var actor:AntActor = new AntActor();
			actor.addAnimationFromCache(aAnimName);
			actor.x = aX;
			actor.y = aY;
			actor.visible = false;
			add(actor);
			return actor;
		}
		
		override public function update():void
		{
			if (control != null)
			{
				// Актер отображающий конкретную кнопку будет виден все время пока
				// соотвествующая кнопка удерживается на геймпаде.
				_up.visible = control.up.isDown;
				_down.visible = control.down.isDown;
				_left.visible = control.left.isDown;
				_right.visible = control.right.isDown;
			}
			
			super.update();
		}

	}

}