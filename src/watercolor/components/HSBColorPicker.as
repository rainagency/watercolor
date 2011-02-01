package watercolor.components
{
	import flash.events.Event;
	
	import mx.utils.HSBColor;
	
	import spark.components.supportClasses.Range;
	import spark.components.supportClasses.SkinnableComponent;
	
//------------------------------------------
//	Events
//------------------------------------------
	
	/**
	 * Dispatched when the selectedHSBColor or selectedColor values changes. 
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
//	Other Metadata
//------------------------------------------
	
	[DefaultProperty("selectedColor")]
	
	/**
	 * The HSBColorPicker component is used to select colors using the 
	 * HSB representation of the RGB color model. 
	 * 
	 * <p>The HSBColorPicker consists of two components a color wheel and a range (a 
	 * VSlider by default). The color wheel is responsible for controlling the hue 
	 * and saturation comonponents of a HSB color. The range is responsible for 
	 * controlling the brightness component of a HSB color.</p>
	 * 
	 * <p>HSB is a common cylindrical-coordinate representation of the RGB color model. 
	 * Each color in HSB is broken into 3 components: hue, saturation and brightness. 
	 * Hue is mapped to the angle of the wheel with red starting at 0 degrees, 
	 * green at 120 degress and blue at 240 degrees. Saturation is controlled by 
	 * the distance from the center of the wheel with values ranging from 0 at the 
	 * center of the wheel to 100 at the outer edge of the wheel. In a cylindrical 
	 * representation of the RGB color model the brightness 
	 * value controls the depth at which the current slice of the cylindar 
	 * (the color wheel) is being drawn. The brightness component of an HSB 
	 * color can have a value of 0 - 100.</p>
	 * 
	 * <p>The HSBColorPicker control has the following default characteristics:</p>
	 *     <table class="innertable">
	 *        <tr>
	 *           <th>Characteristic</th>
	 *           <th>Description</th>
	 *        </tr>
	 *        <tr>
	 *           <td>Default size</td>
	 *           <td>Large enough to display the color wheel and brightness selector</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Minimum size</td>
	 *           <td>Large enough to display the color wheel and brightness selector</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Maximum size</td>
	 *           <td>10000 pixels wide and 10000 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Default skin class</td>
	 *           <td>watercolor.skins.HSBColorPickerSkin</td>
	 *        </tr>
	 *     </table>
	 * 
	 * @mxml
	 *
	 *  <p>The <code>&lt;s:HSBColorPicker&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:HSBColorPicker
	 *    <strong>Properties</strong>
	 *    selectedColor="0xFFFFFF"
	 *    selectedHSBColor="HSBColor"
	 *  
	 *    <strong>Events</strong>
	 *    change="<i>No default</i>"
	 *      
	 *  /&gt;
	 *  </pre>
	 * 
	 * @see watercolor.components.HSBColorWheel
	 * @see watercolor.components.IHSBColorWheel
	 * @see watercolor.skins.HSBColorPickerSkin
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * @author Tyler Chesley
	 * 
	 */	
	public class HSBColorPicker extends SkinnableComponent
	{
		
	//------------------------------------------------------------------------------
	//	Constructor
	//------------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */		
		public function HSBColorPicker()
		{
			super();
			
			selectedColor = 0xFFFFFF;
		}
		
	//------------------------------------------------------------------------------
	//	Skin Parts
	//------------------------------------------------------------------------------
		
		[SkinPart(required="true")]
		
		/**
		 * A skin part that defines a HSB color wheel. 
		 * 
		 * <p>The color wheel is responsible for controlling the hue and saturation 
		 * components of the HSB color space. Hue is mapped to the angle of the wheel 
		 * with red starting at 0 degrees, green at 120 degress and blue at 240 
		 * degrees. Saturation is controlled by the distance from the center of the 
		 * wheel with values ranging from 0 at the center of the wheel to 100 at 
		 * the outer edge of the wheel.</p>
		 * 
		 * @see watercolor.components.IHSBColorWheel
		 * @see watercolor.components.HSBColorWheel
		 */		
		public var colorWheel:IHSBColorWheel;
		
		[SkinPart(required="true")]
		
		/**
		 * A skin part that defines the brightness range for the HSB color space. 
		 * 
		 * <p>In a cylindrical representation of the RGB color model the brightness 
		 * value controls the depth at which the current slice of the cylindar 
		 * (the color wheel) is being drawn. The brightness component of an HSB 
		 * color can have a value of 0 - 100.</p>
		 * 
		 * @see spark.components.supportClasses.Range
		 */		
		public var brightnessSelector:Range;
		
	//------------------------------------------------------------------------------
	//	Properties
	//------------------------------------------------------------------------------
		
		/* hsbColor */
		
		/**
		 * @private
		 * Storage of the selectedHSBColor property.
		 */		
		private var _selectedHSBColor:HSBColor;
		
		/**
		 * @private
		 * Flag used to tell if the component needs to be updated.
		 */		
		private var _selectedHSBColorChanged:Boolean = false;
		
		[Bindable("change")]
		
		/**
		 * The currently selected HSB color.
		 * 
		 * <p>Setting this property will also update the <code>selectedColor</code>. 
		 * Conversion to HSB from RGB isn't exact and results in rounding errors 
		 * when converting back to RGB.</p>
		 * 
		 * @see #selectedColor
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
			_selectedHSBColorChanged = true;
			_selectedColor = HSBColor.convertHSBtoRGB(value.hue, value.saturation, value.brightness);
			
			invalidateProperties();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/* selectedColor */
		
		/**
		 * @private
		 * Storage of the selectedColor property.
		 */		
		private var _selectedColor:uint;
		
		[Bindable("change")]
		
		/**
		 * The currently selected color.
		 * 
		 * <p>Setting this property will also update the <code>selectedHSBColor</code>. 
		 * Conversion to HSB from RGB isn't exact and results in rounding errors 
		 * when converting back to RGB.</p>
		 * 
		 * @default 0xFFFFFF
		 * @see #selectedHSBColor
		 */		
		public function get selectedColor():uint
		{
			return _selectedColor;
		}
		
		/**
		 * @private
		 */		
		public function set selectedColor(value:uint):void
		{
			if (_selectedColor == value)
				return;
			
			_selectedColor = value;
			selectedHSBColor = HSBColor.convertRGBtoHSB(value);
		}
		
	//------------------------------------------------------------------------------
	//	Overriden Methods
	//------------------------------------------------------------------------------
		
		/**
		 * @private
		 */		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_selectedHSBColorChanged)
			{
				_selectedHSBColorChanged = false;
				brightnessSelector.value = selectedHSBColor.brightness * 100;
				brightnessSelector.setStyle("contentBackgroundColor", HSBColor.convertHSBtoRGB(selectedHSBColor.hue, selectedHSBColor.saturation, 1));
				colorWheel.selectedHSBColor = selectedHSBColor;
			}
		}
		
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
			
			if (instance == brightnessSelector)
			{
				// The brightness value can be anywhere between 100 and 0
				brightnessSelector.maximum = 100;
				brightnessSelector.minimum = 0;
				brightnessSelector.stepSize = 1;
				brightnessSelector.value = selectedHSBColor.brightness * 100;
				brightnessSelector.addEventListener(Event.CHANGE, changeHandler);
			}
			
			if (instance == colorWheel)
			{
				colorWheel.selectedHSBColor = selectedHSBColor;
				colorWheel.addEventListener(Event.CHANGE, changeHandler);
			}
		}
		
		/**
		 * @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == brightnessSelector)
			{
				brightnessSelector.removeEventListener(Event.CHANGE, changeHandler);
			}
			
			if (instance == colorWheel)
			{
				colorWheel.removeEventListener(Event.CHANGE, changeHandler);
			}
		}
		
	//------------------------------------------------------------------------------
	//	Event Handlers
	//------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function changeHandler(event:Event):void
		{
			var color:HSBColor = new HSBColor
			color.brightness = brightnessSelector.value / 100;
			color.hue = colorWheel.selectedHSBColor.hue;
			color.saturation = colorWheel.selectedHSBColor.saturation;
			selectedHSBColor = color;
		}
		
	}
}