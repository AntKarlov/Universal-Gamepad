package
{
	import ru.antkarlov.anthill.*;
	import ru.antkarlov.anthill.plugins.controller.interfaces.IGamepadTrigger;
	
	public class TestTrigger extends AntActor
	{
		public var control:IGamepadTrigger;
		
		/**
		 * @constructor
		 */
		public function TestTrigger()
		{
			super();
			
			// Добавляем анимацию триггера.
			addAnimationFromCache("Trigger_mc");
		}
		
		override public function update():void
		{
			if (control != null)
			{
				// Меняем кадр текущей анимации согласно глубине нажатия курка.
				gotoAndStop(AntMath.fromPercent(control.lerpPercent * 100 + 1, totalFrames));
			}
			
			super.update();
		}
		
	}

}