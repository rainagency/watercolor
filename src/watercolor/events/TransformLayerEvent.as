package watercolor.events
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import watercolor.elements.Element;

	/**
	 * 
	 * @author mediarain
	 */
	public class TransformLayerEvent extends LayerTransformEvent
	{
		/**
		 * 
		 * An event that is dispatched when the user clicks on an element
		 */
		static public const TRANSFORM_INIT:String = "transformInit";
		/**
		 * 
		 * An event that is dispatched when the user begins a transformation 
		 */
		static public const TRANSFORM_BEGIN:String = "transformBegin";
		/**
		 * 
		 * An event that is dispatched continuously during a transformation
		 */
		static public const TRANSFORM_COMMIT:String = "transformCommit";
		/**
		 * 
		 * An event that is dispatched when a transformation is complete
		 */
		static public var TRANSFORM_FINISH:String = "transformFinish";
		/**
		 * 
		 * An event that is dispatched when the selection box is turned off
		 */
		static public const TRANSFORM_DEACTIVATED:String = "transformDeactive";

		public var mode:String;
		public var boundingBox:Rectangle;

		/**
		 * Constructor
		 * @param type The type of event;
		 * @param matrices A dictionary list of elements with their original matrix;
		 * @param mode The transformation mode
		 */
		public function TransformLayerEvent(type:String, transformations:Dictionary, elements:Vector.<Element>, boundingBox:Rectangle, mode:String = "modeIdle")
		{
			super(type, transformations, elements);
			this.mode = mode;
			this.boundingBox = boundingBox;
		}

		/**
		 * Overriden <code>clone()</code> method used to clone event; commonly used in bubbling.
		 */
		override public function clone():Event
		{
			return new TransformLayerEvent(this.type, this.transformations, this.elements, this.boundingBox, this.mode);
		}
	}
}