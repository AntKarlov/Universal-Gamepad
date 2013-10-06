package ru.antkarlov.anthill.plugins.controller.controls
{
	import flash.ui.GameInputControl;
	
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	
	/**
	 * Реализация Directional Pad для геймпада.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  05.10.2013
	 */
	public class AntGamepadDPad implements IGamepadDPad
	{
		//---------------------------------------
		// PROTECTED VARIABLES
		//---------------------------------------
		protected var _up:IGamepadButton;
		protected var _down:IGamepadButton;
		protected var _left:IGamepadButton;
		protected var _right:IGamepadButton;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function AntGamepadDPad(aGamepad:IGamepad, aUp:GameInputControl, 
			aDown:GameInputControl, aLeft:GameInputControl, aRight:GameInputControl)
		{
			super();
			
			_up = new AntGamepadButton(aGamepad, aUp);
			_down = new AntGamepadButton(aGamepad, aDown);
			_left = new AntGamepadButton(aGamepad, aLeft);
			_right = new AntGamepadButton(aGamepad, aRight);
		}
		
		//---------------------------------------
		// IGamepadDPad Implementation
		//---------------------------------------

		//import ru.antkarlov.anthill.plugins.controller.interfaces.IGamepadDPad;
		
		/**
		 * Осовобождает все используемые ресурсы.
		 */
		public function destroy():void
		{
			_up.destroy();
			_down.destroy();
			_left.destroy();
			_right.destroy();
			
			_up = null;
			_down = null;
			_left = null;
			_right = null;
		}
		
		/**
		 * Сбрасывает состояние всех контролов.
		 */
		public function reset():void
		{
			_up.reset();
			_down.reset();
			_left.reset();
			_right.reset();
		}
		
		/**
		 * Немедленное обновление значений для всех контролов.
		 */
		public function update():void
		{
			_up.update();
			_down.update();
			_left.update();
			_right.update();
		}
		
		/**
		 * Возвращает указатель на кнопку "вверх".
		 */
		public function get up():IGamepadButton
		{
			return _up;
		}
		
		/**
		 * Возвращает указатель на кнопку "вниз".
		 */
		public function get down():IGamepadButton
		{
			return _down;
		}
		
		/**
		 * Возвращает указатель на кнопку "влево".
		 */
		public function get left():IGamepadButton
		{
			return _left;
		}
		
		/**
		 * Возвращает указатель на кнопку "вправо".
		 */
		public function get right():IGamepadButton
		{
			return _right;
		}

	}

}