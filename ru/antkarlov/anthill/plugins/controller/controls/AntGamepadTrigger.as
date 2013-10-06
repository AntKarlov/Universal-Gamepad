package ru.antkarlov.anthill.plugins.controller.controls
{
	import flash.ui.GameInputControl;
	
	import ru.antkarlov.anthill.AntMath;
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	
	/**
	 * Реализация курка для геймпада.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  05.10.2013
	 */
	public class AntGamepadTrigger extends AntGamepadButton implements IGamepadTrigger
	{
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
		private var _lerpFactor:Number;
		private var _lerpPercent:Number;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function AntGamepadTrigger(aGamepad:IGamepad, aControl:GameInputControl)
		{
			super(aGamepad, aControl);
			_lerpFactor = 0.5;
			reset();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void
		{
			super.reset();
			_value = _control.minValue;
			_lerpPercent = 0;
		}
		
		//---------------------------------------
		// IGamepadTrigger Implementation
		//---------------------------------------

		//import ru.antkarlov.anthill.plugins.controller.interface.IGamepadTrigger;
		
		/**
		 * Определяет фактор интерполяции.
		 */
		public function get lerpFactor():Number { return _lerpFactor; }
		public function set lerpFactor(aValue:Number):void
		{
			_lerpFactor = (aValue < 0) ? 0 : (aValue > 1) ? 1 : aValue;
		}
		
		/**
		 * Возвращает силу нажатия курка в процентах от 0 до 1.
		 */
		public function get percent():Number
		{
			return AntMath.remap(_value, _control.minValue, _control.maxValue, 0, 1);
		}
		
		/**
		 * Возвращает интерполированную силу нажатия курка в процентах от 0 до 1.
		 */
		public function get lerpPercent():Number
		{
			_lerpPercent = _lerpPercent + lerpFactor * (percent - _lerpPercent);
			return _lerpPercent;
		}
		
	}

}