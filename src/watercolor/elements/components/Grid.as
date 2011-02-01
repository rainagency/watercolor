package watercolor.elements.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextRotation;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ScrollEvent;
	
	import spark.components.Group;
	import spark.components.RichText;
	import spark.components.Scroller;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.Graphic;


	/**
	 * Grid/Rulers Component
	 *
	 * @author Sean T.
	 */
	public class Grid extends SkinnableContainer
	{

		//Skin Components
		[SkinPart(required="false")]
		public var gridLayer:Group;

		[SkinPart(required="false")]
		public var leftRulerLayer:Group;

		[SkinPart(required="false")]
		public var topRulerLayer:Group;

		[SkinPart(required="false")]
		public var rightRulerLayer:Group;

		[SkinPart(required="false")]
		public var bottomRulerLayer:Group;

		[SkinPart(required="false")]
		public var viewportScroller:Scroller;

		// public properties
		public var isDrawn:Boolean = false;

		//Grid settings
		private var _gridColor:uint = 0xBBBBBB;
		private var _textColor:uint = 0xBBBBBB;
		private var _gridAlpha:Number = .65;
		private var _gridDPI:Number = 72;
		private var _drawInch:Boolean = true;
		private var _drawInchText:Boolean = true;
		private var _drawCM:Boolean = true;
		private var _drawCMText:Boolean = true;
		private var _textSizeInches:uint = 10;
		private var _textSizeCM:uint = 9;

		//Components
		private var grid:UIComponent = new UIComponent();
		private var leftRuler:UIComponent = new UIComponent();
		private var topRuler:UIComponent = new UIComponent();
		private var rightRuler:UIComponent = new UIComponent();
		private var bottomRuler:UIComponent = new UIComponent();

		//Shapes 
		private var gridShape:Shape = new Shape();
		private var topRulerShape:Shape = new Shape();
		private var rightRulerShape:Shape = new Shape();
		private var bottomRulerShape:Shape = new Shape();
		private var leftRulerShape:Shape = new Shape();

		//Positions
		private var topRulerPosition:Point;
		private var leftRulerPosition:Point;


		/**
		 * The grid's color, used for lines, and text
		 */
		public function get gridColor():uint
		{
			return _gridColor;
		}


		public function set gridColor(color:uint):void
		{
			_gridColor = color;
			redraw();
		}


		/**
		 * Grid's dots per inch
		 */
		public function get dpi():uint
		{
			return _gridDPI;
		}


		public function set dpi(dpi:uint):void
		{
			_gridDPI = dpi;
			redraw();
		}


		/**
		 * Grid's dots per centimeter
		 */
		public function get dpcm():uint
		{
			return _gridDPI / 2.54;
		}


		public function set dpcm(dpcm:uint):void
		{
			_gridDPI = dpcm * 2.54;
			redraw();
		}
		
		/**
		 * Text Color
		 */ 
		public function get textColor():uint
		{
			return _textColor;
		}
		
		
		public function set textColor(color:uint):void
		{
			if (color != _textColor)
			{
				_textColor = color;
				redraw();
			}
		}
		
		/**
		 * Text Size for Inches
		 */ 
		public function get textSizeInches():int
		{
			return _textSizeInches;
		}
		
		
		public function set textSizeInches(value:int):void
		{
			if (value != _textSizeInches)
			{
				_textSizeInches = value;
				redraw();
			}
		}
		
		/**
		 * Text Size for Centimeters
		 */ 
		public function get textSizeCM():int
		{
			return _textSizeCM;
		}
		
		
		public function set textSizeCM(value:int):void
		{
			if (value != _textSizeCM)
			{
				_textSizeCM = value;
				redraw();
			}
		}


		/**
		 * Check if the grid is already drawn, if so, then redraw.
		 */
		public function redraw():void
		{
			if (isDrawn)
			{
				drawGrid();
			}
		}
		
		/**
		 * Clears Grid
		 */
		public function clearGrid():void
		{
			//Clear Graphics
			gridShape.graphics.clear();
			leftRulerShape.graphics.clear();
			topRulerShape.graphics.clear();
			rightRulerShape.graphics.clear();
			bottomRulerShape.graphics.clear();

			//Remove all text/ruler containers
			if (isDrawn)
			{
				gridLayer.removeElement(grid);
				leftRulerLayer.removeAllElements();
				topRulerLayer.removeAllElements();
				rightRulerLayer.removeAllElements();
				bottomRulerLayer.removeAllElements();
			}

			//Create new text/ruler containers
			grid = new UIComponent();
			leftRuler = new UIComponent();
			topRuler = new UIComponent();
			rightRuler = new UIComponent();
			bottomRuler = new UIComponent();

			//Attach new shapes to containers
			grid.addChild(gridShape);
			leftRuler.addChild(leftRulerShape);
			topRuler.addChild(topRulerShape);
			rightRuler.addChild(rightRulerShape);
			bottomRuler.addChild(bottomRulerShape);

			//Attach new containers to layers
			gridLayer.addElement(grid);
			leftRulerLayer.addElement(leftRuler);
			topRulerLayer.addElement(topRuler);
			rightRulerLayer.addElement(rightRuler);
			bottomRulerLayer.addElement(bottomRuler);

			//Clear Positions
			topRulerPosition = null;
			leftRulerPosition = null;

			isDrawn = false;
		}


		/**
		 * Draw grid
		 */
		public function drawGrid():void
		{
			//Clean all grid graphics
			clearGrid();

			/*
			   Vertical Inches Grid Lines / Top/Bottom Inch Text
			 */
			var gridX:Number = _gridDPI;
			var inch:uint = 1;

			while (gridX < width)
			{
				//Set line weight/color/alpha
				if (gridX == width * .5)
				{
					//Halfway Line
					gridShape.graphics.lineStyle(3, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
				}
				else if (gridX == width * .25 || gridX == width * .75)
				{
					//Quarterway Line
					gridShape.graphics.lineStyle(2, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
				}
				else
				{
					//Normal Line
					gridShape.graphics.lineStyle(1, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
				}

				//Draw number's text
				if (_drawInchText)
				{
					//Top Inch Text
					var topInchText:TextLine = createTextLine(inch.toString(), 0, textSizeInches);
					topInchText.x = gridX - Math.ceil(topInchText.textWidth / 2);
					topInchText.y = -3; // - Math.ceil(topInchText.height / 2) - 2;
					topRuler.addChild(topInchText);

					//Bottom Inch Text
					var bottomInchText:TextLine = createTextLine(inch.toString(), 0, textSizeInches);
					bottomInchText.x = gridX - Math.ceil(bottomInchText.textWidth / 2);
					bottomInchText.y = height + 1 + Math.ceil(bottomInchText.textHeight);
					bottomRuler.addChild(bottomInchText);
				}

				//Draw Inch Marks
				if (_drawInch)
				{
					gridShape.graphics.moveTo(gridX, 0);
					gridShape.graphics.lineTo(gridX, height);
				}

				//Move to next position
				gridX += _gridDPI;
				inch++;
			}
			/*
			   Horizontal Inches Grid Lines / Left/Right Inch Text
			 */
			var gridY:Number = _gridDPI;
			inch = 1;

			while (gridY < height)
			{
				if (gridY == height * .5)
				{
					//Halfway Line
					gridShape.graphics.lineStyle(3, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
				}
				else if (gridY == height * .25 || gridY == height * .75)
				{
					//Quarterway Line
					gridShape.graphics.lineStyle(2, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
				}
				else
				{
					//Normal Line
					gridShape.graphics.lineStyle(0, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
				}
				if (_drawInchText)
				{
					//Left Inch Text
					var leftInchText:TextLine = createTextLine(inch.toString(), 90, textSizeInches);
					leftInchText.x = 0 - Math.ceil(leftInchText.textHeight);
					leftInchText.y = gridY - Math.ceil(leftInchText.textWidth / 2);
					leftRuler.addChild(leftInchText);

					//Right Inch Text
					var rightInchText:TextLine = createTextLine(inch.toString(), 270, textSizeInches);
					rightInchText.x = width + Math.ceil(rightInchText.textHeight);
					rightInchText.y = gridY + Math.ceil(leftInchText.textWidth / 2);
					rightRuler.addChild(rightInchText);
				}

				//Draw Inch Marks
				if (_drawInch)
				{
					gridShape.graphics.moveTo(0, gridY);
					gridShape.graphics.lineTo(width, gridY);
				}

				//Move to next position
				gridY += _gridDPI;
				inch++;
			}

			/*
			   Vertical CM Ruler Lines / Top/Bottom CM Text
			 */
			var cm:uint = 1;
			gridX = dpcm / 2;

			while (gridX < width)
			{
				if (gridX % dpcm == 0)
				{
					//Normal line style
					topRulerShape.graphics.lineStyle(2, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
					bottomRulerShape.graphics.lineStyle(2, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
					if (_drawCMText && gridX >= dpcm * 2 && gridX <= width - dpcm * 1.5)
					{
						//Top CM Text
						var topCMText:TextLine = createTextLine(cm.toString(), 0, textSizeCM);
						topCMText.x = gridX - Math.ceil(topCMText.textWidth / 2);
						topCMText.y = 12 + topCMText.textHeight;
						topRuler.addChild(topCMText);

						//Bottom CM Text
						var bottomCMText:TextLine = createTextLine(cm.toString(), 0, textSizeCM);
						bottomCMText.x = gridX - Math.ceil(bottomCMText.textWidth / 2);
						bottomCMText.y = height - 2 - bottomCMText.textHeight;
						bottomRuler.addChild(bottomCMText);
					}

					//Move to next position
					cm++;
				}
				else
				{
					//Halway line style
					topRulerShape.graphics.lineStyle(1, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
					bottomRulerShape.graphics.lineStyle(1, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
				}

				//Draw CM Marks
				if (_drawCM)
				{
					//Top
					topRulerShape.graphics.moveTo(gridX, 0);
					topRulerShape.graphics.lineTo(gridX, 10);

					//Bottom
					bottomRulerShape.graphics.moveTo(gridX, height);
					bottomRulerShape.graphics.lineTo(gridX, height - 10);
				}

				//Move to next position
				gridX += dpcm / 2;
			}

			/*
			   Horizontal CM Ruler Lines / Left/Right CM Text
			 */
			gridY = dpcm / 2;
			cm = 1;

			while (gridY < height)
			{
				if (gridY % dpcm == 0)
				{
					//Normal line style
					leftRulerShape.graphics.lineStyle(2, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
					rightRulerShape.graphics.lineStyle(2, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
					if (_drawCMText && gridY >= dpcm * 2 && gridY <= height - dpcm * 1.5)
					{
						//Left CM Text
						var leftCMText:TextLine = createTextLine(cm.toString(), 90, textSizeCM);
						leftCMText.x = 12;
						leftCMText.y = gridY - Math.floor(leftCMText.textWidth / 2);
						leftRuler.addChild(leftCMText);

						//Right CM Text
						var rightCMText:TextLine = createTextLine(cm.toString(), 270, textSizeCM);
						rightCMText.x = width - 12;
						rightCMText.y = gridY + Math.floor(leftCMText.textWidth / 2);
						rightRuler.addChild(rightCMText);
					}

					//Move to next position
					cm++;
				}
				else
				{
					//Halway line style
					leftRulerShape.graphics.lineStyle(1, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
					rightRulerShape.graphics.lineStyle(1, _gridColor, _gridAlpha, true, LineScaleMode.NONE, CapsStyle.NONE);
				}

				//Draw CM Marks
				if (_drawCM)
				{
					//Left
					leftRulerShape.graphics.moveTo(0, gridY);
					leftRulerShape.graphics.lineTo(10, gridY);

					//Right
					rightRulerShape.graphics.moveTo(width, gridY);
					rightRulerShape.graphics.lineTo(width - 10, gridY);
				}

				//Move to next position
				gridY += dpcm / 2;
			}

			/*
			   Figure out new true positions and attach handlers to the scrollers.

			   This is used to watch for pan, zoom, and basic scrolling.
			   It will make the rulers follow you.
			 */
			leftRulerPosition = getTruePosition(leftRulerLayer, document.parent);
			topRulerPosition = getTruePosition(topRulerLayer, document.parent);

			//Inch texts aren't calculated into the position, so we need to subtract them +  for padding
			leftRulerPosition.x += topInchText.y - topInchText.textHeight;
			topRulerPosition.y += topInchText.y - topInchText.textHeight;

			BindingUtils.bindSetter(handleHorizontalScroll, document.viewport, 'horizontalScrollPosition');
			BindingUtils.bindSetter(handleVerticalScroll, document.viewport, 'verticalScrollPosition');

			isDrawn = true;
		}


		/**
		 * Horizontal Scroll handler
		 *
		 * This will move the left ruler with the scroll.
		 *
		 * @param x The horizontalScrollPosition
		 */
		private function handleHorizontalScroll(x:Number):void
		{
			//Adjust for zooming
			x = x / document.parent.documentScale;

			//Only move ruler if ruler is in trouble of being moved off screen
			if (x > leftRulerPosition.x)
			{
				leftRulerLayer.left = x - (leftRulerPosition.x);
			}
			else
			{
				leftRulerLayer.left = 0;
			}
		}


		/**
		 * Vertical Scroll handler
		 *
		 * This will move the top ruler with the scroll.
		 *
		 * @param y The verticalScrollPosition
		 */
		private function handleVerticalScroll(y:Number):void
		{
			//Adjust for zooming
			y = y / document.parent.documentScale;

			//Only move ruler if ruler is in trouble of being moved off screen
			if (y > topRulerPosition.y)
			{
				topRulerLayer.top = y - (topRulerPosition.y);
			}
			else
			{
				topRulerLayer.top = 0;
			}
		}


		/**
		 * Helper function to calculate the total offset between a child and one of it's ancestors
		 *
		 * @param child Child Element
		 * @param parent Parent Element
		 *
		 * @return A point containing the x/y off the offset.
		 */
		private function getTruePosition(child:*, parent:*):Point
		{
			var currentParent:* = child;
			var point:Point = new Point();

			while (currentParent != parent && currentParent.parent != null)
			{
				point.x += currentParent.getLayoutBoundsX();
				point.y += currentParent.getLayoutBoundsY();
				currentParent = currentParent.parent;
			}

			return point;
		}


		/**
		 * Creates the text elements that are used in the rulers.
		 *
		 * @param text The text to be used
		 * @param rotation The rotation of the text
		 * @param fontSize The font size of the text
		 *
		 * @return A formatted textline element.
		 */
		private function createTextLine(text:String, rotation:uint = 0, fontSize:uint = 12):TextLine
		{
			var format:ElementFormat = new ElementFormat();
			format.fontDescription = new FontDescription("Arial");
			format.fontSize = fontSize;
			format.color = textColor;

			var textBlock:TextBlock = new TextBlock();
			textBlock.content = new TextElement(text, format);

			var line:TextLine = textBlock.createTextLine(null, 300);
			line.rotation = rotation;

			return line;
		}
	}
}