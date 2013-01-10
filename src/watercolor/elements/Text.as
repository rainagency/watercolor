package watercolor.elements
{
	import flashx.textLayout.elements.ListElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import mx.core.UIComponent;
	
	import spark.components.TextArea;
	import spark.utils.TextFlowUtil;
	
	import watercolor.components.WatercolorTextArea;
	import watercolor.events.TextEvent;
		
	[Style(name="skinClass", type="Class", inherit="no")]
	//[Style(name="lineBreak", type="String", inherit="no")]
	[Style(name="textFontSize", type="String", inherit="no")]
	
	/**
	 * Watercolor's Rect element encapsulates a Flex-based Rect, a filled
	 * graphic element that draws a rectangle.
	 * 
	 * @see spark.primitives.Rect
	 */
	public class Text extends Group
	{
		protected var _textInput:WatercolorTextArea;

		/**
		 * The Flex-based primitive wrapped by this Element.
		 */
		public function get textInput():WatercolorTextArea
		{
			return _textInput;
		}

		
		public function Text()
		{
			_textInput = new WatercolorTextArea();
			//_textInput.prompt = "type";
			
			var skinClass:Class = getStyle("skinClass") as Class;
			
			if (skinClass)
				this.skinClass = skinClass;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			addElement(textInput);
		}
		
		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#width;
		 */
		override public function get width():Number { return _textInput.width; }
		override public function set width(value:Number):void { super.width = value; _textInput.width = value; }
		
		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#height;
		 */
		override public function get height():Number { return _textInput.height; }
		override public function set height(value:Number):void { super.height = value; _textInput.height = value; }
		
		// :: TextInput Properties :: //
	
		public function get prompt():String { return _textInput.prompt; }
		public function set prompt(value:String):void { _textInput.prompt = value; }
		
		public function get text():String { return _textInput.text; }
		public function set text(value:String):void { 
			
			var old:String = _textInput.text;
			_textInput.text = value; 
			
			dispatchEvent(new TextEvent(TextEvent.EVENT_TEXT_MODIFIED, old));
		}
		
		public function set formattedText(value:String):void { 
			
			var old:String = _textInput.text;
			_textInput.textFlow = TextFlowUtil.importFromString(value); 
			
			dispatchEvent(new TextEvent(TextEvent.EVENT_TEXT_MODIFIED, old));
		}
		
		public function get textFlow():TextFlow { return _textInput.textFlow; }
		public function set textFlow(value:TextFlow):void { _textInput.textFlow = value; }
		
		public function get skinClass():Class { return _textInput.getStyle("skinClass"); }
		public function set skinClass(value:Class):void { 
			_textInput.setStyle("skinClass", value); 
		}
		
		/*public function get lineBreak():String { return _textInput.getStyle("lineBreak"); }
		public function set lineBreak(value:String):void { 
			_textInput.setStyle("lineBreak", value);
		}*/
		
		public function get textFontSize():String { return _textInput.getStyle("fontSize"); }
		public function set textFontSize(value:String):void { _textInput.setStyle("fontSize", value); }
		
		public function setFormatOfRange(format:TextLayoutFormat, anchorPosition:int=-1, activePosition:int=-1):void {
			
			_textInput.setFormatOfRange(format, anchorPosition, activePosition);
			
			dispatchEvent(new TextEvent(TextEvent.EVENT_TEXT_AREA_CHANGED));
		}
		
		public function get textWidth():Number {
			
			if (textInput && textInput.textDisplay is UIComponent) {
				return UIComponent(textInput.textDisplay).width;
			}
			
			return textInput.width;
		}
		
		public function set textWidth(value:Number):void {
			
			var fontSize:Number = textInput.getStyle("fontSize");
			
			if (value > fontSize) {
			
				if (textInput && textInput.textDisplay is UIComponent) {
					UIComponent(textInput.textDisplay).width = value;
				} else {
					textInput.width = value;
				}
				
			}
		}
		
		public function get listType():String {
			if (textFlow.getChildAt(0) is ListElement) {
				return ListElement(textFlow.getChildAt(0)).listStyleType;
			}
			
			return "";
		}
		
		public function set listType(value:String):void {
			if (value.length > 0 && textFlow.getChildAt(0) is ListElement) {
				ListElement(textFlow.getChildAt(0)).listStyleType = value;
			}
		}
	}
}