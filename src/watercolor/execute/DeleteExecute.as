package watercolor.execute
{
	import mx.core.IVisualElement;
	
	import watercolor.commands.vo.CommandVO;
	import watercolor.commands.vo.DeleteVO;
	
	/**
	 *  The DeleteExecute class contains the execute and undo functions used to execute
	 *  DeleteCommands
	 * 
	 *  @see watercolor.commands.execUtils.IExecute
	 *  @see watercolor.commands.vo.DeleteVO
	 *  
	 */
	public class DeleteExecute implements IExecute
	{
		/**
		 *  The execute method is called to execute a command stored in a DeleteVO 
		 *  @param vo the DeleteVO to be executed
		 * 
		 */
		public function execute(vo:CommandVO):void
		{
			var deleteVO:DeleteVO = vo as DeleteVO;
			deleteVO.position.parent.removeElement(deleteVO.element as IVisualElement);
		}

		/**
		 *  The undo method is called to undo a command stored in a DeleteVO 
		 *  @param vo the DeleteVO to be undone
		 * 
		 */
		public function undo(vo:CommandVO):void
		{
			var deleteVO:DeleteVO = vo as DeleteVO;
			deleteVO.position.parent.addElementAt(deleteVO.element as IVisualElement, deleteVO.position.index);
		}
	}
}