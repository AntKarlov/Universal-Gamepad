package ru.antkarlov.anthill.plugins.controller.interfaces
{
	
	public interface IGamepad
	{
		function bindControls():void;
		function detach():void;
		function destroy():void;
		function reset():void;
		
		function get isDetached():Boolean;
		function get device():*;
		
		function get enabled():Boolean;
		function set enabled(aValue:Boolean):void;
	}

}