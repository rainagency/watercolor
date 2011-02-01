package watercolor.components
{
	import mx.core.IVisualElement;
	import mx.utils.HSBColor;
	
	/**
	 * The interface that a component must implement to be represent the HSB 
	 * color wheel.
	 * 
	 * @see watercolor.components.HSBColorPicker
	 * @see watercolor.components.HSBColorWheel
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * @author tylerchesley
	 * 
	 */	
	public interface IHSBColorWheel extends IVisualElement
	{
		function get selectedHSBColor():HSBColor;
		function set selectedHSBColor(value:HSBColor):void;
	}
}