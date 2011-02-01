package watercolor.events
{
	import flash.events.Event;
	
	/**
	 * WorkareaEvent is a simple event class defining events associated with
	 * the Workarea, such as zoomed and panned.
	 */
	public class WorkareaEvent extends Event
	{
		/**
		 * The zoom event occurs upon a zoom action of the document layer.
		 * 
		 * @see		watercolor.elements.components.Workarea#zoomPoint
		 * @see		watercolor.elements.components.Workarea#zoomRect
		 */
		public static const ZOOM:String = "zoom";
		
		/**
		 * The pan event follows any pan action of the document layer.
		 * 
		 * @see		watercolor.elements.components.Workarea#pan
		 */
		public static const PAN:String = "pan";
		
		/**
		 * The currentLayerChanged event follows any current layer change.
		 * 
		 * @see		watercolor.elements.components.Workarea#currentLayer
		 */
		public static const CURRENT_LAYER_CHANGED:String = "currentLayerChanged";
		
		/**
		 * Constructor.
		 * 
		 * @param	type			The event type; indicates the action that
		 * 							caused the event.
		 * @param	bubbles			Specifies whether the event can bubble up
		 * 							the display list hierarchy.
		 * @param	cancelable		Specifies whether the behavior associated
		 * 							with the event can be prevented.
		 */
		public function WorkareaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @private
		 */
		override public function clone():Event
		{
			//trace("NOTIFY GARTH WHEN THIS IS CLONED!");
			return new WorkareaEvent(type, bubbles, cancelable);
		}
	}
}