package ru.antkarlov.anthill.plugins.controller.interfaces
{
	
	public interface IGamepadXBox360
	{
		function bindControls():void;
		function detach():void;
		function destroy():void;
		function reset():void;
		
		function get buttonA():IGamepadButton;
		function get buttonB():IGamepadButton;
		function get buttonX():IGamepadButton;
		function get buttonY():IGamepadButton;
		
		function get leftShoulder():IGamepadButton;
		function get rightShoulder():IGamepadButton;
		
		function get leftTrigger():IGamepadTrigger;
		function get rightTrigger():IGamepadTrigger;
		
		function get leftStick():IGamepadStick;
		function get rightStick():IGamepadStick;
		
		function get dpad():IGamepadDPad;
		
		function get buttonBack():IGamepadButton;
		function get buttonStart():IGamepadButton;
		
		function get isDetached():Boolean;
		function get device():*;
		
		function get enabled():Boolean;
		function set enabled(aValue:Boolean):void;
	}

}