package watercolor.events
{
	import flash.events.Event;
	
	import watercolor.elements.Element;
	
	public class LayerElementEvent extends Event
	{
		/**
		 * Dispatched before an element is added to a layer.
		 */
		public static const ADDING_ELEMENT:String = 'waterColorLayerAddingElement';
		
		/**
		 * Dispatched after an element is added to a layer.
		 */
		public static const ADDED_ELEMENT:String = 'waterColorLayerAddedElement';
		
		/**
		 * Dispatched before an element is removed from a layer.
		 */
		public static const REMOVING_ELEMENT:String = 'waterColorLayerRemovingElement';
		
		/**
		 * Dispatched after an element is removed from a layer.
		 */
		public static const REMOVED_ELEMENT:String = 'waterColorLayerRemovedElement';
		
		/**
		 * The element added or removed from a layer.
		 */
		public var element:Element;
		
		public function LayerElementEvent(type:String, element:Element, 
				bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.element = element;
		}
		
		override public function clone():Event
		{
			return new LayerElementEvent(type, element, bubbles, cancelable);
		}
	}
}