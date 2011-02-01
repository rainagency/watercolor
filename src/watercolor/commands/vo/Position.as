package watercolor.commands.vo
{
	import mx.core.IVisualElementContainer;


	/**
	 * A class designed to conviently store the parent and the display list position
	 * of an element.
	 *
	 *
	 */
	public class Position
	{

		/**
		 * Constructor.
		 * @param parent
		 * @param index
		 *
		 */
		public function Position( parent:IVisualElementContainer, index:uint )
		{
			this.parent = parent;
			this.index = index;
		}


		/**
		 * The index of the element in the parent's display list.
		 */
		public var index:uint;


		/**
		 * The instance of the parent class.
		 */
		public var parent:IVisualElementContainer;


		/**
		 * Clone this Position
		 *
		 * @return A cloned position.
		 */
		public function clone():Position
		{
			return new Position( parent, index );
		}
	}
}