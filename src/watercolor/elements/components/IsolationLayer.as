package watercolor.elements.components
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	import mx.controls.LinkButton;
	import mx.core.UIComponent;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import mx.utils.ObjectUtil;
	
	import org.osmf.display.ScaleMode;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.events.ElementExistenceEvent;
	
	import watercolor.commands.vo.CommandVO;
	import watercolor.commands.vo.GroupCommandVO;
	import watercolor.commands.vo.PropertyVO;
	import watercolor.elements.Element;
	import watercolor.elements.Group;
	import watercolor.elements.Path;
	import watercolor.elements.interfaces.IElementContainer;
	import watercolor.events.EditContourLayerEvent;
	import watercolor.events.IsolationLayerEvent;
	import watercolor.pathData.PathData;
	import watercolor.pathData.PathDataContour;
	import watercolor.utils.CoordinateUtils;
	import watercolor.utils.VisualElementUtil;


	/**
	 *  Dispatched when IsolationLayer enters into Isolation Mode.
	 *  <code>event.currentTarget</code> is the IsolationLayer.
	 *
	 *  @eventType watercolor.events.IsolationLayerEvent.ENTER_ISOLATION_MODE
	 *
	 */
	[Event(name="enterIsolationMode", type="watercolor.events.IsolationLayerEvent")]

	/**
	 *  Dispatched when IsolationLayer exits out of Isolation Mode.
	 *  <code>event.currentTarget</code> is the IsolationLayer.
	 *
	 *  @eventType watercolor.events.IsolationLayerEvent.EXIT_ISOLATION_MODE
	 *
	 */
	[Event(name="exitIsolationMode", type="watercolor.events.IsolationLayerEvent")]

	/**
	 *  Dispatched when IsolationLayer enters into Edit Contour Mode.
	 *  <code>event.currentTarget</code> is the IsolationLayer.
	 *
	 *  @eventType watercolor.events.IsolationLayerEvent.ENTER_EDIT_CONTOUR_MODE
	 *
	 */
	[Event(name="enterEditContourMode", type="watercolor.events.IsolationLayerEvent")]

	/**
	 *  Dispatched when IsolationLayer exits out of Edit Contour Mode.
	 *  <code>event.currentTarget</code> is the IsolationLayer.
	 *
	 *  @eventType watercolor.events.IsolationLayerEvent.EXIT_EDIT_CONTOUR_MODE
	 *
	 */
	[Event(name="exitEditContourMode", type="watercolor.events.IsolationLayerEvent")]


	/**
	 *
	 * @author mediarain
	 */
	public class IsolationLayer extends SkinnableContainer implements IElementContainer
	{


		[SkinPart(required="false")]
		/**
		 * The group where to place buttons for navigating the different levels of isolation
		 * @default
		 */
		public var trail:spark.components.Group = new spark.components.Group();


		[SkinPart(required="false")]
		/**
		 * The exit button for exiting isolation mode for all levels
		 * @default
		 */
		public var exitBtn:Button = new Button();


		[SkinPart(required="false")]
		/**
		 * A label to indicate the current level in isolation mode
		 * @default
		 */
		public var currentItem:Label = new Label();


		[SkinPart(required="false")]
		/**
		 * The button for separating and combing the child elements
		 * @default
		 */
		public var separateBtn:Button = new Button();


		[SkinPart(required="false")]
		/**
		 * The button for separating and combing the child elements
		 * @default
		 */
		public var combineBtn:Button = new Button();


		/**
		 * Optional value to help determine where to place objects on the screen
		 * This is helpful for scrolling.  You can use this to make the objects
		 * appear in the same place on the screen if scrolling in the viewport.
		 */
		[Bindable]
		public var viewPort:DisplayObject;


		[Bindable]
		public var contentGroupScaleX:Number = 1;


		[Bindable]
		public var contentGroupScaleY:Number = 1;


		private var oldParent:Object;


		private var oldIndex:int = 0;


		private var collection:Dictionary;


		private var _contourMode:Boolean = false;


		private var _contourPoint:Point;
		
		
		private var _contourMask:Path;


		public function get contourMode():Boolean
		{
			return _contourMode;
		}


		private var _separationPaddingX:Number = 0;


		/**
		 *
		 * @default
		 */
		public function get separationPaddingX():Number
		{
			return _separationPaddingX;
		}


		/**
		 * @private
		 */
		public function set separationPaddingX(value:Number):void
		{
			_separationPaddingX = value;
		}


		private var _separationPaddingY:Number = 0;


		/**
		 *
		 * @default
		 */
		public function get separationPaddingY():Number
		{
			return _separationPaddingY;
		}


		/**
		 * @private
		 */
		public function set separationPaddingY(value:Number):void
		{
			_separationPaddingY = value;
		}


		private var _separateText:String = "Separate";


		public function get separateText():String
		{
			return _separateText;
		}


		public function set separateText(value:String):void
		{
			_separateText = value;
		}


		private var _combineText:String = "Combine";


		public function get combineText():String
		{
			return _combineText;
		}


		public function set combineText(value:String):void
		{
			_combineText = value;
		}


		/**
		 *
		 * @default
		 */
		protected var isolationElements:Vector.<IElementContainer> = new Vector.<IElementContainer>;


		/**
		 *
		 * @default
		 */
		protected var currentChildElements:Vector.<Element>;


		override protected function getCurrentSkinState():String
		{
			return (isolationElements.length > 0) ? (_contourMode) ? "contourMode" : "normal" : "disabled";
		}


		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			switch(instance)
			{
				case trail:
					break;
				case exitBtn:
					exitBtn.addEventListener(MouseEvent.CLICK, exitBtnClicked, false, 0, true);
					break;
				case contentGroup:
					break;
				case separateBtn:
					separateBtn.addEventListener(MouseEvent.CLICK, separateGlyphs, false, 0, true);
					break;
				case combineBtn:
					combineBtn.addEventListener(MouseEvent.CLICK, combineGlyphs, false, 0, true);
					break;
				default:
					break;
			}
		}


		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			switch(instance)
			{
				case trail:
					break;
				case exitBtn:
					break;
				case contentGroup:
					break;
				case separateBtn:
					break;
				case combineBtn:
					break;
				default:
					break;
			}
			super.partRemoved(partName, instance);
		}


		/**
		 * Public function for entering isolation mode on the isolation layer for a given element
		 * @param element The element to use for isolation mode.
		 * This will basically grab all of the imediate children in the element and transfer them to the isolation layer
		 */
		public function enterIsolation(element:Element):void
		{

			// check if we are already in isolation mode and if so then undo the last one
			// this will basically move the group back to it's original layer
			// the rest of this function will then move the sub group of elements into the isolation layer
			exit();

			// move the group or sub-group to the isolation layer
			enter(element);
		}


		/**
		 * Public function for exiting the current layer in isolation mode.
		 */
		/*public function exitIsolation():void {

		   // exit the current isolation mode instance
		   // move the element's children from the isolation layer back to the element
		   exit(true);

		   // if there are more items in the isolation manager then execute the last one in the list
		   // this may be confusing but this is done to get the reverse effect of entering isolation mode
		   // this is important when going into multiple layers of isolation
		   if (isolationElements.length > 0) {
		   enter();
		   }
		 }*/

		/**
		 * Public function for jumping to a different level in the isolation hierarchy
		 * @param level The level to jump to
		 * To completely exit isolation mode, pass in a 0.
		 */
		public function exitToLevel(level:int):void
		{

			// copy the length of the number of elements in the isolation layer
			var lgth:int = trail.numElements;

			// remove any link buttons from the current level
			for(var x:int = level; x < lgth; x++)
			{
				trail.removeElementAt(level);
			}

			exit(true);

			// remove any elements from the current level
			isolationElements.splice(level, isolationElements.length - level);

			// if there are any levels left, then go into the last one
			if(isolationElements.length > 0)
			{
				enter();
			}
			else
			{
				dispatchEvent(new IsolationLayerEvent(IsolationLayerEvent.EXIT_ISOLATION_MODE));
			}
		}


		/**
		 * Public function to retrieve the number of elements in isolation mode
		 * This is really used for knowing if in isolation mode or how many levels deep
		 * @return
		 */
		public function elementLength():int
		{
			return isolationElements.length;
		}


		/**
		 * Function for retreiving the last element in the collection.
		 * @return
		 */
		public function get lastIsolatedElement():IElementContainer
		{
			if(isolationElements.length > 0)
			{
				return isolationElements[ isolationElements.length - 1 ];
			}
			else
			{
				return null;
			}
		}


		/**
		 * Function for retreiving the last element in the collection.
		 * @return
		 */
		public function get firstIsolatedElement():IElementContainer
		{
			return isolationElements[ 0 ];
		}
	

		/**
		 * public function for entering into isolation mode for a given element
		 * @param element The element for which we want to edit in isolation mode
		 */
		public function enter(element:Element = null):void
		{
			var m:Matrix;
			var newPoint:Point;
			var link:LinkButton;
			var group:watercolor.elements.Group;

			// if an element was passed in then we need to add it to the collection
			if(element)
			{
				isolationElements.push(element);

				// also create a link button for the breadcrumbs
				if(isolationElements.length > 1)
				{
					link = new LinkButton();
					link.label = Element(isolationElements[ isolationElements.length - 2 ]).name + "  >";
					link.addEventListener(MouseEvent.CLICK, handleLinkClick, false, 0, true);
					link.setStyle("skin", null);
					link.setStyle("color", "#FFFFFF");
					link.setStyle("textRollOverColor", "#333333");
					trail.addElement(link);
				}
			}

			clean();
			
			if(lastIsolatedElement)
			{
				_contourMode = !Boolean(lastIsolatedElement is watercolor.elements.Group && (lastIsolatedElement.numElements > 1 || (lastIsolatedElement.numElements == 1 && lastIsolatedElement.getElementAt(0) is watercolor.elements.Group)));
				oldParent = lastIsolatedElement.parent;
				
				if(!contourMode)
				{

					contentGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD, handleElementAdded, false, 0, true);
					contentGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, handleElementRemoved, false, 0, true);

					// enable the mouse for all children
					Element(lastIsolatedElement).mouseChildren = true;

					// since we only want the mouse enabled for imediate children only,
					// we now have to go through all children and make their children non mouse enabled
					for(var x:int = 0; x < lastIsolatedElement.numElements; x++)
					{
						(Element(lastIsolatedElement).getChildAt(x) as UIComponent).mouseChildren = false;
					}

					currentChildElements = new Vector.<Element>();

					// go through all the children in the element
					while(lastIsolatedElement.numElements > 0)
					{
						var child:Element = Element(lastIsolatedElement).getChildAt(0) as Element;
						
						adjustMatrix(lastIsolatedElement, child);
						
						// make a list of all child elements in isolation mode
						currentChildElements.push(child);

						// move the child element to the new parent
						addElement(child);
					}

					checkIfAllElementsAreTouching();

					dispatchEvent(new IsolationLayerEvent(IsolationLayerEvent.ENTER_ISOLATION_MODE));

				}
				else
				{
					oldIndex = lastIsolatedElement.parent.getChildIndex(Element(lastIsolatedElement));

					// remove any elements on the layer including any hit points
					removeAllElements();

					m = adjustMatrix(oldParent, lastIsolatedElement, false);
					
					// disable the mouse so that we can't transform it
					Element(lastIsolatedElement).mouseEnabled = false;
					
					if (Element(lastIsolatedElement).mask && Element(lastIsolatedElement).mask is Path)
					{
						_contourMask = Element(lastIsolatedElement).mask as Path;
						Element(lastIsolatedElement).mask = null;
					}

					// reset this dictionary collection
					collection = new Dictionary();

					// create and add to the display, the hit points
					createHitPoints(lastIsolatedElement, m);

					dispatchEvent(new IsolationLayerEvent(IsolationLayerEvent.ENTER_EDIT_CONTOUR_MODE));

				}

				// update the current item label on the isolation layer
				currentItem.text = Element(lastIsolatedElement).name;

				invalidateSkinState();
			}
			else
			{
				exit(true);
				
				if (isolationElements.length > 0)
				{
					enter();
				}
			}
		}
		
		private function clean():void
		{
			// go through each element and find ones that don't have a parent
			for each (var elm:Element in isolationElements)
			{
				if (!elm.parent)
				{
					// remove the link from the trail
					var index:int = isolationElements.indexOf(elm) - 1;					
					index = (index < 0) ? 0 : index; 
					
					if (trail.numElements > 0 && trail.getElementAt(index))
					{
						trail.removeElementAt(index);
					}
					
					// remove the element from the collection
					isolationElements.splice(isolationElements.indexOf(elm), 1);										
				}
			}
		}
		
		private function revertMatrix(correctParent:Object, child:Object):void
		{
			// copy the concatenated matrix for the child and for the element (old parent)
			var elmConcat:Matrix = correctParent.transform.concatenatedMatrix.clone();
			var childConcat:Matrix = child.transform.concatenatedMatrix.clone();
			
			// invert the old parent's concatenated matrix
			elmConcat.invert();
			
			// concat the inverted matrix to remove it from the child matrix
			childConcat.concat(elmConcat);
			
			// find the right x,y position for the element
			var newPoint:Point = CoordinateUtils.localToLocal(contentGroup, correctParent, new Point(child.x, child.y));
			
			childConcat.tx = newPoint.x;
			childConcat.ty = newPoint.y;
			
			// move the child back to the old parent
			child.transform.matrix = childConcat;	
		}
		
		private function adjustMatrix(previousParent:Object, child:Object, apply:Boolean = true):Matrix
		{
			// find the right x,y position for the element
			var newPoint:Point = CoordinateUtils.localToLocal(previousParent, contentGroup, new Point(child.x, child.y));
			
			// create a new matrix to get the concatenated matrix values for the child
			// this is so that when the child is added to the new parent, it will appear in the same
			// position that it was in the old parent
			var m:Matrix = new Matrix();
			m.tx = child.transform.matrix.tx;
			m.ty = child.transform.matrix.ty;
			
			m.a = child.transform.concatenatedMatrix.a;
			m.b = child.transform.concatenatedMatrix.b;
			m.c = child.transform.concatenatedMatrix.c;
			m.d = child.transform.concatenatedMatrix.d;
			
			m.scale(1 / contentGroupScaleX, 1 / contentGroupScaleY);
			
			m.tx = newPoint.x;
			m.ty = newPoint.y;
			
			if (apply)
			{					
				// apply the matrix to the child
				child.transform.matrix = m;
			}
			
			return m.clone();
		}


		private function handleElementAdded(event:ElementExistenceEvent):void
		{
			if(currentChildElements && currentChildElements.indexOf(event.element) == -1)
			{
				currentChildElements.push(event.element);
			}
		}


		private function handleElementRemoved(event:ElementExistenceEvent):void
		{
			if(currentChildElements && currentChildElements.indexOf(event.element) != -1)
			{
				currentChildElements.splice(currentChildElements.indexOf(event.element), 1);
			}
		}


		/**
		 * public function to exit isolation mode for the last element in the list
		 * @param remove Whether or not to remove the last element from the collection
		 */
		public function exit(remove:Boolean = false, dispatchEvents:Boolean = true):void
		{
			var newPoint:Point;
			var elmConcat:Matrix;
			var childConcat:Matrix;
			var child:Element;
			var ievent:IsolationLayerEvent;
			var vec:Vector.<Element>;

			contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD, handleElementAdded);
			contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE, handleElementRemoved);

			// if there is at least one element in the collection
			if(lastIsolatedElement)
			{
				if (lastIsolatedElement.parent)
				{			
					if(!_contourMode)
					{
						Element(lastIsolatedElement).mouseChildren = false;
	
						// go through all the children in the element
						for each(var elm:Element in currentChildElements)
						{	
							revertMatrix(lastIsolatedElement, elm);
							
							// move the child element to the original parent
							lastIsolatedElement.addElement(elm);
						}
						
						vec = new Vector.<Element>();
						vec.push(lastIsolatedElement);
						
						ievent = new IsolationLayerEvent(IsolationLayerEvent.EXIT_ISOLATION_MODE_LEVEL, null, vec);
					}
					else
					{							
						// remove any elements from the layer
						removeAllElements();
	
						// reset the mask
						Element(lastIsolatedElement).mask = _contourMask;
	
						// re-enable the mouse on the element
						Element(lastIsolatedElement).mouseEnabled = true;
						
						// find all of the path objects in the element
						for(var x:int = 0; x < lastIsolatedElement.numElements; x++)
						{							
							child = lastIsolatedElement.getElementAt(x) as Element;
							
							// make sure the child is a path object and turn it back on
							if(child is Path)
							{								
								Path(child).visible = true;
							}
						}
						
						collection = null;
						
						vec = new Vector.<Element>();
						vec.push(lastIsolatedElement);
						
						ievent = new IsolationLayerEvent(IsolationLayerEvent.EXIT_EDIT_CONTOUR_MODE_LEVEL, null, vec);
					}
				}

				// if we want to remove the last element from the collection
				if(remove)
				{
					if(isolationElements.indexOf(lastIsolatedElement) != -1)
					{
						isolationElements.splice(isolationElements.indexOf(lastIsolatedElement), 1);
					}

					// check the breadcrumb trail and remove the last item in the list
					if(trail.numElements > 0)
					{
						trail.removeElementAt(trail.numElements - 1);
					}

					// clear the current item text
					currentItem.text = "";
				}
				
				if (dispatchEvents && ievent)
				{
					dispatchEvent(ievent);
				}
			}
			else
			{
				// clear the current item text
				currentItem.text = "";
			}

			removeAllElements();
			invalidateSkinState();
		}


		/**
		 * public function for separating all child elements that are in isolation mode
		 * This function will align the elements in a grid.  It goes in order from the biggest
		 * element to the smallest.  It starts off by creating a column and aligning elements
		 * down the column.  Once it has reached a certain height, then it will begin a new
		 * column.
		 * @return A command vo that stores what changes were made.  This is returned so that
		 * it can be placed into a history manager.
		 */
		public function separate():Dictionary
		{
			var rectTemp:Rectangle;
			var obj:Object;		
			var totalArea:Number = 0;
			var space:Array = new Array();
			
			// go through each element contained in isolation mode
			for each(obj in currentChildElements)
			{
				// get the color bounds rectangle
				rectTemp = VisualElementUtil.getColorBoundsRect(obj as Element, contentGroup);

				// calculate the area and add that to a total count
				totalArea += (rectTemp.width * rectTemp.height);

				// keep track of the element and it's color bound rectangle 
				space.push({ element:obj, rect:rectTemp });
			}

			// sort the list of elements from the biggest to the smallest
			space.sort(sortRects);

			var temp:Point = CoordinateUtils.localToLocal(oldParent, contentGroup, new Point(lastIsolatedElement.x, lastIsolatedElement.y));
			
			var xpos:Number = temp.x;
			var ypos:Number = temp.y;

			var heightMax:Number = Math.sqrt(totalArea);
			var widthMax:Number = 0;

			var chart:Array = new Array();

			// go through each rectangle that was calculated from each element
			for each(obj in space)
			{
				// if the current y position added with the current element's height
				// is greater than the cut off for the height then start a new column
				if(ypos + obj.element.height >= heightMax)
				{
					// offset the x position to the widest element 
					// in the column with the x padding
					xpos += (widthMax + separationPaddingX);

					// reset the y position and the widest element
					ypos = temp.y;
					widthMax = 0;
				}

				// keep a list of elements and the adjusted x and y positions
				chart.push({ element:obj.element, x:xpos + (obj.element.x - obj.rect.x), y:ypos + (obj.element.y - obj.rect.y)});

				// offset the y position by adding the element's height
				// with the y padding
				ypos += (obj.rect.height + separationPaddingY);

				// if the current element's width is wider than the current widest element
				// then set the current widest width to that element's width
				if(obj.rect.width > widthMax)
				{
					widthMax = obj.rect.width;
				}
			}

			var offset:Rectangle = VisualElementUtil.getElementsRectangle(currentChildElements, contentGroup);

			var dict:Dictionary = new Dictionary();
			
			var preventOffMatX:Number = 0;
			
			// now go through each element in the list of x and y offsets
			for each(obj in chart)
			{
				var m:Matrix = obj.element.transform.matrix.clone();
				m.tx = (obj.x -= (((xpos + widthMax + separationPaddingX) - temp.x) - offset.width) / 2);
				m.ty = obj.y;
				
				// Prevent going off mat to the left.
				if (m.tx < preventOffMatX )
				{
					preventOffMatX = m.tx;
				}
				
				m.tx += (-1 * preventOffMatX); 
				
				dict[ obj.element ] = { matrix:obj.element.transform.matrix.clone(), concatenatedMatrix:obj.element.transform.concatenatedMatrix.clone()};
				
				obj.element.transform.matrix = m;								
			}

			// return the command
			return dict;
		}


		/**
		 * public function combining back all of the elements in isolation mode
		 * this function will return all of the elements back to their original
		 * x,y position when the group was original put together.
		 * @return A command vo that stores what changes were made.  This is returned so that
		 * it can be placed into a history manager.
		 */
		public function combine():Dictionary
		{
			var dict:Dictionary = new Dictionary();
			var m:Matrix;
			var newPoint:Point;
			var test:Point;
			
			// go through all of the children contained in isolation mode
			for each(var child:Object in currentChildElements)
			{
				if (child.childMatrix)
				{
					dict[child] = { matrix:child.transform.matrix.clone(), concatenatedMatrix:child.transform.concatenatedMatrix.clone(), useChildMatrix:true};	
				}
			}

			// return the command
			return dict;
		}


		/**
		 * handler function for when the separate button is clicked on while in combine mode
		 */
		private function combineGlyphs(event:MouseEvent):void
		{
			combineBtn.enabled = false;
			separateBtn.enabled = true;

			// combine the elements and dispatch an event to indicate that this has happened with the command vo
			dispatchEvent(new IsolationLayerEvent(IsolationLayerEvent.GLYPH_COMBINED, combine(), currentChildElements));
		}


		/**
		 * handler function for when the separate button is clicked on while in separate mode
		 */
		private function separateGlyphs(event:MouseEvent):void
		{
			separateBtn.enabled = false;
			combineBtn.enabled = true;

			// separate the elements and dispatch an event to indicate that this has happened with the command vo
			dispatchEvent(new IsolationLayerEvent(IsolationLayerEvent.GLYPH_SEPERATED, separate(), currentChildElements));
		}


		/**
		 * public function that can be called anytime to check if the elements in isolation mode are all touching or not
		 */
		public function checkIfAllElementsAreTouching():void
		{
			separateBtn.enabled = false;
			combineBtn.enabled = false;

			// check if not all of the elements are touching
			if(!(VisualElementUtil.getTouchingElements(currentChildElements).length == currentChildElements.length))
			{

				// now go through and compare the child matrix with the current matrix to see if anything has changed
				var different:Boolean = false;
				for each(var elm:Element in currentChildElements)
				{
					if(!compareMatricies(elm.childMatrix, elm.transform.matrix))
					{
						different = true;
						break;
					}
				}

				// if something is not different
				if(!different)
				{
					separateBtn.enabled = true;
				}
				else
				{
					combineBtn.enabled = true;
				}
			}
			else
			{
				separateBtn.enabled = true;
			}
		}


		/**
		 * private function for sorting rectangles from biggest to smallest
		 */
		private function sortRects(a:Object, b:Object):Number
		{

			// if a rectangle's surface area is greater than another rectangle's surface area
			// then place it before the other rectangle
			// in other words place rectangle (a) before rectangle (b)
			if(a.rect.height * a.rect.width > b.rect.height * b.rect.width)
			{
				return -1;

					// else place rectangle (b) before rectangle (a)
			}
			else
			{
				return 1;
			}
		}


		/**
		 * Helper function for determining if two matricies have the same values
		 * If any of the values are different then this function will return false
		 */
		private function compareMatricies(m1:Matrix, m2:Matrix):Boolean
		{
			if((m1 && m2) && (m1.a != m2.a || m1.b != m2.b || m1.c != m2.c || m1.d != m2.d || m1.tx.toFixed(5) != m2.tx.toFixed(5) || m1.ty.toFixed(5) != m2.ty.toFixed(5)))
			{
				return false;
			}
			else
			{
				return true;
			}
		}


		/**
		 * Handler function for when a link button is clicked on
		 */
		private function handleLinkClick(event:MouseEvent):void
		{
			exitToLevel(event.currentTarget.parent.getChildIndex(event.currentTarget) + 1);
		}


		/**
		 * Handler function for when the exit button is clicked on
		 */
		private function exitBtnClicked(event:MouseEvent):void
		{
			exitToLevel(0);
		}


		/**
		 * Private function for creating the path overlays to act as hit points
		 */
		private function createHitPoints(element:IElementContainer, m:Matrix):void
		{

			var path:Path;
			var border:Path;
			var newPoint:Point;
			var child:Element;

			// find all of the path objects in the element
			for(var x:int = 0; x < element.numElements; x++)
			{
				child = element.getElementAt(x) as Element;

				// make sure the child is a path object
				if(child is Path)
				{

					Path(child).visible = false;
					
					// clone the path data so that it won't change in memory
					var pathDataClone:PathData = Path(child).pathData.clone();
					
					// go through each contour
					for each(var obj:PathDataContour in pathDataClone.pathCountours.source.reverse())
					{

						// create a new path for the contour
						path = new Path();
						path.mouseEnabled = false;
						path.data = obj.toString(true);
						path.fill = new SolidColor(0x000000);

						// create a non watercolor group to hold the path created above
						// we use a spark group because we only to listen for a mouse click
						var group:spark.components.Group = new spark.components.Group();
						group.mask = path;
						group.mouseChildren = false;
						group.addEventListener(MouseEvent.CLICK, pathClicked);
						group.addEventListener(MouseEvent.MOUSE_OVER, pathRolledOver);
						group.addEventListener(MouseEvent.MOUSE_OUT, pathRolledOut);
						group.addElement(path);
				
						var tp:Point = m.transformPoint(new Point(child.x, child.y));
						m.tx = tp.x;
						m.ty = tp.y;
						
						group.transform.matrix = m;

						// add the group (hit box) to the screen
						addElement(group);

						// add the hit box and the child element to the dictionary collection
						// so that this information can be accessed later
						collection[group] = {child:child, pathData:pathDataClone, contour:obj};

						// create a border to display
						var borderPath:Path = new Path();
						borderPath.mouseEnabled = false;
						borderPath.data = obj.toString(true);
						borderPath.stroke = new SolidColorStroke(0x000000, 2.2, 1, true, ScaleMode.NONE);
						group.addElement(borderPath);
						
						// if the contour has already been set to be hidden
						// then draw a border in the hit box
						if(!obj.visible)
						{
							borderPath.stroke = new SolidColorStroke(0x000000, 2.2, 0.3, true, ScaleMode.NONE);
						}

						/*var borderPath:Path = new Path();
						   borderPath.mouseEnabled = false;
						   borderPath.data = obj.toString(true);
						   borderPath.stroke = new SolidColorStroke(0xFF0000, 1, 1);
						 group.addElement(borderPath);*/
					}

					pathDataClone.pathCountours.source.reverse();
				}
				else if(child is watercolor.elements.Group) // else the element is a group so call this same function recursively to look for more paths
				{
					var nm:Matrix = child.transform.matrix.clone();
					nm.concat(m);
					createHitPoints(watercolor.elements.Group(child), nm);
				}
			}
		}

		private function pathRolledOver(event:MouseEvent):void
		{
			var group:spark.components.Group = event.currentTarget as spark.components.Group;				
			SolidColorStroke(Path(group.getElementAt(group.numElements - 1)).stroke).color = (collection[ event.currentTarget ].contour.visible) ? 0xFF0000 : 0xFF0000;
		}
		
		private function pathRolledOut(event:MouseEvent):void
		{
			var group:spark.components.Group = event.currentTarget as spark.components.Group;
			SolidColorStroke(Path(group.getElementAt(group.numElements - 1)).stroke).color = 0x00000;			
		}
		
		/**
		 * Handler function for when one of the hit points is clicked
		 */
		private function pathClicked(event:MouseEvent):void
		{

			var path:Path;
			var prop:CommandVO;

			var contour:PathDataContour = collection[ event.currentTarget ].contour;

			var count:int = 0;
			var total:int = 0;
			for each(var obj:Object in collection)
			{
				total++;
				if(!obj.contour.visible)
				{
					count++;
				}
			}

			path = event.currentTarget.getElementAt(event.currentTarget.numElements - 1);
			
			// if the contour is being shown
			if(contour.visible && count < total - 1)
			{
				path.data = contour.toString();
				path.stroke = new SolidColorStroke(0xFF0000, 2.2, 0.3, true, ScaleMode.NONE);
				path.fill = new SolidColor(0xffffff, 0);
				
				// get the propertyVO and execute it
				prop = createPropertyVO(event.currentTarget as spark.components.Group, contour, false);

				// dispatch an event to inidicate that the contour has been hidden
				dispatchEvent(new EditContourLayerEvent(EditContourLayerEvent.CONTOUR_HIDDEN, prop));
			}
			else // else the contour is already hidden
			{

				path.stroke = new SolidColorStroke(0xFF0000, 2.2, 1, true, ScaleMode.NONE);
				
				// get the propertyVO and execute it
				prop = createPropertyVO(event.currentTarget as spark.components.Group, contour, true);

				// dispatch an event to inidicate that the contour has been unhidden
				dispatchEvent(new EditContourLayerEvent(EditContourLayerEvent.CONTOUR_UNHIDDEN, prop));
			}
		}


		/**
		 * Private function for creating a propertyVO
		 */
		private function createPropertyVO(target:spark.components.Group, contour:PathDataContour, visible:Boolean):CommandVO
		{
			var group:GroupCommandVO = new GroupCommandVO();
						
			// create a new propertyVO and set the element
			var prop:PropertyVO = new PropertyVO();
			prop.element = collection[ target ].child;

			// record the current state of the data array
			prop.originalProperties = new Object();
			registerClassAlias("watercolor.pathData.PathData", watercolor.pathData.PathData);
			prop.originalProperties["pathData"] = ObjectUtil.copy(collection[target].child.pathData);
			
			// change whether or not the contour is visible
			contour.visible = visible;
			
			// record the changed state of the data array
			prop.newProperties = new Object();
			prop.newProperties["pathData"] = PathData(collection[target].pathData).clone();

			group.addCommand(prop);
						
			// now set it up so that the mask will also be updated
			prop = new PropertyVO();
			prop.originalProperties = new Object();
			prop.newProperties = new Object();
			prop.element = Element(lastIsolatedElement);
			
			var newPath:Path = new Path();
			newPath.pathData = ObjectUtil.copy(collection[target].pathData) as PathData;
			newPath.fill = new SolidColor(0xFFFFFF);
			newPath.mouseEnabled = false;
			
			prop.originalProperties["mask"] = _contourMask;
			prop.newProperties["mask"] = newPath;
			
			group.addCommand(prop);
			
			_contourMask = newPath;
			
			// return the commandVO
			return group;
		}
	}
}