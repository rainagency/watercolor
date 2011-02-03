package watercolor.execute
{
	import flash.geom.Matrix;
	import flash.geom.Point;

	import watercolor.commands.vo.CommandVO;
	import watercolor.commands.vo.TransformVO;
	import watercolor.elements.Element;
	import watercolor.events.TransformEvent;
	import watercolor.utils.CoordinateUtils;
	import watercolor.utils.MatrixInfo;
	import watercolor.utils.TransformUtil;


	/**
	 *  The TransformExecute class contains the execute and undo functions used to execute
	 *  instances of TransformVO
	 *
	 *  @see watercolor.commands.execUtils.IExecute
	 *  @see watercolor.commands.vo.TransformVO
	 *
	 */
	public class TransformExecute implements IExecute
	{
		/**
		 *  The execute method is called to execute a command stored in an TransformVO
		 *  @param vo the TransformVO to be executed
		 *
		 */
		public function execute( vo:CommandVO ):void
		{
			var transformVO:TransformVO = vo as TransformVO;
			transformVO.element.transform.matrix = transformVO.newMatrix;
			transformVO.element.dispatchEvent( new TransformEvent( TransformEvent.TRANSFORMATION_COMPLETE ));
		}


		/**
		 *  The execute method is called to execute a command stored in an TransformVO
		 *  @param vo the TransformVO to be executed
		 *
		 */
		public function undo( vo:CommandVO ):void
		{
			var transformVO:TransformVO = vo as TransformVO;
			transformVO.element.transform.matrix = transformVO.originalMatrix;
			transformVO.element.dispatchEvent( new TransformEvent( TransformEvent.TRANSFORMATION_COMPLETE ));
		}
	}
}