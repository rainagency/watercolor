package watercolor.commands.vo
{
	import watercolor.execute.TransformExecute;
	
	import flash.geom.Matrix;
	
	import watercolor.elements.Element;

	/**
	 *  The TransformVO class stores the command data used by TransformExecute to execute and undo
	 *  a property change command.  The TransformVO can be stored and used by the HistoryManager.
	 *
	 *  @see watercolor.managers.HistoryManager
	 *  @see watercolor.commands.execUtils.TransformExecute
	 *
	 */
	public class TransformVO extends CommandVO
	{
		public function TransformVO()
		{
			super();
			executeClass = TransformExecute;
		}

		/**
		 * The new matrix that will be applied to the element
		 */
		public var newMatrix:Matrix;
		
		/**
		 * The original transform matrix of the element before the transformation was applied
		 */
		public var originalMatrix:Matrix;
		
		
		public var useChildMatrix:Boolean;
		
		override public function set element(value:Element):void
		{
			super.element = value;
			originalMatrix = value.transform.matrix;
		}
	}
}