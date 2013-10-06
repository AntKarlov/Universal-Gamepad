package
{
	import ru.antkarlov.anthill.*;
	import ru.antkarlov.anthill.utils.*;
	
	import ru.antkarlov.anthill.plugins.*;
	import ru.antkarlov.anthill.plugins.controller.AntGamepadManager;
	import ru.antkarlov.anthill.plugins.controller.gamepads.*;
	import ru.antkarlov.anthill.plugins.controller.interfaces.*;
	import flash.system.Capabilities;
	
	public class GameState extends AntState
	{
		private var _label:AntLabel;
		private var _info:AntLabel;
		private var _instructions:AntLabel;
		private var _gamepadManager:AntGamepadManager;
		private var _gamepad:IGamepadXBox360;
		private var _visualControls:Object;
		private var _tm:AntTaskManager;
		
		private var _pause:Boolean;
		private var _artIsReady:Boolean;
		
		/**
		 * @constructor
		 */
		public function GameState()
		{
			super();
			
			// Создаем менджер геймпадов.
			_gamepadManager = new AntGamepadManager();
			
			// Подписываемся на событие подключение геймпада.
			_gamepadManager.eventAttach.add(onAttachGamepad);
			
			// Подписываемся на событие отключения геймпада.
			_gamepadManager.eventDetach.add(onDetachGamepad);
			
			// Менеджер задач.
			_tm = new AntTaskManager();
			
			// Флаг определяющий режим паузы для обновления визуальных контролов.
			_pause = false;
			
			// Флаг определяющий готова ли графика для создания визуального образа геймпада.
			_artIsReady = false;
			
			// Создаем по умолчанию фейковый геймпад.
			_gamepad = new AntKeyboardXBox360() as IGamepadXBox360;
			_gamepad.enabled = true;
			
			// Объект содержащий указатели на все визуальные контролы.
			_visualControls = {};
		}
		
		/**
		 * Обработчик события подключения нового геймпада.
		 */
		private function onAttachGamepad(aGamepadManager:AntGamepadManager):void
		{
			// Если есть доступные для использования геймпады.
			if (aGamepadManager.hasReadyGamepad() && _gamepad is AntKeyboardXBox360)
			{
				// Приостанавливаем обработку всех визуальных контролов на момент смены геймпада.
				_pause = true;
				
				// Удаляем фейковый геймпад
				_gamepad.destroy();
				
				// Сохраняем указатель на геймпад.
				_gamepad = aGamepadManager.getReadyGamepad() as IGamepadXBox360;
				
				// Добавляем задачу для переназначения контролов, потому что геймпад может быть
				// подключен до того как графика будет подготовлена и контролы будут созданы.
				// Задача будет выполняется до тех пор пока метод bindControls не вернет true.
				_tm.addTask(bindControls, [ _gamepad ]);
				
				// Обновляем информацию.
				updateInfoLabel("(i): Геймпад подключен!", 0xC0EA15);
			}
		}
				
		/**
		 * Обработчик события отключения геймпада.
		 */
		private function onDetachGamepad(aGamepad:IGamepad):void
		{
			// Освобождаем геймпад.
			aGamepad.destroy();
			
			// Создаем фейковый геймпад.
			_gamepad = new AntKeyboardXBox360() as IGamepadXBox360;
			_gamepad.enabled = true;
			
			// Связываем визуальные компоненты с новым геймпадом.
			bindControls(_gamepad);
			
			// Обновляем информацию.
			updateInfoLabel("(i): Геймпад отключен.", 0xF73709);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function create():void
		{
			super.create();
			
			// Создаем камеру.
			var camera:AntCamera = new AntCamera(0, 0, 640, 480);
			camera.fillBackground = true;
			camera.backgroundColor = 0xFFCCCCCC;
			AntG.addCamera(camera);
			
			// Создаем текстовое поле с инструкциями для клавиатуры
			makeInstructions();
			
			// Название демки.	
			_label = new AntLabel("system");
			_label.reset(15, 15);
			_label.beginChange();
			_label.text = "Демонстрация плагина AntGamepad для Anthill.\n";
			_label.highlightText("AntGamepad", AntColor.RED);
			_label.setStroke();
			_label.endChange();
			add(_label);
			
			// Информационное поле для отображения состояний геймпада.
			_info = new AntLabel("system");
			_info.reset(15, 30);
			_info.beginChange();
			
			// Опеределяем поддерживается ли геймпад текущей версией плеера.
			if (!_gamepadManager.isSupportedGamepad())
			{
				updateInfoLabel("(!): Для работы с геймпадом требуется версия Flash Player 11.8 или старше!", 0xF73709);
			}
			else
			{
				updateInfoLabel("(!): Нет подключенных геймпадов.", 0xFF9900);
			}
			
			_info.setStroke();
			_info.endChange();
			add(_info);
			
			// Скрываем лишние отладочные инструменты.
			AntG.debugger.show();
			AntG.debugger.console.hide();
			AntG.debugger.monitor.hide();
			AntG.debugger.perfomance.hide();
			
			// Список графики для кэширования.
			var clips:Vector.<Class> = new <Class>[ ButtonY_mc, 
				ButtonB_mc,
				ButtonA_mc,
				ButtonX_mc,
				Shoulder_mc,
				ButtonStart_mc,
				ButtonHome_mc,
				ButtonBack_mc,
				Joystick_mc,
				StickPoint_mc,
				Trigger_mc,
				DPadLeft_mc,
				DPadRight_mc,
				DPadDown_mc,
				DPadUp_mc,
				Bg_mc ];
			
			// Запускаем процесс кэширования графики.
			var assetLoader:AntAssetLoader = new AntAssetLoader();
			assetLoader.addClips(clips);
			assetLoader.eventComplete.add(onStart);
			assetLoader.start();
		}
		
		/**
		 * Обработчик завершения процесса кэширования графики.
		 */
		private function onStart(aAssetLoader:AntAssetLoader):void
		{
			_artIsReady = true;
			aAssetLoader.destroy();
			createVisualControls();
		}
		
		/**
		 * @private
		 */
		override public function update():void
		{
			// Простая реализация паузы для приостановки обновления
			// визуальных контролов на момент смены геймпада.
			if (!_pause)
			{
				super.update();
			}
		}
		
		/**
		 * Создание графических кнопок для демонстрации работы геймпада.
		 */
		private function createVisualControls():void
		{
			// Создаем фон с подписями.
			var bg:AntActor = new AntActor();
			bg.addAnimationFromCache("Bg_mc");
			bg.x = 304;
			bg.y = 213;
			add(bg);
			
			// Создаем графические объекты кнопок и записываем их в объект.
			_visualControls["buttonY"] = makeTestButton("ButtonY_mc", 475, 160);
			_visualControls["buttonB"] = makeTestButton("ButtonB_mc", 505, 192);
			_visualControls["buttonA"] = makeTestButton("ButtonA_mc", 475, 224);
			_visualControls["buttonX"] = makeTestButton("ButtonX_mc", 445, 192);

			_visualControls["leftShoulder"] = makeTestButton("Shoulder_mc", 142, 117);
			_visualControls["rightShoulder"] = makeTestButton("Shoulder_mc", 498, 117);

			_visualControls["leftTrigger"] = makeTestTrigger(185, 96);
			_visualControls["rightTrigger"] = makeTestTrigger(455, 96);
				
			_visualControls["dpad"] = makeTestDPad(263, 279);

			_visualControls["buttonBack"] = makeTestButton("ButtonBack_mc", 268, 195);
			_visualControls["buttonStart"] = makeTestButton("ButtonStart_mc", 372, 195);

			_visualControls["leftStick"] = makeTestStick(161, 187);
			_visualControls["rightStick"] = makeTestStick(377, 279);
			
			// Связываем графические объекты кнопок с геймпадом.
			bindControls(_gamepad);
		}
		
		/**
		 * Связываение визуальных компонентов с контролами геймпада.
		 * Используется при смене устройства ввода (Отключение/отключение геймпада).
		 */
		private function bindControls(aGamepad:IGamepadXBox360):Boolean
		{
			if (_artIsReady)
			{
				(_visualControls["buttonY"] as TestButton).control = aGamepad.buttonY;
				(_visualControls["buttonB"] as TestButton).control = aGamepad.buttonB;
				(_visualControls["buttonA"] as TestButton).control = aGamepad.buttonA;
				(_visualControls["buttonX"] as TestButton).control = aGamepad.buttonX;
				(_visualControls["leftShoulder"] as TestButton).control = aGamepad.leftShoulder;
				(_visualControls["rightShoulder"] as TestButton).control = aGamepad.rightShoulder;
				(_visualControls["leftTrigger"] as TestTrigger).control = aGamepad.leftTrigger;
				(_visualControls["rightTrigger"] as TestTrigger).control = aGamepad.rightTrigger;
				(_visualControls["dpad"] as TestDPad).control = aGamepad.dpad;
				(_visualControls["buttonBack"] as TestButton).control = aGamepad.buttonBack;
				(_visualControls["buttonStart"] as TestButton).control = aGamepad.buttonStart;
				(_visualControls["leftStick"] as TestStick).control = aGamepad.leftStick;
				(_visualControls["rightStick"] as TestStick).control = aGamepad.rightStick;
				
				// Показываем или скрываем инструкции в зависимости от геймпада.
				_instructions.visible = (_gamepad is AntKeyboardXBox360);
				
				// Отключаем паузу.
				_pause = false;
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Создание визуального образа кнопки для демонстрации работы.
		 */
		private function makeTestButton(aAnimName:String, aX:int, aY:int):TestButton
		{
			var button:TestButton = new TestButton();
			button.addAnimationFromCache(aAnimName);
			button.x = aX;
			button.y = aY;
			add(button);
			return button;
		}
		
		/**
		 * Создание визуального образа стика для демонстрации работы.
		 */
		private function makeTestStick(aX:int, aY:int):TestStick
		{
			var stick:TestStick = new TestStick();
			stick.x = aX;
			stick.y = aY;
			add(stick);
			return stick;
		}
		
		/**
		 * Создание визуального образа курка для демонстрации работы.
		 */
		private function makeTestTrigger(aX:int, aY:int):TestTrigger
		{
			var trigger:TestTrigger = new TestTrigger();
			trigger.x = aX;
			trigger.y = aY;
			add(trigger);
			return trigger;
		}
		
		/**
		 * Создание визуального образа dpad для демонстрации работы.
		 */
		private function makeTestDPad(aX:int, aY:int):TestDPad
		{
			var dpad:TestDPad = new TestDPad();
			dpad.x = aX;
			dpad.y = aY;
			add(dpad);
			return dpad;
		}
		
		/**
		 * @private
		 */
		private function makeInstructions():void
		{
			_instructions = new AntLabel("system");
			_instructions.reset(15, 290);
			_instructions.beginChange();
			_instructions.text += "LB - 1\n";
			_instructions.text += "RB - 2\n";
			_instructions.text += "LT - R\n";
			_instructions.text += "RT - F\n";
			_instructions.text += "Back - ESC\n";
			_instructions.text += "Start - Enter\n";
			_instructions.text += "ButtonA - Spacebar\n";
			_instructions.text += "ButtonB - Q\n";
			_instructions.text += "ButtonX - E\n";
			_instructions.text += "ButtonY - I\n";
			_instructions.text += "LeftStick - W, A, S, D, SHIFT\n";
			_instructions.text += "RightStick - LEFT, UP, RIGHT, DOWN, NumPad0\n";
			_instructions.text += "DPad - NumPad4, NumPad8, NumPad6, NumPad5\n";
			
			_instructions.highlightText("LB", 0x999999);
			_instructions.highlightText("RB", 0x999999);
			_instructions.highlightText("LT", 0x999999);
			_instructions.highlightText("RT", 0x999999);
			_instructions.highlightText("Back", 0x999999);
			_instructions.highlightText("Start", 0x999999);
			_instructions.highlightText("ButtonB", 0xF73709);
			_instructions.highlightText("ButtonA", 0xC0EA15);
			_instructions.highlightText("ButtonX", 0x4288F0);
			_instructions.highlightText("ButtonY", 0xFF9900);
			_instructions.highlightText("LeftStick", 0x999999);
			_instructions.highlightText("RightStick", 0x999999);
			_instructions.highlightText("DPad", 0x999999);
			_instructions.setStroke();
			_instructions.endChange();
			add(_instructions);
		}
		
		/**
		 * @private
		 */
		private function updateInfoLabel(aText:String, aColor:uint = 0xFFFFFF):void
		{
			_info.text = aText;
			_info.highlightText(aText, aColor);
		}
	}

}