package ru.antkarlov.anthill.plugins.controller.controls
{
	import flash.ui.GameInputControl;
	
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	
	/**
	 * Реализация аналогового стика для фейкового геймпада.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  05.10.2013
	 */
	public class AntKeyboardStick extends AntKeyboardButton implements IGamepadStick
	{		
		//---------------------------------------
		// PROTECTED VARIABLES
		//---------------------------------------
		protected var _lerpFactor:Number;
		
		protected var _up:AntKeyboardButton;
		protected var _down:AntKeyboardButton;
		protected var _left:AntKeyboardButton;
		protected var _right:AntKeyboardButton;
		
		protected var _reverseY:Boolean;
		protected var _reverseX:Boolean;
		
		protected var _x:Number;
		protected var _y:Number;
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
		public function AntKeyboardStick(aGamepad:IGamepad, aControlNameUp:String, aControlNameDown:String, 
			aControlNameLeft:String, aControlNameRight:String, aStickButton:String)
		{
			super(aGamepad, aStickButton);
			
			_up = new AntKeyboardButton(aGamepad, aControlNameUp);
			_down = new AntKeyboardButton(aGamepad, aControlNameDown);
			_left = new AntKeyboardButton(aGamepad, aControlNameLeft);
			_right = new AntKeyboardButton(aGamepad, aControlNameRight);
			
			_reverseY = false;
			_reverseX = false;
			
			_x = 0;
			_y = 0;
			_lerpX = 0;
			_lerpY = 0;
			_lerpAngle = 0;
			_lerpDist = 0;
			
			_lerpFactor = 0.5;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{		
			_left.destroy();
			_right.destroy();
			_down.destroy();
			_up.destroy();
			
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

			_left.reset();
			_right.reset();
			_down.reset();
			_up.reset();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update():void
		{
			super.update();
			
			_left.update();
			_right.update();
			_down.update();
			_up.update();
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
			_reverseY = aValue;
		}
		
		/**
		 * Определяет инвертирование щси по горизонтали.
		 */
		public function get reverseX():Boolean { return _reverseX; }
		public function set reverseX(aValue:Boolean):void
		{
			_reverseX = aValue;
		}
		
		/**
		 * Возвращает значение горизонтальной оси.
		 */
		public function get axisX():Number 
		{
			_x = 0;
			if (_left.isDown)
			{
				_x = (_up.isDown || _down.isDown) ? _left.value * 0.7 : _left.value;
				_x = (reverseX) ? _x : -_x;
			}
			else if (_right.isDown)
			{
				_x = (_up.isDown || _down.isDown) ? _right.value * 0.7 : _right.value;
				_x = (reverseX) ? -_x : _x;
			}
			
			return _x;
		}
		
		/**
		 * Возвращает значение вертикальной оси.
		 */
		public function get axisY():Number
		{
			_y = 0;
			if (_up.isDown)
			{
				_y = (_left.isDown || _right.isDown) ? _up.value * 0.7 : _up.value;
				_y = (reverseY) ? _y : -_y;
			}
			else if (_down.isDown)
			{
				_y = (_left.isDown || _right.isDown) ? _down.value * 0.7 : _down.value;
				_y = (reverseY) ? -_y : _y;
			}
			
			return _y;
		}
		
		/**
		 * Возвращает интерполированное значение горизонтальной оси.
		 */
		public function get lerpAxisX():Number
		{
			_lerpX = _lerpX + lerpFactor * (axisX - _lerpX);
			return _lerpX;
		}
		
		/**
		 * Возвращает интерполированное значение вертикальной оси.
		 */
		public function get lerpAxisY():Number
		{
			_lerpY = _lerpY + lerpFactor * (axisY - _lerpY);
			return _lerpY;
		}
		
		/**
		 * Возвращает значение угола наклона стика в радианах.
		 */
		public function get angle():Number
		{
			return Math.atan2(axisY, axisX);
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
			return Math.min(1, Math.sqrt(axisX * axisX + axisY * axisY));
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