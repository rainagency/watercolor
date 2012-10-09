package watercolor.execute
{
	import mx.core.IVisualElement;
	
	import watercolor.commands.vo.ArrangeVO;
	import watercolor.commands.vo.CommandVO;
	import watercolor.commands.vo.TextFormatVO;
	import watercolor.elements.Text;

	/**
	 *  The ArrangeExecute class contains the execute and undo functions used to execute
	 *  ArrangeCommands
	 * 
	 *  @see watercolor.commands.execUtils.IExecute
	 *  @see watercolor.commands.vo.ArrangeVO
	 *  
	 */
	public class TextFormatExecute implements IExecute
	{
		/**
		 *  The execute method is called to execute a command stored in an ArrangeCommand 
		 *  @param vo the ArrangeVO to be executed
		 */
		public function execute(vo:CommandVO):void
		{			
			var textFormatVO:TextFormatVO = vo as TextFormatVO;
			
			if (textFormatVO.element is Text && Text(textFormatVO.element).textInput) {
				Text(textFormatVO.element).textInput.setFormatOfRange(textFormatVO.newFmt, textFormatVO.start, textFormatVO.end);
			}
		}

		/**
		 *  The undo method is called to undo a command stored in an ArrangeCommand 
		 *  @param vo the ArrangeVO to be undone
		 */
		public function undo(vo:CommandVO):void
		{			
			var textFormatVO:TextFormatVO = vo as TextFormatVO;
			
			if (textFormatVO.element is Text && Text(textFormatVO.element).textInput) {
				Text(textFormatVO.element).textInput.setFormatOfRange(textFormatVO.oldFmt, textFormatVO.start, textFormatVO.end);
			}
		}
	}
}