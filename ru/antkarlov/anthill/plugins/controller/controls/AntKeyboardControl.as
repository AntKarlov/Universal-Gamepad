package ru.antkarlov.anthill.plugins.controller.controls
{
	import ru.antkarlov.anthill.AntG;
	import ru.antkarlov.anthill.AntKeyboard;
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	
	/**
	 * Базовый класс для всех типов кнопок фейкового геймпада.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  05.10.2013
	 */
	public class AntKeyboardControl
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
		 * Указатель на геймпад обладающий данной кнопкой.
		 */
		protected var _gamepad:IGamepad;
		
		/**
		 * Имя кнопки клавиатуры используемой для контрола.
		 */
		protected var _controlName:String;
		
		/**
		 * Указатель на класс обработчик клавиатуры.
		 */
		protected var _keys:AntKeyboard;
				
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function AntKeyboardControl(aGamepad:IGamepad, aControlName:String)
		{
			super();
			
			_value = 0;
			_gamepad = aGamepad;
			_controlName = aControlName;
			_keys = AntG.keys;
		}
		
		/**
		 * Освобождает ресурсы используемые контролом.
		 */
		public function destroy():void
		{
			_gamepad = null;
		}
		
		/**
		 * Сбрасывает состояние контрола.
		 */
		public function reset():void
		{
			_value = 0;
		}
		
		/**
		 * Немедленное обновления значения контрола.
		 */
		public function update():void
		{
			_value = (_keys.isDown(_controlName)) ? 1 : 0;
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
		public function get controlName():String { return _controlName; }
		public function set controlName(aValue:String):void
		{
			_controlName = aValue;
		}

	}

}