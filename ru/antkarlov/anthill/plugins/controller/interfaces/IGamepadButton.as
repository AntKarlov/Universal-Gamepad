package ru.antkarlov.anthill.plugins.controller.interfaces
{
	
	public interface IGamepadButton
	{
		function reset():void;
		function destroy():void;
		function update():void;
		
		function get value():Number;
		
		function get controlName():String;
		function set controlName(aValue:String):void;
		
		function get isPressed():Boolean;
		function get isDown():Boolean;
		function get isReleased():Boolean;
	}

}