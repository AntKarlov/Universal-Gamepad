package ru.antkarlov.anthill.plugins.controller.gamepads
{
	import flash.ui.GameInputDevice;
	import flash.ui.GameInputControl;
	
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	import ru.antkarlov.anthill.plugins.controller.controls.*;
	
	/**
	 * Класс реализующий взаимодействие с оригинальным геймпадом от XBox 360.
	 * 
	 * <p>Пример того как использовать данный класс, смотрите в AntGamepadManager.</p>
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  05.10.2013
	 */
	public class AntGamepadXBox360 implements IGamepad, IGamepadXBox360
	{
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		private var _device:GameInputDevice;
		
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
		public function AntGamepadXBox360(aDevice:GameInputDevice)
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
			_buttonA = new AntGamepadButton(this, map["buttonA"]);
			
			// Например: отмена действия.
			_buttonB = new AntGamepadButton(this, map["buttonB"]);
			
			// Например: действие.
			_buttonX = new AntGamepadButton(this, map["buttonX"]);
			
			// Например: карта или подсказки.
			_buttonY = new AntGamepadButton(this, map["buttonY"]);
			
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
			
			if (enabled)
			{
				enabled = false;
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

	}

}