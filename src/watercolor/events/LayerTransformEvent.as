package watercolor.events
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import watercolor.elements.Element;

	/**
	 * 
	 * @author mediarain
	 */
	public class LayerTransformEvent extends Event
	{	
		public var transformations:Dictionary;
		public var elements:Vector.<Element>;
		
		/**
		 * Constructor
		 * @param type The type of event;
		 * @param type The elements being transformed
		 * @param matrices A dictionary list of elements with their original matrix;
		 */
		public function LayerTransformEvent(type:String, transformations:Dictionary, elements:Vector.<Element>)
		{
			super(type, false, false);
			this.transformations = transformations;
			this.elements = elements;
		}

		/**
		 * Overriden <code>clone()</code> method used to clone event; commonly used in bubbling.
		 */
		override public function clone():Event
		{
			return new LayerTransformEvent(this.type, this.transformations, this.elements);
		}
	}
}