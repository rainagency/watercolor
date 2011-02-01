package watercolor.elements
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	import mx.core.IVisualElementContainer;

	import spark.components.Group;

	import watercolor.commands.vo.Position;



	/**
	 *  Dispatched when a element is selected by the SelectionManager.
	 *  <code>event.currentTarget</code> is the Element that's been selection.
	 *
	 *  @eventType watercolor.events.ElementSelectionEvent.ELEMENT_SELECTED
	 */
	[Event( name="elementSelected", type="watercolor.events.ElementSelectionEvent" )]

	/**
	 *  Dispatched when a element is deselected by the SelectionManager.
	 *  <code>event.currentTarget</code> is the Element that's been deselected.
	 *
	 *  @eventType watercolor.events.ElementSelectionEvent.ELEMENT_DESELECTED
	 */
	[Event( name="elementDeselected", type="watercolor.events.ElementSelectionEvent" )]


	/**
	 *
	 * @author mediarain
	 * @author Sean Thayne
	 */
	public class Element extends Group
	{
		/**
		 *
		 */
		public function Element()
		{
			// If this is not set to true, GroupBase (which this extends) will draw a transparent
			// background over the full element area which will pick up mouse events.  In other
			// words, if this element contained a triangle the user would be able to select the
			// element by clicking the transparent corners around the triangle.  This generally 
			// isn't the functionality that we want so we set it false.
			mouseEnabledWhereTransparent = false;
		}


		private var _childMatrix:Matrix;



		/**
		 * Optional value to indicate a child element's original location in a group
		 * @return
		 */
		public function get childMatrix():Matrix
		{
			return _childMatrix;
		}


		/**
		 *
		 * @param value
		 */
		public function set childMatrix( value:Matrix ):void
		{
			_childMatrix = value;
		}


		/**
		 * Returns the current Position of this element (if any)
		 *
		 * @return Current Position of this Element.
		 */
		public function getPosition():Position
		{
			if( this.parent is IVisualElementContainer )
			{
				return new Position( IVisualElementContainer( this.parent ), IVisualElementContainer( this.parent ).getElementIndex( this ));
			}
			else
			{
				return null;
			}
		}

	}
}