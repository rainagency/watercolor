package watercolor.elements.interfaces
{
	import mx.graphics.IFill;
	import mx.graphics.IStroke;

	public interface IElementGraphic
	{
		function get fill():IFill;
		function set fill(value:IFill):void;
		
		function get stroke():IStroke;
		function set stroke(value:IStroke):void;
	}
}