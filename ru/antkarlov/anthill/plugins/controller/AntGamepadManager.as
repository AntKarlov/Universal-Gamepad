package ru.antkarlov.anthill.plugins.controller
{
	import flash.events.GameInputEvent;
	import flash.utils.getTimer;
	import flash.system.Capabilities;
	
	import flash.ui.GameInput;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	
	import ru.antkarlov.anthill.AntCamera;
	import ru.antkarlov.anthill.AntG;
	import ru.antkarlov.anthill.signals.AntSignal;
	import ru.antkarlov.anthill.plugins.IPlugin;
	import ru.antkarlov.anthill.plugins.controller.interfaces.IGamepad;
	import ru.antkarlov.anthill.plugins.controller.gamepads.*;
	
	/**
	 * Менеджер геймпадов позволяет перехватывать события подключений или отключения 
	 * геймпадов, а так же предоставляет доступ к уже подключенным геймпадам.
	 * 
	 * <p>Пример использования:</p>
	 * 
	 * <listing>
	 * gamepadManager = new AntGamepadManager();
	 * gamepadManager.eventAttach.add(onAttachGamepad);
	 * 
	 * function onAttachGamepad(aGamepadManager:AntGamepadManager):void
	 * {
	 *   if (aGamepadManager.hasReadyGamepad())
	 *   {
	 *     var gamepad:IGamepadXBox360 = aGamepadManager.getReadyGamepad() as IGamepadXBox360;
	 * 	 }
	 * }
	 * </listing>
	 * 
	 * <p>Вы можете определить поддержку геймпадов версией плеера используя метод:</p>
	 * 
	 * <listing>
	 * if (!gamepadManager.isSupportedGamepad())
	 * {
	 *   trace("Your version of the player don't support gamepads.");
	 * }
	 * </listing>
	 * 
	 * <p>Если ваша игра не обнаружила подключенного геймпада, то вы можете создать 
	 * фейковый геймпад который будет работать за счет нажатия кнопок на клавиатуре
	 * как оригинальный.</p>
	 * 
	 * <listing>
	 * var gamepad:IGamepadXBox360;
	 * ..
	 * if (gamepad == null)
	 * {
	 *   gamepad = new AntKeyboardXbox360() as IGamepadXBox360;
	 * }
	 * </listing>
	 * 
	 * <p>Далее, если вы получите событие о подключении геймпада, вы можете просто 
	 * пресоздать контроллер, инициализировав класс для работы с оригинальным геймпадом.</p>
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  04.10.2013
	 */
	public class AntGamepadManager extends Object implements IPlugin
	{
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		/**
		 * Узказатель на оригинальный класс который предоставляет доступ к геймпадам.
		 * @default    GameInput
		 */
		public var gameInput:GameInput;
		
		/**
		 * Событие подключение нового геймпада.
		 * Метод-слушаетль для данного события должен принимать 
		 * в качестве аргумента указатель на AntGamepadManager.
		 * @default    AntSignal
		 */
		public var eventAttach:AntSignal;
		
		/**
		 * Событие отключения геймпада.
		 * Метод-слушатель для данного события должен принимать 
		 * в качестве аргумента указатель на AntGamepad.
		 * @default    AntSignal
		 */
		public var eventDetach:AntSignal;
				
		//---------------------------------------
		// PROTECTED VARIABLES
		//---------------------------------------
		protected var _tag:String;
		protected var _priority:int;
		protected var _isActive:Boolean;
		
		protected static var _activeGamepads:Vector.<IGamepad> = new Vector.<IGamepad>();
		protected static var _readyGamepads:Vector.<IGamepad> = new Vector.<IGamepad>();
		protected static var _supportedControllers:Vector.<Object> = new Vector.<Object>();
		
		public static var currentTime:uint;
		public static var previousTime:uint;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function AntGamepadManager()
		{
			super();
			
			/*
				Первым делом формируется список поддерживаемых устройств. 
				Для каждого устройства задается имя которое определяется драйвером.
				Если ваш геймпад не является оригинальным геймпадом ouya или xbox, но работает
				как оригинальный, вам нужно определить его имя и ассоциировать его с правильным классом.
				
				Например: addSupportedController("logitech", AntGamepadXBox360);
				
				Чтобы определить имя вашего контроллера, после запуска флешки откройте консоль нажав кнопку
				"~" и найдите сообщение о нераспознанном устройстве, в этом сообщении вы увидите и имя устройства.
			*/
			addSupportedController("controller", AntGamepadXBox360); // Для Mac OSX с драйвером от TattieBogle
			addSupportedController("xbox 360", AntGamepadXBox360); // Для Windows с оригинальным драйвером
			addSupportedController("ouya", AntGamepadOuya); // Для Windows (не тестировалось)
			
			// Инициализация менеджера.
			gameInput = new GameInput();
			gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, addDeviceHandler);
			gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, removeDeviceHandler);
			
			eventAttach = new AntSignal(AntGamepadManager);
			eventDetach = new AntSignal(IGamepad);
			
			currentTime = getTimer();
			previousTime = currentTime;
			
			for (var i:int = 0; i < GameInput.numDevices; i++)
			{
				attachDevice(GameInput.getDeviceAt(i));
			}
			
			_tag = null;
			_priority = 0;
			_isActive = false;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Определяет поддерживается ли геймпад в текущей весрии плеера.
		 * 
		 * @return		Возвращает true если версия плеера 11.8 или старше.
		 */
		public function isSupportedGamepad():Boolean
		{
			var arr:Array = Capabilities.version.split(" ");
			var ver:Array = arr[1].split(",");
			return !(Math.floor(ver[0]) <= 11 && Math.floor(ver[1]) < 8);
		}
		
		/**
		 * Определяет есть ли доступные для использования геймпады.
		 * 
		 * @return		Возвращает true если есть доступные для использования геймпады.
		 */
		public function hasReadyGamepad():Boolean
		{
			return (_readyGamepads.length > 0);
		}
		
		/**
		 * Возвращает первый доступный для использования геймпад.
		 * 
		 * @return		Возвращает указатель на первый доступный для использования геймпад.
		 */
		public function getReadyGamepad():IGamepad
		{
			if (_readyGamepads.length > 0)
			{
				var gamepad:IGamepad = _readyGamepads.shift();
				gamepad.enabled = true;
				_activeGamepads.push(gamepad);
				
				if (!_isActive)
				{
					AntG.plugins.add(this);
					_isActive = true;
				}
				
				return gamepad;
			}
			
			return null;
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * Подключает указанный геймпад.
		 * 
		 * @param	aDevice	 Указатель на оригинальный класс устройства ввода.
		 */
		protected function attachDevice(aDevice:GameInputDevice):void
		{
			if (aDevice != null)
			{
				var gamepadClass:Class = defineGamepadType(aDevice.name);
				if (gamepadClass != null)
				{
					GameInputControlName.initialize(aDevice);
					var gamepad:IGamepad = new gamepadClass(aDevice);
					gamepad.bindControls();
					_readyGamepads.push(gamepad);
					
					if (eventAttach.numListeners > 0)
					{
						eventAttach.dispatch(this);
					}
					
					AntG.log("(i): Attached new gamepad: \"" + aDevice.name + "\".", 0x49a7f7);
				}
				else
				{
					AntG.log("(!): Unsupported gamepad type: \"" + aDevice.name + "\".", "error");
				}
			}
		}
		
		/**
		 * Отключает указанный геймпад.
		 * 
		 * @param	aDevice	 Указатель на оригинальный класс устройства ввода.
		 */
		protected function detachDevice(aDevice:GameInputDevice):void
		{
			if (aDevice != null)
			{
				var gamepad:IGamepad = removeGamepadFrom(_activeGamepads, aDevice) || removeGamepadFrom(_readyGamepads, aDevice);
				if (gamepad != null)
				{
					gamepad.detach();
					
					if (eventDetach.numListeners > 0)
					{
						eventDetach.dispatch(gamepad);
					}
					
					AntG.log("(i): Detached gamepad: \"" + aDevice.name + "\".", 0x49a7f7);
				}
			}
		}
		
		/**
		 * Обработчик подключения нового устройства.
		 */
		protected function addDeviceHandler(event:GameInputEvent):void
		{
			attachDevice(event.device);
		}
		
		/**
		 * Обработчик отключения устройства.
		 */
		protected function removeDeviceHandler(event:GameInputEvent):void
		{
			detachDevice(event.device);
		}
		
		/**
		 * Метод определяющий по имени устройства класс геймпада для вазимодействия с ним.
		 * 
		 * @param	aDeviceName	 Имя подключенного устройства.
		 * @return		Возвращает класс геймпада подходящего для работы с новым устройством или null если устройство неизвестное.
		 */
		protected function defineGamepadType(aDeviceName:String):Class
		{
			aDeviceName = aDeviceName.toLowerCase();
			for each (var controllerInfo:Object in _supportedControllers)
			{
				if (aDeviceName.indexOf(controllerInfo.controllerType) > -1)
				{
					return controllerInfo.gamepadClass;
				}
			}
			
			return null;
		}
		
		/**
		 * Метод помошник для удаления геймпада из указанного списка.
		 * 
		 * @param	aGamepadList	 Список из которого необходимо удалить указатель на геймпад.
		 * @param	aDevice	 Указатель на оригинальный класс устройства которое необходимо удалить.
		 * @return		Возвращает указатель на удаленный геймпад.
		 */
		protected function removeGamepadFrom(aGamepadsList:Vector.<IGamepad>, aDevice:GameInputDevice):IGamepad
		{
			var gamepad:IGamepad = null;
			const n:int = aGamepadsList.length;
			var i:int = 0;
			while (i < n)
			{
				gamepad = aGamepadsList[i];
				if (gamepad.device == aDevice)
				{
					aGamepadsList.splice(i, 1);
					return gamepad;
				}
				
				i++;
			}
			
			return null;
		}
		
		/**
		 * Метод помошник для добавления поддерживаемых устройств.
		 * 
		 * @param	aControllerType	 Имя или часть имени устройства которое может поддерживатся.
		 * @param	aGamepadClass	 Класс для взаимодействия с указанным устройством.
		 */
		protected function addSupportedController(aControllerType:String, aGamepadClass:Class):void
		{
			_supportedControllers.push({ controllerType:aControllerType, gamepadClass:aGamepadClass });
		}
		
		//---------------------------------------
		// IPlugin Implementation
		//---------------------------------------

		//import ru.antkarlov.anthill.plugins.IPlugin;
		public function get tag():String { return _tag; }
		public function set tag(aValue:String):void
		{
			_tag = aValue;
		}

		public function get priority():int { return _priority; }
		public function set priority(aValue:int):void
		{
			_priority = aValue;
		}

		public function update():void
		{
			previousTime = currentTime;
			currentTime = getTimer();
		}

		public function draw(aCamera:AntCamera):void
		{
			// ..
		}

	}

}