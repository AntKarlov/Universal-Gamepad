package ru.antkarlov.anthill.plugins.controller.gamepads
{
	import flash.ui.GameInputDevice;
	import flash.ui.GameInputControl;
	
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	import ru.antkarlov.anthill.plugins.controller.controls.*;
	
	/**
	 * Класс реализующий взаимодействие с оригинальным геймпадом от Ouya.
	 * 
	 * <p>Внимание: Данный класс не тестировался с оригинальным котроллером от Ouya!</p>
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  05.10.2013
	 */
	public class AntGamepadOuya implements IGamepad, IGamepadOuya
	{
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		private var _device:GameInputDevice;
		
		private var _isDetached:Boolean;
		
		private var _buttonO:IGamepadButton;
		private var _buttonU:IGamepadButton;
		private var _buttonY:IGamepadButton;
		private var _buttonA:IGamepadButton;
		
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
		public function AntGamepadOuya(aDevice:GameInputDevice)
		{
			super();
			
			_device = aDevice;
			_isDetached = false;
			
			/*
				Расскоментируйте эту строку если хотите вывести информацию  
				о каждой кнопке для подключенного устройства.
			*/
			//traceDeviceProperties(aDevice);
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * Выводит информацию об указанном устройстве.
		 * 
		 * @param	aDevice	 Устройство информацию о котором необходимо вывести.
		 */
		protected function traceDeviceProperties(aDevice:GameInputDevice):void
		{
			trace("device.enabled - " + aDevice.enabled);
			trace("device.id - " + aDevice.id);
			trace("device.name - " + aDevice.name);
			trace("device.numControls - " + aDevice.numControls);
			trace("device.sampleInterval - " + aDevice.sampleInterval);
			trace("device.MAX_BUFFER - " + GameInputDevice.MAX_BUFFER_SIZE);
		}
		
		/**
		 * Выводит информацию об указанном контроле.
		 * 
		 * @param	aControl	 Контрол информацию о котором необходимо вывести.
		 */
		protected function traceControlProperties(aControl:GameInputControl):void
		{
			trace("control.device - " + aControl.device);
			trace("control.name - " + aControl.name);
			trace("control.minValue - " + aControl.minValue);
			trace("control.maxValue - " + aControl.maxValue);
			trace("control.id - " + aControl.id);
		}
		
		//---------------------------------------
		// IGamepad Implementation
		//---------------------------------------

		//import ru.antkarlov.anthill.plugins.controller.interface.IGamepad;
		
		/**
		 * Определяет активен геймпад или нет.
		 */
		public function get enabled():Boolean { return device.enabled; }
		public function set enabled(aValue:Boolean):void
		{
			device.enabled = aValue;
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
		 */
		public function get device():*
		{
			return _device;
		}
		
		/**
		 * Инициализация контролов геймпада.
		 */
		public function bindControls():void
		{
			var map:Object = {};
			var control:GameInputControl;
			for (var i:int = 0; i < device.numControls; i++)
			{
				control = device.getControlAt(i);
				map[control.name] = control;
				
				/*
					Расскоментируйте эту строку если хотите вывести информацию  
					о каждой кнопке для подключенного устройства.
				*/
				//traceControlProperties(control);
			}
			
			// Например: прыжок.
			_buttonO = new AntGamepadButton(this, map["buttonO"]);
			
			// Например: действие.
			_buttonU = new AntGamepadButton(this, map["buttonU"]);
			
			// Например: карта или подсказки.
			_buttonY = new AntGamepadButton(this, map["buttonY"]);
			
			// Например: отмена действия.
			_buttonA = new AntGamepadButton(this, map["buttonA"]);
			
			// Например: предыдущая вещь в инвентаре / оружие.
			_leftShoulder = new AntGamepadButton(this, map["leftShoulder"]);
			
			// Например: следующая вещь в инвентаре / оружие.
			_rightShoulder = new AntGamepadButton(this, map["rightShoulder"]);
			
			// Например: перезарядка оружия.
			_leftTrigger = new AntGamepadTrigger(this, map["leftTrigger"]);
			
			// Например: стрельба из оружия.
			_rightTrigger = new AntGamepadTrigger(this, map["rightTrigger"]);
			
			// Например: движение героя и приседание по нажатию и удержанию стика.
			_leftStick = new AntGamepadStick(this, map["stickLeftX"], map["stickLeftY"], map["stickLeftButton"]);
			
			// Например: наведение прицела и снайперский прицел по нажатию и удержанию стика.
			_rightStick = new AntGamepadStick(this, map["stickRightX"], map["stickRightY"], map["stickRightButton"]);
			
			// Например: выбор чего-либо в меню или инвентаре.
			_dpad = new AntGamepadDPad(this, map["dpadUp"], map["dpadDown"], map["dpadLeft"], map["dpadRight"]);
			
			// Например: выход в меню.
			_buttonBack = new AntGamepadButton(this, map["buttonBack"]);
			
			// Например: активация чего-либо.
			_buttonStart = new AntGamepadButton(this, map["buttonStart"]);
		}
		
		/**
		 * Вызывается при отключении геймпада.
		 */
		public function detach():void
		{
			_isDetached = true;
		}
		
		/**
		 * Осовобождает все ресурсы используемые геймпадом.
		 */
		public function destroy():void
		{
			_buttonO.destroy();
			_buttonU.destroy();
			_buttonY.destroy();
			_buttonA.destroy();
			
			_leftShoulder.destroy();
			_rightShoulder.destroy();
			
			_leftTrigger.destroy();
			_rightTrigger.destroy();
			
			_leftStick.destroy();
			_rightStick.destroy();
			
			_dpad.destroy();
			
			_buttonBack.destroy();
			_buttonStart.destroy();
			
			_buttonO = null;
			_buttonU = null;
			_buttonY = null;
			_buttonA = null;
			
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
			_buttonO.reset();
			_buttonU.reset();
			_buttonY.reset();
			_buttonA.reset();
			
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
		public function get buttonO():IGamepadButton 
		{
			return _buttonO;
		}
		
		/**
		 * Возвращает указатель на кнопку "B".
		 */
		public function get buttonU():IGamepadButton 
		{ 
			return _buttonU;
		}
		
		/**
		 * Возвращает указатель на кнопку "X".
		 */
		public function get buttonY():IGamepadButton
		{
			return _buttonY;
		}
		
		/**
		 * Возвращает указатель на кнопку "Y".
		 */
		public function get buttonA():IGamepadButton
		{
			return _buttonA;
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

	}

}