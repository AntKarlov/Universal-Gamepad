package ru.antkarlov.anthill.plugins.controller.controls
{
	import flash.ui.GameInputControl;
	import flash.events.Event;
	
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	import ru.antkarlov.anthill.plugins.controller.AntGamepadManager;
	
	/**
	 * Базовый класс для всех типов кнопок геймпада.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  05.10.2013
	 */
	public class AntGamepadControl
	{
		//---------------------------------------
		// PROTECTED VARIABLES
		//---------------------------------------
		
		/**
		 * Значение кнопки.
		 * @default    0
		 */
		protected var _value:Number;
		
		/**
		 * Время обновление кнопки.
		 * @default    0
		 */
		protected var _updateTime:uint;
		
		/**
		 * Указатель на геймпад обладающий данной кнопкой.
		 */
		protected var _gamepad:IGamepad;
		
		/**
		 * Указатель на оригинальны класс контрола.
		 */
		protected var _control:GameInputControl;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function AntGamepadControl(aGamepad:IGamepad, aControl:GameInputControl)
		{
			super();
			
			_gamepad = aGamepad;
			_control = aControl;
			
			_value = 0;
			_updateTime = 0;
			
			if (_control != null)
			{
				_control.addEventListener(Event.CHANGE, changeHandler);
			}
		}
		
		/**
		 * Освобождает ресурсы используемые контролом.
		 */
		public function destroy():void
		{
			if (_control != null)
			{
				_control.removeEventListener(Event.CHANGE, changeHandler);
				_gamepad = null;
				_control = null;
			}
		}
		
		/**
		 * Сбрасывает состояние контрола.
		 */
		public function reset():void
		{
			_value = 0;
			_updateTime = 0;
		}
		
		/**
		 * Немедленное обновления значения контрола.
		 */
		public function update():void
		{
			_value = _control.value;
		}
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * Возвращает текущее значение контрола.
		 */
		public function get value():Number
		{
			return _value;
		}
		
		/**
		 * Определяет имя контрола.
		 */
		public function get controlName():String { return _control.name; }
		public function set controlName(aValue:String):void
		{
			throw new Error("Can't assign the name for control \"" + _control.name + "\"");
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * Обработчик изменения значений для кнопки.
		 */
		protected function changeHandler(event:Event):void
		{
			_value = (event.target as GameInputControl).value;
			_updateTime = AntGamepadManager.currentTime;
		}

	}

}