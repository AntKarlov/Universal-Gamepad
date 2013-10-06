package ru.antkarlov.anthill.plugins.controller.interfaces
{
	
	public interface IGamepadStick
	{
		function reset():void;
		function destroy():void;
		function update():void;
		
		function get lerpFactor():Number;
		function set lerpFactor(aValue:Number):void;
		
		function get up():IGamepadButton;
		function get down():IGamepadButton;
		function get left():IGamepadButton;
		function get right():IGamepadButton;
		
		function get isPressed():Boolean;
		function get isDown():Boolean;
		function get isReleased():Boolean;
		
		function get reverseX():Boolean;
		function set reverseX(aValue:Boolean):void;
		function get reverseY():Boolean;
		function set reverseY(aValue:Boolean):void;
		
		function get axisX():Number;
		function get axisY():Number;
		function get lerpAxisX():Number;
		function get lerpAxisY():Number;
		function get angle():Number;
		function get lerpAngle():Number;
		function get distance():Number;
		function get lerpDistance():Number;
	}

}