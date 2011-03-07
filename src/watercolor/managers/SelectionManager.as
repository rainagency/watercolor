package watercolor.managers
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import watercolor.elements.Element;
	import watercolor.elements.Layer;
	import watercolor.elements.components.Workarea;
	import watercolor.elements.interfaces.IElementContainer;
	import watercolor.events.ElementSelectionEvent;
	import watercolor.events.SelectionManagerEvent;

	/**
	 * The Selection Manager manages the objects that are selected on the screen
	 *
	 * @author Jeremiah Stephenson
	 * @author Sean Thayne
	 */
	public class SelectionManager extends EventDispatcher
	{

		/**
		 * Constructor for setting the work area and creating a new vector array
		 *
		 */
		public function SelectionManager( workarea:Workarea )
		{
			this._workarea = workarea;
			_elements = new Vector.<Element>();
		}


		/**
		 * @private
		 */
		protected var _elements:Vector.<Element>;


		/**
		 * 
		 * @default 
		 */
		protected var _workarea:Workarea;


		/**
		 * A function for retrieving a list of elements that are selected
		 * @return list of elements
		 */
		public function get elements():Vector.<Element>
		{
			return _elements;
		}


		/**
		 * 
		 * @param angle
		 * @param fromOrigin
		 */
		public function rotateElements( angle:Number, fromOrigin:Boolean = false ):void
		{
			_workarea.selectionLayer.transformLayer.rotateElements( angle, fromOrigin );
		}

		/**
		 * 
		 * @param scaleX
		 * @param scaleY
		 */
		public function scaleElements( anchor:String, scaleX:Number, scaleY:Number, byBoundingBox:Boolean = false ):void
		{
			if (byBoundingBox)
			{
				_workarea.selectionLayer.transformLayer.scaleByBoundingBox( anchor, scaleX, scaleY );
			}
			else
			{
				_workarea.selectionLayer.transformLayer.scale( anchor, scaleX, scaleY );
			}
		}	

		/**
		 * 
		 * @param skewX
		 * @param skewY
		 */
		public function skewElements(skewX:Number, skewY:Number, fromOrigin:Boolean = false):void
		{
			_workarea.selectionLayer.transformLayer.skew(skewX, skewY, fromOrigin);
		}

		/**
		 * 
		 * @param axis
		 */
		public function flipElements( axis:String ):void
		{
			_workarea.selectionLayer.transformLayer.flip( axis );
		}
		
		/**
		 * 
		 * @param moveX
		 * @param moveY
		 */
		public function nudgeElements(moveX:Number, moveY:Number):void
		{
			_workarea.selectionLayer.transformLayer.nudge(moveX, moveY);
		}
		
		/**
		 * 
		 * @param p
		 */
		public function moveElements(p:Point, byBoundingBox:Boolean = false):void
		{
			_workarea.selectionLayer.transformLayer.moveTo(p, byBoundingBox);
		}
		
		/**
		 * 
		 * @param className
		 * @return 
		 */
		public function getElementsByClassName( className:String ):Array
		{
			var array:Array = new Array();
			for each( var elm:Element in _elements )
			{
				if( elm.className == className )
				{
					array.push( elm );
				}
			}

			return array;
		}


		/**
		 * A function for setting the selected elements
		 * @param list of elements
		 */
		public function set elements( value:Vector.<Element> ):void
		{
			clear();

			for each( var element:Element in value )
				addElement( element, false );

			update( true );
			dispatchEvent( new SelectionManagerEvent( SelectionManagerEvent.ELEMENTS_ADDED, _elements ));
		}


		/**
		 * Adds an Element to selection
		 *
		 * @param element Element to add to SelectionManager
		 */
		public function addElement( element:Element, updateSelection:Boolean = true ):void
		{
			if( element.parent is IElementContainer )
			{
				_elements.push( element );
				element.dispatchEvent( new ElementSelectionEvent( ElementSelectionEvent.ELEMENT_SELECTED ));

				if( updateSelection )
				{
					update( true );
					dispatchEvent( new SelectionManagerEvent( SelectionManagerEvent.ELEMENT_ADDED, _elements ));
				}
			}
		}


		/**
		 * Removes a Element from selection
		 *
		 * @param element Element to remove from SelectionManager
		 *
		 * @return Element that was removed.
		 */
		public function removeElement( element:Element, updateSelection:Boolean = true ):Element
		{
			_elements.splice( _elements.indexOf( element ), 1 );
			element.dispatchEvent( new ElementSelectionEvent( ElementSelectionEvent.ELEMENT_DESELECTED ));

			if( updateSelection )
			{
				update( true );
				dispatchEvent( new SelectionManagerEvent( SelectionManagerEvent.ELEMENT_REMOVED, _elements ));
			}

			return element;
		}
		
		/**
		 * Returns the rotation of the selected elements
		 * @return 
		 */
		public function getRotation():Number
		{
			var r:Number = (_workarea.selectionLayer.transformLayer.getCurrentRotation() * (180 / Math.PI));
			return (r < 0) ? 360 + r : r;
		}
		
		public function getSkewX():Number
		{
			return _workarea.selectionLayer.transformLayer.getSkewX();
		}

		public function getSkewY():Number
		{
			return _workarea.selectionLayer.transformLayer.getSkewY();
		}

		/**
		 * Determines if a Element is Selected
		 *
		 * @param element Element to check selection for.
		 *
		 * @return Boolean - True if element is selected.
		 */
		public function isSelected( element:Element ):Boolean
		{
			return _elements.indexOf( element ) != -1;
		}


		/**
		 * Clear all Elements from selection.
		 */
		public function clear():void
		{
			var elements:Vector.<Element> = new Vector.<Element>();
			var elementCount:uint = _elements.length;

			for( var i:uint = 0; i < elementCount; i++ )
			{
				elements.push( removeElement( _elements[ 0 ], false ));
			}

			update( true );
			dispatchEvent( new SelectionManagerEvent( SelectionManagerEvent.ELEMENTS_REMOVED, elements ));
			dispatchEvent( new SelectionManagerEvent( SelectionManagerEvent.ELEMENTS_UPDATE_COMPLETE, _elements ));
		}


		/**
		 * Checks all selected items. If item(s) have been removed, or their layer's
		 * visibility is hidden. They will be removed from the selection.
		 */
		public function updateSelection( rebuildSelection:Boolean = false, updateBounds:Boolean = false, updateCenter:Boolean = false ):void
		{
			update( rebuildSelection, updateBounds, updateCenter );
			dispatchEvent( new SelectionManagerEvent( SelectionManagerEvent.ELEMENTS_UPDATE, _elements ));
		}


		private function update( rebuildSelection:Boolean = false, updateBounds:Boolean = false, updateCenter:Boolean = false):void
		{

			var elements:Vector.<Element> = new Vector.<Element>();

			for each( var element:Element in _elements )
			{
				var container:IElementContainer = IElementContainer( element.parent );

				//Element is inside a container.
				//That container is visible.
				//That container is contained.
				if( container && container.visible && container.parent )
				{
					elements.push( element );
				}
			}

			if( !rebuildSelection && _elements.length == elements.length )
			{
				/*
				   If Nothing has changed, just update the current selection box.
				 */
				_workarea.selectionLayer.transformLayer.update( updateCenter, updateBounds );
			}
			else
			{
				/*
				   If Something has changed, update the entire selection box.
				 */
				_elements = elements;

				var parent:DisplayObjectContainer;
				if( _workarea.isolationLayer && _workarea.isolationLayer.elementLength() > 0 )
				{
					parent = _workarea.isolationLayer.contentGroup;
				}
				else
				{
					parent = _workarea.contentGroup;
				}

				// if the list of selected elements is greater than 1
				if( elements.length > 0 )
				{
					_workarea.selectionLayer.transformLayer.select( parent, elements, updateBounds, false );
				}
				else
				{
					_workarea.selectionLayer.transformLayer.unSelect();
				}
			}
			
			dispatchEvent( new SelectionManagerEvent( SelectionManagerEvent.ELEMENTS_UPDATE_COMPLETE, _elements ));
		}


		/**
		 * Select All Elements
		 *
		 * Handles isolation mode as well.
		 */
		public function selectAll():void
		{
			var allElements:Vector.<Element> = new Vector.<Element>();

			if( _workarea.isolationLayer && _workarea.isolationMode )
			{
				for( var i:int = 0; i < _workarea.isolationLayer.contentGroup.numChildren; i++ )
				{
					allElements.push( _workarea.isolationLayer.contentGroup.getChildAt( i ));
				}
			}
			else
			{
				for each( var layer:Layer in _workarea.layers )
				{
					for( var j:int = 0; j < layer.numChildren; j++ )
					{
						allElements.push( layer.getChildAt( j ));
					}
				}
			}
			elements = allElements;
		}
	}
}