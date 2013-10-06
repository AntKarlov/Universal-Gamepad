package ru.antkarlov.anthill.plugins.controller.controls
{
	import flash.ui.GameInputControl;
	
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	
	/**
	 * Реализация аналогового стика для геймпада.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  05.10.2013
	 */
	public class AntGamepadStick extends AntGamepadButton implements IGamepadStick
	{
		//---------------------------------------
		// CLASS CONSTANTS
		//---------------------------------------
		
		/**
		 * Задает значение чувствительности.
		 */
		private static const STICK_THRESHOLD:Number = 0.5;
		
		//---------------------------------------
		// PROTECTED VARIABLES
		//---------------------------------------
		protected var _lerpFactor:Number;
		
		protected var _up:AntGamepadButton;
		protected var _down:AntGamepadButton;
		protected var _left:AntGamepadButton;
		protected var _right:AntGamepadButton;
		
		protected var _axisX:AntGamepadControl;
		protected var _axisY:AntGamepadControl;
		
		protected var _reverseY:Boolean;
		protected var _reverseX:Boolean;
		
		protected var _lerpX:Number;
		protected var _lerpY:Number;
		protected var _lerpAngle:Number;
		protected var _lerpDist:Number;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function AntGamepadStick(aGamepad:IGamepad, aAxisX:GameInputControl, aAxisY:GameInputControl, 
			aStickButton:GameInputControl)
		{
			super(aGamepad, aStickButton);
			
			_axisX = new AntGamepadControl(aGamepad, aAxisX);
			_axisY = new AntGamepadControl(aGamepad, aAxisY);
			
			_reverseY = false;
			_reverseX = false;
			
			_lerpX = 0;
			_lerpY = 0;
			_lerpAngle = 0;
			_lerpDist = 0;
			
			_left = new AntGamepadButton(aGamepad, aAxisX, -1, -STICK_THRESHOLD);
			_right = new AntGamepadButton(aGamepad, aAxisX, STICK_THRESHOLD, 1);
			_down = new AntGamepadButton(aGamepad, aAxisY, -1, -STICK_THRESHOLD);
			_up = new AntGamepadButton(aGamepad, aAxisY, STICK_THRESHOLD, 1);
			
			_lerpFactor = 0.5;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			_axisX.destroy();
			_axisY.destroy();
			
			_left.destroy();
			_right.destroy();
			_down.destroy();
			_up.destroy();
			
			_axisX = null;
			_axisY = null;
			
			_left = null;
			_right = null;
			_down = null;
			_up = null;
			
			super.destroy();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void
		{
			super.reset();
			
			_axisX.reset();
			_axisY.reset();
			
			_left.reset();
			_right.reset();
			_down.reset();
			_up.reset();
		}
		
		//---------------------------------------
		// IGamepadStick Implementation
		//---------------------------------------

		//import ru.antkarlov.anthill.plugins.controller.interfaces.IGamepadStick;
		
		/**
		 * Определяет коэфицент интерполяции значений.
		 * @default    0.5
		 */
		public function get lerpFactor():Number { return _lerpFactor; }
		public function set lerpFactor(aValue:Number):void
		{
			_lerpFactor = aValue;
		}
		
		/**
		 * Возвращает указатель на кнопку вверх.
		 */
		public function get up():IGamepadButton
		{
			return _up;
		}
		
		/**
		 * Возвращает указатель на кнопку вниз.
		 */
		public function get down():IGamepadButton 
		{ 
			return _down;
		}
		
		/**
		 * Возвращает указатель на кнопку влево.
		 */
		public function get left():IGamepadButton
		{
			return _left;
		}

		/**
		 * Возвращает указатель на кнопку вправо.
		 */
		public function get right():IGamepadButton
		{ 
			return _right;
		}

		/**
		 * Определяет инвертирование оси по вертикали.
		 */
		public function get reverseY():Boolean { return _reverseY; }
		public function set reverseY(aValue:Boolean):void
		{
			if (_reverseY != aValue)
			{
				_reverseY = aValue;
				if (_reverseY)
				{
					_down.setMinMax(STICK_THRESHOLD, 1);
					_up.setMinMax(-1, -STICK_THRESHOLD);
				}
				else
				{
					_up.setMinMax(STICK_THRESHOLD, 1);
					_down.setMinMax(-1, -STICK_THRESHOLD);
				}
			}
		}
		
		/**
		 * Определяет инвертирование щси по горизонтали.
		 */
		public function get reverseX():Boolean { return _reverseX; }
		public function set reverseX(aValue:Boolean):void
		{
			if (_reverseX != aValue)
			{
				_reverseX = aValue;
				if (_reverseX)
				{
					_left.setMinMax(STICK_THRESHOLD, 1);
					_right.setMinMax(-1, -STICK_THRESHOLD);
				}
				else
				{
					_right.setMinMax(STICK_THRESHOLD, 1);
					_left.setMinMax(-1, -STICK_THRESHOLD);
				}
			}
		}
		
		/**
		 * Возвращает значение горизонтальной оси.
		 */
		public function get axisX():Number 
		{
			return (reverseX) ? -_axisX.value : _axisX.value;
		}
		
		/**
		 * Возвращает значение вертикальной оси.
		 */
		public function get axisY():Number
		{
			return (reverseY) ? -_axisY.value : _axisY.value;
		}
		
		/**
		 * Возвращает интерполированное значение горизонтальной оси.
		 */
		public function get lerpAxisX():Number
		{
			_lerpX = _lerpX + lerpFactor * (_axisX.value - _lerpX);
			return (reverseX) ? -_lerpX : _lerpX;
		}
		
		/**
		 * Возвращает интерполированное значение вертикальной оси.
		 */
		public function get lerpAxisY():Number
		{
			_lerpY = _lerpY + lerpFactor * (_axisY.value - _lerpY);
			return (reverseY) ? -_lerpY : _lerpY;
		}
		
		/**
		 * Возвращает значение угола наклона стика в радианах.
		 */
		public function get angle():Number
		{
			return Math.atan2(_axisY.value, _axisX.value);
		}
		
		/**
		 * Возвращает интерполированное значение угла наклона стика.
		 */
		public function get lerpAngle():Number
		{
			_lerpAngle = _lerpAngle + lerpFactor * (angle - _lerpAngle);
			return _lerpAngle;
		}
		
		/**
		 * Возвращает значение смещения стика.
		 */
		public function get distance():Number
		{
			return Math.min(1, Math.sqrt(_axisX.value * _axisX.value + _axisY.value * _axisY.value));
		}
		
		/**
		 * Возвращает интерполированное значение смещения стика.
		 */
		public function get lerpDistance():Number
		{
			_lerpDist = _lerpDist + lerpFactor * (distance - _lerpDist);
			return _lerpDist;
		}

	}
	
}