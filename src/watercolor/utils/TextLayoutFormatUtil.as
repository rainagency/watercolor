package watercolor.utils
{
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import spark.components.TextArea;
	
	import watercolor.commands.vo.TextFormatVO;
	import watercolor.elements.Text;

	/**
	 * 
	 * @author Jeremiah
	 */
	public class TextLayoutFormatUtil
	{
		/**
		 * 
		 * @return 
		 */
		public static function getRequestedFormats():Vector.<String> {
			
			var vec:Vector.<String> = new Vector.<String>();
			vec.push("fontWeight");
			vec.push("fontFamily");
			vec.push("fontStyle");
			vec.push("fontSize");
			vec.push("color");
			vec.push("textAlign");
			vec.push("textDecoration");
			
			return vec;
		}
		
		/**
		 * 
		 * @param text
		 * @param start
		 * @param end
		 * @return 
		 */
		public static function grabTextRanges(text:Text, start:int, end:int):Vector.<TextFormatVO> {
			
			var input:TextArea = text.textInput;
			var array:Vector.<TextFormatVO> = new Vector.<TextFormatVO>();
			
			if (start <= end && end <= input.text.length) {
			
				var fmt:TextLayoutFormat;
				var ffmt:TextLayoutFormat;
				var differences:Boolean = false;
				var tstart:int = start;
				var tfVO:TextFormatVO;
				
				for (var x:int = start; x < end + 1; x++) {
					
					var s:String = input.text.substr(x, 1);
					
					fmt = input.getFormatOfRange(getRequestedFormats(), x, x);
					
					if (x < end) {
						ffmt = input.getFormatOfRange(getRequestedFormats(), x + 1, x + 1);
						
						//trace("Weight: " + fmt.fontWeight + ", " + ffmt.fontWeight);
					}
					
					if (ffmt && (fmt.fontWeight != ffmt.fontWeight || 
						fmt.fontStyle != ffmt.fontStyle || 
						fmt.fontFamily != ffmt.fontFamily ||
						fmt.fontSize != ffmt.fontSize ||
						fmt.color != ffmt.color ||
						(differences && x == end))) {
						
						differences = true;
						
						tfVO = new TextFormatVO();
						tfVO.element = text;
						tfVO.start = tstart;
						tfVO.end = x;
						tfVO.oldFmt = new TextLayoutFormat();
						tfVO.oldFmt.copy(fmt);
						tfVO.newFmt = fmt;
						
						array.push(tfVO);
						
						tstart = x;
					}
				}
				
				if (!differences) {
					
					fmt = input.getFormatOfRange(getRequestedFormats(), start, end);
					
					tfVO = new TextFormatVO();
					tfVO.element = text;
					tfVO.start = start;
					tfVO.end = end;
					tfVO.oldFmt = new TextLayoutFormat();
					tfVO.oldFmt.copy(fmt);
					tfVO.newFmt = fmt;
					
					array.push(tfVO);
				}
			}
			
			return array;
		}
	}
}