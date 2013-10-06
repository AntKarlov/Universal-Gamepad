package ru.antkarlov.anthill.plugins.controller.gamepads
{
	import ru.antkarlov.anthill.AntG;
	import ru.antkarlov.anthill.AntCamera;
	import ru.antkarlov.anthill.plugins.IPlugin;
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	import ru.antkarlov.anthill.plugins.controller.controls.*;
	
	/**
	 * Данный класс реализует эмуляцию геймпада на клавиатуре. То есть если нет оригинальных
	 * подключенных к компьютеру геймпадов, то можно использовать данный класс как замену, 
	 * при этом функционал остаентся без изменений.
	 * 
	 * <p>Пример использования:</p>
	 * 
	 * <listing>
	 * // Если нет подключенных геймпадов.
	 * if (!gamepadManager.hasReadyGamepad())
	 * {
	 *   _gamepad = new AntKeyboardXBox360();
	 *   _gamepad.enable = true;
	 * }
	 * </listing>
	 * 
	 * <p>Последующее использование геймпада ничем не отличается от оригинального:</p>
	 * 
	 * <listing>
	 * if (_gamepad.leftStick.left.isDown)
	 * {
	 *   // Двигаемся влево.
	 * }
	 * 
	 * x += _gamepad.leftStick.lerpAxisX;
	 * </listing>
	 * 
	 * <p>Так же вы можете задать произвольные клавиши клавиатуры для определенных контролов:</p>
	 * 
	 * <listing>
	 * _gamepad.buttonA.controlName = "SPACEBAR"; // Кнопка A будет активироваться при нажатии пробела.
	 * _gamepad.buttonB.controlName = "S"; // Кнопка B будет активироваться при нажатии кнопки "S".
	 * _gamepad.leftStick.right.controlName = "RIGHT"; // Левый джойстик будет реагировать вправо при нажатии стрелки вправо.
	 * </listing>
	 * 
	 * <p>При настройки произвольных клавиш клавиатуры следует задавать текстовые имена 
	 * кнопок которые соотвествуют идентификаторам клавиш в AntKeyboard.</p>
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  05.10.2013
	 */
	public class AntKeyboardXBox360 implements IPlugin, IGamepad, IGamepadXBox360
	{
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
		private var _tag:String;
		private var _priority:Number;
		
		private var _enabled:Boolean;
		private var _isDetached:Boolean;
		
		private var _buttonY:IGamepadButton;
		private var _buttonB:IGamepadButton;
		private var _buttonA:IGamepadButton;
		private var _buttonX:IGamepadButton;
		
		private var _leftShoulder:IGamepadButton;
		private var _rightShoulder:IGamepadButton;
		
		private var _leftTrigger:IGamepadTrigger;
		private var _rightTrigger:IGamepadTrigger;
		
		private var _leftStick:IGamepadStick;
		private var _rightStick:IGamepadStick;
		
		private var _dpad:IGamepadDPad;
		
		private var _buttonBack:IGamepadButton;
		private var _buttonStart:IGamepadButton;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function AntKeyboardXBox360()
		{
			super();
			
			_isDetached = false;
			_enabled = false;
			
			// Инициализация кнопок
			bindControls();
		}
		
		//---------------------------------------
		// IGamepad Implementation
		//---------------------------------------

		//import ru.antkarlov.anthill.plugins.controller.interface.IGamepad;
		
		/**
		 * Определяет активен геймпад или нет.
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(aValue:Boolean):void
		{
			if (_isDetached)
			{
				return;
			}
			
			if (_enabled != aValue)
			{
				_enabled = aValue;
				if (_enabled)
				{
					AntG.plugins.add(this);
				}
				else
				{
					AntG.plugins.remove(this);
				}
			}
		}
		
		/**
		 * Определяет был ли отключен геймпад.
		 */
		public function get isDetached():Boolean
		{
			return _isDetached;
		}
		
		/**
		 * Возвращает указатель на оригинальное устройство.
		 * 
		 * Примечание: Для фэйкового геймпада реального устройства не существует.
		 */
		public function get device():*
		{
			return null;
		}
		
		/**
		 * Инициализация контролов геймпада.
		 */
		public function bindControls():void
		{
			// Например: прыжок.
			_buttonA = new AntKeyboardButton(this, "SPACEBAR");
			
			// Например: отмена действия.
			_buttonB = new AntKeyboardButton(this, "Q");
			
			// Например: действие.
			_buttonX = new AntKeyboardButton(this, "E");
			
			// Например: карта или подсказки.
			_buttonY = new AntKeyboardButton(this, "I");
			
			// Например: предыдущая вещь в инвентаре / оружие.
			_leftShoulder = new AntKeyboardButton(this, "ONE");
			
			// Например: следующая вещь в инвентаре / оружие.
			_rightShoulder = new AntKeyboardButton(this, "TWO");
			
			// Например: перезарядка оружия.
			_leftTrigger = new AntKeyboardTrigger(this, "R");
			
			// Например: стрельба из оружия.
			_rightTrigger = new AntKeyboardTrigger(this, "F");
			
			// Например: движение героя - WASD и пресесть - SHIFT.
			_leftStick = new AntKeyboardStick(this, "W", "S", "A", "D", "SHIFT");
			
			// Например: наведение прицела - UP, LEFT, DOWN, RIGHT и снайперский прицел - NUMPAD_0.
			_rightStick = new AntKeyboardStick(this, "UP", "DOWN", "LEFT", "RIGHT", "NUMPAD_0");
			
			// Например: выбор чего-либо в меню или инвентаре.
			_dpad = new AntKeyboardDPad(this, "NUMPAD_8", "NUMPAD_5", "NUMPAD_4", "NUMPAD_6");
			
			// Например: выход в меню.
			_buttonBack = new AntKeyboardButton(this, "ESC");
			
			// Например: активация чего-либо.
			_buttonStart = new AntKeyboardButton(this, "ENTER");
		}
		
		/**
		 * Вызывается при отключении геймпада.
		 */
		public function detach():void
		{
			_isDetached = true;
			
			if (_enabled)
			{
				AntG.plugins.remove(this);
				_enabled = false;
			}
		}
		
		/**
		 * Осовобождает все ресурсы используемые геймпадом.
		 */
		public function destroy():void
		{
			detach();
			
			_buttonA.destroy();
			_buttonB.destroy();
			_buttonX.destroy();
			_buttonY.destroy();
			
			_leftShoulder.destroy();
			_rightShoulder.destroy();
			
			_leftTrigger.destroy();
			_rightTrigger.destroy();
			
			_leftStick.destroy();
			_rightStick.destroy();
			
			_dpad.destroy();
			
			_buttonBack.destroy();
			_buttonStart.destroy();
			
			_buttonA = null;
			_buttonB = null;
			_buttonX = null;
			_buttonY = null;
			
			_leftShoulder = null;
			_rightShoulder = null;
			
			_leftTrigger = null;
			_rightTrigger = null;
			
			_leftStick = null;
			_rightStick = null;
			
			_dpad = null;
			
			_buttonBack = null;
			_buttonStart = null;
		}
		
		/**
		 * Сбрасывает состояние всех контролов геймпада в состояние по умолчанию.
		 */
		public function reset():void
		{
			_buttonA.reset();
			_buttonB.reset();
			_buttonX.reset();
			_buttonY.reset();
			
			_leftShoulder.reset();
			_rightShoulder.reset();
			
			_leftTrigger.reset();
			_rightTrigger.reset();
			
			_leftStick.reset();
			_rightStick.reset();
			
			_dpad.reset();
			
			_buttonBack.reset();
			_buttonStart.reset();
		}
		
		//---------------------------------------
		// IGamepadXBox360 Implementation
		//---------------------------------------

		//import ru.antkarlov.anthill.plugins.controller.interface.IGamepadXBox360;
		
		/**
		 * Возвращает указатель на кнопку "A".
		 */
		public function get buttonA():IGamepadButton 
		{
			return _buttonA;
		}
		
		/**
		 * Возвращает указатель на кнопку "B".
		 */
		public function get buttonB():IGamepadButton 
		{ 
			return _buttonB;
		}
		
		/**
		 * Возвращает указатель на кнопку "X".
		 */
		public function get buttonX():IGamepadButton
		{
			return _buttonX;
		}
		
		/**
		 * Возвращает указатель на кнопку "Y".
		 */
		public function get buttonY():IGamepadButton
		{
			return _buttonY;
		}
		
		/**
		 * Возвращает указатель на левую торцевую кнопку.
		 */
		public function get leftShoulder():IGamepadButton
		{
			return _leftShoulder;
		}
		
		/**
		 * Возвращает указатель на правую торцевую кнопку.
		 */
		public function get rightShoulder():IGamepadButton
		{
			return _rightShoulder;
		}
		
		/**
		 * Возвращет указатель на левый торцевой курок.
		 */
		public function get leftTrigger():IGamepadTrigger 
		{
			return _leftTrigger;
		}

		/**
		 * Возвращает указатель на правый торцевой курок.
		 */
		public function get rightTrigger():IGamepadTrigger 
		{ 
			return _rightTrigger;
		}
		
		/**
		 * Возвращает указатель на левый аналоговый стик.
		 */
		public function get leftStick():IGamepadStick
		{
			return _leftStick;
		}
		
		/**
		 * Возвращает указатель на правый аналоговый стик.
		 */
		public function get rightStick():IGamepadStick
		{
			return _rightStick;
		}
		
		/**
		 * Возвращает указатель на кнопочный джойстик.
		 */
		public function get dpad():IGamepadDPad
		{
			return _dpad;
		}
		
		/**
		 * Возвращает указатель на кнопку назад.
		 */
		public function get buttonBack():IGamepadButton
		{
			return _buttonBack;
		}
		
		/**
		 * Возвращает указатель на кнопку старт.
		 */
		public function get buttonStart():IGamepadButton
		{
			return _buttonStart;
		}
		
		//---------------------------------------
		// IPlugin Implementation
		//---------------------------------------

		//import ru.antkarlov.anthill.plugins.IPlugin;
		
		/**
		 * Определяет тэг плагина.
		 */
		public function get tag():String { return _tag; }
		public function set tag(aValue:String):void
		{
			_tag = aValue;
		}
		
		/**
		 * Определяет приоритет плагина.
		 */
		public function get priority():int { return _priority; }
		public function set priority(aValue:int):void
		{
			_priority = aValue;
		}
		
		/**
		 * Обновление состояния плагина.
		 */
		public function update():void
		{
			_buttonA.update();
			_buttonB.update();
			_buttonX.update();
			_buttonY.update();
			
			_leftShoulder.update();
			_rightShoulder.update();
			
			_leftTrigger.update();
			_rightTrigger.update();
			
			_leftStick.update();
			_rightStick.update();
			
			_dpad.update();
			
			_buttonBack.update();
			_buttonStart.update();
		}
		
		/**
		 * Отрисовка плагина.
		 */
		public function draw(aCamera:AntCamera):void
		{
			// ..
		}

	}

}