package ru.antkarlov.anthill.plugins.controller.interfaces
{
	
	public interface IGamepadTrigger
	{
		function reset():void;
		function destroy():void;
		function update():void;
		
		function get controlName():String;
		function set controlName(aValue:String):void;
		
		function get lerpFactor():Number;
		function set lerpFactor(aValue:Number):void;
		
		function get value():Number;
		function get percent():Number;
		function get lerpPercent():Number;
	}

}