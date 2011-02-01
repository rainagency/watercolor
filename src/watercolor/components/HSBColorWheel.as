package watercolor.components
{
	import watercolor.utils.HSBColorUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.IVisualElement;
	import mx.utils.HSBColor;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.BitmapImage;
	import watercolor.components.supportClasses.ColorWheelBitmap;
	
//------------------------------------------
//	Events
//------------------------------------------
	
	/**
	 * Dispatched when the <code>selectedHSBColor</code> values changes due to 
	 * user interaction. 
	 * 
	 * @eventType flash.events.Event.CHANGE
	 */	
	[Event(name="change", type="flash.events.Event")]
	
//------------------------------------------
//  Skin states
//------------------------------------------
	
	/**
	 *  Normal State
	 */
	[SkinState("normal")]
	
	/**
	 *  Disabled State
	 */
	[SkinState("disabled")]
	
//------------------------------------------
//  Other Metadata
//------------------------------------------
	
	[DefaultProperty("selectedHSBColor")]
	
	/**
	 * The HSBColorWheel is default implementation of the HSB color for the 
	 * HSBColorPicker component.
	 * 
	 * <p></p>
	 * 
	 * <p>The HSBColorWheel control has the following default characteristics:</p>
	 *     <table class="innertable">
	 *        <tr>
	 *           <th>Characteristic</th>
	 *           <th>Description</th>
	 *        </tr>
	 *        <tr>
	 *           <td>Default size</td>
	 *           <td>200 pixels wide by 200 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Minimum size</td>
	 *           <td>50 pixels wide and 50 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Maximum size</td>
	 *           <td>10000 pixels wide and 10000 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Default skin class</td>
	 *           <td>watercolor.skins.HSBColorWheelSkin</td>
	 *        </tr>
	 *     </table>
	 * 
	 * @mxml
	 *
	 *  <p>The <code>&lt;s:HSBColorWheel&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:HSBColorWheel
	 *    <strong>Properties</strong>
	 *    selectedHSBColor=""
	 *  
	 *    <strong>Events</strong>
	 *    change="<i>No default</i>"
	 *      
	 *  /&gt;
	 *  </pre>
	 * 
	 * @see watercolor.components.IHSBColorWheel
	 * @see watercolor.components.HSBColorPicker
	 * @see watercolor.skins.HSBColorWheelSkin
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * @author Tyler Chesley
	 * 
	 */	
	public class HSBColorWheel extends SkinnableComponent implements IHSBColorWheel
	{
		
	//------------------------------------------------------------------------------
	//	Constructor
	//------------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */		
		public function HSBColorWheel()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		override public function set explicitHeight(value:Number):void
		{
			super.explicitHeight = value;
			trace("Called explicitHeight" + value);
		}
		
		override public function set explicitMaxHeight(value:Number):void
		{
			super.explicitMaxHeight = value;
			trace("Called explicitMaxHeight" + value);
		}
		
		override public function set explicitMinHeight(value:Number):void
		{
			super.explicitMinHeight = value;
			trace("Called explicitMinHeight" + value);
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			trace("Called height" + value);
		}
		
		override public function set minHeight(value:Number):void
		{
			super.minHeight = value;
			trace("Called minHeight" + value);
		}
		
		override public function set maxHeight(value:Number):void
		{
			super.maxHeight = value;
			trace("Called maxHeight" + value);
		}
		
	//------------------------------------------------------------------------------
	//	Skin Parts
	//------------------------------------------------------------------------------
		
		[SkinPart(required="true")]
		
		/**
		 * A skin part that displays the color wheel bitmap.
		 * 
		 * @see watercolor.components.supportClasses.ColorWheelBitmap
		 */		
		public var colorWheelDisplay:BitmapImage;
		
		[SkinPart(required="true")]
		
		/**
		 * A skin part that defines the selected color indicator.
		 * 
		 * <p>The <code>selectedColorIndicator</code> is positioned using the hue 
		 * and saturation values of the currently selected HSB color.</p>
		 */		
		public var selectedColorIndicator:IVisualElement;
		
	//------------------------------------------------------------------------------
	//	Properties
	//------------------------------------------------------------------------------
		
		/**
		 * @private
		 * Storage of the selectedColor property.
		 */		
		private var _selectedHSBColor:HSBColor;
		
		/**
		 * The currently selected HSB color.
		 * 
		 * <p>When this property changes it will also update the position of the 
		 * <code>selectedColorIndicator</code>.</p>
		 * 
		 */		
		public function get selectedHSBColor():HSBColor
		{
			return _selectedHSBColor;
		}
		
		/**
		 * @private
		 */		
		public function set selectedHSBColor(value:HSBColor):void
		{
			if (_selectedHSBColor == value)
				return;
			
			_selectedHSBColor = value;
			invalidateDisplayList();
		}
		
	//------------------------------------------------------------------------------
	//	Overriden Methods
	//------------------------------------------------------------------------------
		
		/**
		 *	@private
		 */
		override protected function getCurrentSkinState():String
		{
			return enabled ? "normal" : "disabled";
		}
		
		/**
		 * @private
		 */		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (colorWheelDisplay)
			{
				colorWheelDisplay.source = new ColorWheelBitmap(this.getExplicitOrMeasuredWidth() / 2);
			}
		}
		
		/**
		 * @private
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var radius:Number = unscaledWidth / 2;
			var rads:Number = selectedHSBColor.hue * (Math.PI / 180);
			var x:int = radius + (radius * selectedHSBColor.saturation) * Math.cos(rads);
			var y:int = radius + (radius * selectedHSBColor.saturation) * Math.sin(rads);
			
			if (selectedHSBColor.saturation == 0)
			{
				x = y = radius;
			}
			
			selectedColorIndicator.x = x - (selectedColorIndicator.width / 2);
			selectedColorIndicator.y = y - (selectedColorIndicator.height / 2);
			colorWheelDisplay.alpha = selectedHSBColor.brightness;
		}
		
	//------------------------------------------------------------------------------
	//	Event Handlers
	//------------------------------------------------------------------------------
		
		/**
		 * @private
		 */		
		private function mouseHandler(event:MouseEvent):void
		{
			var point:Point = globalToLocal(new Point(event.stageX, event.stageY));
			selectedHSBColor = HSBColorUtil.getHSBColor(point, unscaledWidth / 2, selectedHSBColor.brightness);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * @private
		 */		
		private function mouseDownHandler(event:MouseEvent):void
		{
			mouseHandler(event);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		/**
		 * @private
		 */		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			mouseHandler(event);
		}
		
		/**
		 * @private
		 */		
		private function mouseOutHandler(event:MouseEvent):void
		{
			mouseHandler(event);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		/**
		 * @private
		 */	
		private function mouseUpHandler(event:MouseEvent):void
		{
			mouseHandler(event);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
	}
}