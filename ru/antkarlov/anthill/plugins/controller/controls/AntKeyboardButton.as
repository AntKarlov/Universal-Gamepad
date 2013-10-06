package ru.antkarlov.anthill.plugins.controller.controls
{
	
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	import ru.antkarlov.anthill.plugins.controller.AntGamepadManager;
	
	/**
	 * Реализация обычной кнопки для фейкового геймпада.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  05.10.2013
	 */
	public class AntKeyboardButton extends AntKeyboardControl implements IGamepadButton
	{

		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function AntKeyboardButton(aGamepad:IGamepad, aControlName:String)
		{
			super(aGamepad, aControlName);
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
			return _keys.isPressed(_controlName);
		}
		
		/**
		 * Определяет удерживается ли кнопка. Возвращает true постоянно пока кнопка нажата.
		 */
		public function get isDown():Boolean
		{
			return _keys.isDown(_controlName);
		}
		
		/**
		 * Определяет отпущена ли кнопка. Возвращает true только однажды в момент отпускания кнопки.
		 */
		public function get isReleased():Boolean
		{
			return _keys.isReleased(_controlName);
		}

	}

}