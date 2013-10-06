package ru.antkarlov.anthill.plugins.controller.interfaces
{
	
	public interface IGamepadDPad
	{
		function reset():void;
		function destroy():void;
		function update():void;
		
		function get up():IGamepadButton;
		function get down():IGamepadButton;
		function get left():IGamepadButton;
		function get right():IGamepadButton;
	}

}