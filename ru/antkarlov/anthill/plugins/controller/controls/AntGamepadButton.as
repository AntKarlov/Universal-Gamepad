package ru.antkarlov.anthill.plugins.controller.controls
{
	import flash.events.Event;
	import flash.ui.GameInputControl;
	
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	import ru.antkarlov.anthill.plugins.controller.AntGamepadManager;
	
	/**
	 * Реализация обычной кнопки для геймпада.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  05.10.2013
	 */
	public class AntGamepadButton extends AntGamepadControl implements IGamepadButton
	{
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
		private var _min:Number;
		private var _max:Number;
		private var _changed:Boolean;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function AntGamepadButton(aGamepad:IGamepad, aControl:GameInputControl, 
			aMin:Number = 0.5, aMax:Number = 1)
		{
			super(aGamepad, aControl);
			setMinMax(aMin, aMax);
			_changed = false;
		}
		
		/**
		 * @private
		 */
		internal function setMinMax(aMin:Number, aMax:Number):void
		{
			_min = aMin;
			_max = aMax;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function changeHandler(event:Event):void
		{
			var beforeDown:Boolean = isDown;
			super.changeHandler(event);
			_changed = (isDown != beforeDown);
		}
		
		//---------------------------------------
		// IGamepadButton Implementation
		//---------------------------------------

		//import ru.antkarlov.anthill.plugins.controller.interface.IGamepadButton;
		
		/**
		 * Определяет нажата ли кнопка. Возваращает true только однажды в момент нажатия кнопки.
		 */
		public function get isPressed():Boolean
		{
			return (_updateTime >= AntGamepadManager.currentTime && isDown && _changed);
		}
		
		/**
		 * Определяет удерживается ли кнопка. Возвращает true постоянно пока кнопка нажата.
		 */
		public function get isDown():Boolean
		{
			return (_value >= _min && _value <= _max);
		}
		
		/**
		 * Определяет отпущена ли кнопка. Возвращает true только однажды в момент отпускания кнопки.
		 */
		public function get isReleased():Boolean
		{
			return (_updateTime >= AntGamepadManager.currentTime && !isDown && _changed);
		}

	}

}