package watercolor.utils
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.graphics.GradientEntry;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import mx.graphics.RadialGradient;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import mx.utils.ObjectUtil;
	
	import spark.primitives.BitmapImage;
	import spark.primitives.Path;
	
	import watercolor.elements.Element;
	import watercolor.elements.Layer;
	import watercolor.elements.TextGroup;


	/**
	 * Utility to Clone IVisiualElement(s) and there children
	 *
	 * @author Sean Thayne
	 */
	public class VisualElementUtil
	{

		public static var globalTarget:Layer;
		
		/**
		 * Clone a IVisualElement regardless of type.
		 *
		 * @param source Object to clone.
		 * @param target Optional parameter of an already created object to clone to.
		 *
		 * @return Cloned Object
		 */
		public static function clone( source:IVisualElement, target:IVisualElement = null, cloneFunction:Function = null ):IVisualElement
		{
			if (target is Layer)
			{
				globalTarget = target as Layer;
			}
			if( cloneFunction == null )
				cloneFunction = clone;

			// Create new target (if missing)
			target = checkTarget( source, target );

			/*
			   Special conditions for cloning TextGroups

			   It's a Group, but it's elements are created in a special way. So the easiest
			   way to clone it is to copy it's parameters and set it's text which will create
			   it's inner elements.
			 */
			if( source is TextGroup )
			{
				var sourceTextGroup:TextGroup = TextGroup( source );
				var clonedTextGroup:TextGroup = TextGroup( cloneElement( Element( source ), Element( target ), false ));

				clonedTextGroup.textDirection = sourceTextGroup.textDirection;
				clonedTextGroup.letterSpacing = sourceTextGroup.letterSpacing;
				clonedTextGroup.verticalAlign = sourceTextGroup.verticalAlign;
				clonedTextGroup.horizontalAlign = sourceTextGroup.horizontalAlign;
				clonedTextGroup.text = sourceTextGroup.text;

				return clonedTextGroup;
			}
			else if( source is watercolor.elements.Path )
			{
				return cloneWCPath( watercolor.elements.Path( source ), watercolor.elements.Path( target ));
			}
			else if( source is spark.primitives.Path )
			{
				return clonePath( spark.primitives.Path( source ), spark.primitives.Path( target ));
			}
			else if( source is spark.primitives.BitmapImage )
			{
				return cloneBitmapImage( spark.primitives.BitmapImage( source ), spark.primitives.BitmapImage( target ));
			}
			else if( source is Element )
			{
				return cloneElement( Element( source ), Element( target ), true, cloneFunction );
			}
			else
			{
				trace( "Cloning Unkown-Type" );
			}

			return target;
		}


		/**
		 * Alias need to registered at least once in order to clone certain objects(IFill, IStroke).
		 * This only needs to be called if your using the ObjectUtil.copy function
		 */
		private static function registerAliases():void
		{
			registerClassAlias( "mx.graphics.SolidColor", mx.graphics.SolidColor );
			registerClassAlias( "mx.graphics.SolidColorStroke", mx.graphics.SolidColorStroke );
			registerClassAlias( "mx.graphics.RadialGradient", mx.graphics.RadialGradient );
			registerClassAlias( "mx.graphics.GradientEntry", mx.graphics.GradientEntry );
			registerClassAlias( "flash.display.Bitmap", flash.display.Bitmap );
		}


		/**
		 * Clone a IFill regardless of type.
		 *
		 * @param source Object to clone.
		 * @param target Optional parameter of an already created object to clone to.
		 *
		 * @return Cloned Object
		 */
		public static function cloneIFill( source:IFill = null, target:IFill = null ):IFill
		{

			// Make sure we actually have a fill to copy.
			if( source == null )
			{
				return null;
			}

			// Create new target (if missing)
			target = checkTarget( source, target );
			registerAliases();

			if( source is RadialGradient )
			{
				RadialGradient( target ).entries = ObjectUtil.copy( RadialGradient( source ).entries ) as Array;
				RadialGradient( target ).scaleX = RadialGradient( source ).scaleX;
				RadialGradient( target ).scaleY = RadialGradient( source ).scaleY;
				RadialGradient( target ).x = RadialGradient( source ).x;
				RadialGradient( target ).y = RadialGradient( source ).y;
				RadialGradient( target ).rotation = RadialGradient( source ).rotation;
			}
			else if( source is SolidColor )
			{
				SolidColor( target ).color = SolidColor( source ).color;
				SolidColor( target ).alpha = SolidColor( source ).alpha;
			}

			return target;
		}


		/**
		 * Clone a WaterColor BitmapImage.
		 *
		 * @param source Object to clone.
		 * @param target Optional parameter of an already created object to clone to.
		 *
		 * @return Cloned Bitmap
		 */
		public static function cloneWCBitmapImage( source:watercolor.elements.BitmapImage, target:watercolor.elements.BitmapImage = null ):watercolor.elements.BitmapImage
		{

			// Create new target (if missing)
			target = checkTarget( source, target );

			// Copy Bitmap Data
			var sourceBitmap:Bitmap = Bitmap( source.source );
			var targetBitmap:Bitmap = new Bitmap( sourceBitmap.bitmapData.clone(), sourceBitmap.pixelSnapping, sourceBitmap.smoothing );

			// Key properties
			target.source = targetBitmap;
			target.x = source.x;
			target.y = source.y;
			target.width = source.width;
			target.height = source.height;
			target.transform.matrix = source.transform.matrix;

			return target;
		}


		/**
		 * Clone a Spark BitmapImage.
		 *
		 * @param source Object to clone.
		 * @param target Optional parameter of an already created object to clone to.
		 *
		 * @return Cloned Bitmap
		 */
		public static function cloneBitmapImage( source:spark.primitives.BitmapImage, target:spark.primitives.BitmapImage = null ):spark.primitives.BitmapImage
		{
			// Create new target (if missing)
			target = checkTarget( source, target );

			// Copy Bitmap Data
			var sourceBitmap:Bitmap = Bitmap( source.source );
			var targetBitmap:Bitmap = new Bitmap( sourceBitmap.bitmapData.clone(), sourceBitmap.pixelSnapping, sourceBitmap.smoothing );

			return target;
		}


		/**
		 * Clone a Spark Path.
		 *
		 * @param source to clone.
		 * @param target Optional parameter of an already created object to clone to.
		 *
		 * @return Cloned Path
		 */
		public static function clonePath( source:spark.primitives.Path, target:spark.primitives.Path = null ):spark.primitives.Path
		{
			// Create new target (if missing)
			registerAliases();
			target = checkTarget( source, target );

			// Key properties
			//TODO: find better fix.
			//target.fill = cloneIFill( source.fill );
			target.stroke = IStroke( ObjectUtil.copy( source.stroke ));
			target.winding = source.winding;
			target.data = source.data;
			target.width = source.width;
			target.height = source.height;
			target.transform.matrix = source.transform.matrix;

			return target;
		}


		/**
		 * Clone a WaterColor Path.
		 *
		 * @param source Object to clone.
		 * @param target Optional parameter of an already created object to clone to.
		 *
		 * @return Cloned Path
		 */
		public static function cloneWCPath( source:watercolor.elements.Path, target:watercolor.elements.Path = null, cloneFunction:Function = null ):watercolor.elements.Path
		{
			if( cloneFunction == null )
				cloneFunction = clone;

			// Create new target (if missing)
			registerAliases();
			target = checkTarget( source, target );

			// Key properties
			target.fill = cloneIFill( source.fill );
			target.stroke = IStroke( ObjectUtil.copy( source.stroke ));
			target.winding = source.winding;
			target.pathData = source.pathData.clone();
			target.width = source.width;
			target.height = source.height;
			target.transform.matrix = source.transform.matrix;

			// Clone & Attach Children (if any)
			for( var i:uint = 0; i < source.numElements; i++ )
			{
				var child:IVisualElement = source.getElementAt( i );
				target.addElementAt( cloneFunction( child ), target.numElements );
			}

			return target;
		}


		/**
		 * Clone a WaterColor Element.
		 *
		 * @param source Object to clone.
		 * @param target Optional parameter of an already created object to clone to.
		 *
		 * @return Cloned Element
		 */
		public static function cloneElement( source:Element, target:Element = null, cloneChildren:Boolean = true, cloneFunction:Function = null ):Element
		{
			if (target is Layer)
			{
				globalTarget = target as Layer;
			}
			
			if( cloneFunction == null )
				cloneFunction = clone;

			// Make sure this Element doesn't have a special case.
			if( source is watercolor.elements.Path )
			{
				return cloneWCPath( watercolor.elements.Path( source ), watercolor.elements.Path( target ));
			}
			else if( source is watercolor.elements.BitmapImage )
			{
				return cloneWCBitmapImage( watercolor.elements.BitmapImage( source ), watercolor.elements.BitmapImage( target ));
			}

			// Create new target (if missing)
			target = checkTarget( source, target );

			// Key properties
			target.width = source.width;
			target.height = source.height;
			target.transform.matrix = source.transform.matrix;
			target.mouseChildren = source.mouseChildren;

			// Clone & Attach Children (if any)
			if( cloneChildren )
			{
				for( var i:uint = 0; i < source.numElements; i++ )
				{
					var child:IVisualElement = source.getElementAt( i );
					target.addElementAt( cloneFunction( child ), target.numElements );
				}
			}

			// Clone the mask (if any)
			if( source.mask )
			{
				var clone:Object = cloneFunction( IVisualElement( source.mask ));

				/*
				   !! This is a needed hack !!
				   Without this set to false. The mask will render as a square.
				 */
				if( clone.hasOwnProperty( 'mouseEnabled' ))
				{
					clone.mouseEnabled = false;
				}

				target.mask = DisplayObject( clone );
			}

			return target;
		}


		/**
		 * public function for finding any elements that are touching from a list of elements
		 * @return A list of elements that are touching
		 */
		public static function getTouchingElements( elements:Vector.<Element> ):Vector.<Element>
		{

			var items:Vector.<Element> = new Vector.<Element>();

			// go through each glyph and compare it to all of the other glyphs
			for( var x:int = 0; x < elements.length; x++ )
			{
				for( var y:int = x + 1; y < elements.length; y++ )
				{

					// if they are touching then keep track of them
					if( VisualElementUtil.isTouching( elements[ x ], elements[ y ], elements[ x ].parent, true ))
					{

						if( items.indexOf( elements[ x ]) == -1 )
						{
							items.push( elements[ x ]);
						}

						if( items.indexOf( elements[ y ]) == -1 )
						{
							items.push( elements[ y ]);
						}
					}
				}
			}

			return items;
		}


		/**
		 * public function for finding the rectangular region for an element
		 * This function will check if an element has a mask enabled.  If so
		 * then it will use the mask to find the rectangle.  If the element has children
		 * then it concatinate all of the children's rectangles to find the main rectangle.
		 * @param element The element for which to find the rectangle
		 * @param parent The parent element to use when determing the rectangle
		 * @param multiSelected If the element has been selected with other elements
		 * @return A rectangle representing the area occupied by the element
		 */
		public static function getElementRectangle( element:Object, parent:DisplayObject, multiSelected:Boolean ):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			
			// check if the element has a mask and if so then we want to check that
			var target:UIComponent = (( element.mask != null ) ? element.mask : element ) as UIComponent;
			// var target:UIComponent = ( element ) as UIComponent;

			if (target)
			{
				// if the target doesn't have a width and height then validate it to try and force a width and height
				if( target.width == 0 && target.height == 0 )
				{
					element.validateNow();
					
					if (parent is TextGroup)
					{
						// posssibly a total hack
						element.y = parent.height - element.height;
					}
				}
	
				// if the element has children then we need to check the children
				if( target.numChildren > 0 )
				{
					for( var x:int = 0; x < target.numChildren; x++ )
					{
						rect = rect.union( getElementRectangle( target.getChildAt( x ), ( multiSelected ) ? parent : target, true ));
					}
				}
				else
				{
					rect = target.getRect(( multiSelected ) ? parent : target );
				}
	
				// if the rectangle is missing an x or y value but the mask has an x or y value specified
				// then set the x and or y on the rectangle
				if( Boolean( element.mask != null ))
				{
					if( target.x > 0 && rect.x == 0 )
						rect.x = target.x;
					if( target.y > 0 && rect.y == 0 )
						rect.y = target.y;
				}
			}
			
			// return the result
			return rect;
		}


		/**
		 * public function for finding the color bounds rect for an element
		 * if an element has been rotated in such a way that finding the rectangle
		 * results in some padding then this function will find the rectangular region
		 * around the element without the padding.
		 *
		 * @param element The element for which we want a color bounds rect
		 * @param parent The parent element to use when determing the rectangle
		 * @param rect A rectangular region under the same parent as the element.
		 * This is for checking a specific space within the element.
		 * @return A rectangle representing the area occupied by the element or section of the element
		 */
		public static function getColorBoundsRect(element:Element, parent:DisplayObject, rect:Rectangle = null):Rectangle
		{
			var rectTemp:Rectangle = getElementRectangle(element, parent, true);
			var space:Rectangle;
			var rectTemp2:Rectangle;

			space = (rect) ? rect.intersection(rectTemp) : rectTemp;
			
			if(space != null && space.size.length > 0)
			{
				space.width = (space.width < 1 && space.width >= 0) ? 1 : Math.ceil(space.width);
				space.height = (space.height < 1 && space.height >= 0) ? 1 : Math.ceil(space.height);
				
				var selectionBmp:BitmapData = getAlphaMap(element as DisplayObject, space, BitmapDataChannel.RED, element.parent);
				var rectBmp:BitmapData = new BitmapData(space.width, space.height, false, 0xFF0000);
				var alphaRectBmp:BitmapData = new BitmapData(space.width, space.height, false, 0);

				var newRect:Rectangle = new Rectangle();
				newRect.width = space.width;
				newRect.height = space.height;

				alphaRectBmp.copyChannel(rectBmp, newRect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
				selectionBmp.draw(alphaRectBmp, null, null, BlendMode.LIGHTEN);

				// get the rectangle region surrounding the area with color
				rectTemp2 = selectionBmp.getColorBoundsRect(0x010100, 0x010100, true);
				rectTemp2.x += space.x;
				rectTemp2.y += space.y;

				selectionBmp.dispose();
				rectBmp.dispose();
				alphaRectBmp.dispose();

			}
			else
			{
				rectTemp2 = space;
			}

			return rectTemp2;
		}


		/**
		 * public function for finding the rectangular region for multiple elements
		 * @param elements The list of elements for which to use in finding the rectangle
		 * @param parent The parent element to use when determing the rectangle
		 * @return A rectangle representing the area occupied by the elements
		 */
		public static function getElementsRectangle( elements:Vector.<Element>, parent:DisplayObject, useColorBoundsRect:Boolean = true ):Rectangle
		{

			var rect:Rectangle = new Rectangle();

			// Go through each element and find it's rectangle and then unionize them all together
			for each( var elm:Element in elements )
			{
				if( useColorBoundsRect )
					rect = rect.union( getColorBoundsRect( elm, parent ));
				else
					rect = rect.union(getElementRectangle(elm, parent, true));
			}

			return rect;
		}
		
		/**
		 * Helper function to create new instances.
		 *
		 * Either will return (target) if not null, or
		 * create a new instance from source's constructor.
		 *
		 * @param source Source object.
		 * @param target Target object to check.
		 *
		 * @return Target to clone to.
		 */
		public static function checkTarget( source:*, target:* = null ):*
		{

			// Target is good, send back
			if( target )
			{
				return target;
			}

			// Null target, create new instance.
			if( !target )
			{
				if( source is TextGroup )
					return new TextGroup( TextGroup( source ).adapter );

				if( "clone" in source )
				{
					return source.clone();
				}
				else
				{
					var targetClass:Class = Object( source ).constructor;
					try
					{
						return new targetClass();
					}
					catch(e:ArgumentError)
					{
						return new targetClass(globalTarget);
					}
				}
			}
		}


		/** Get the minimum spacing between two display objects. **/
		public static function getMinimumSpacing( target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer ):Number
		{
			// target2 may have not been positioned on parent before, if not, pre-position it vertically
			if( target2.x == 0 )
				target2.y = target1.y + target1.height - target2.height;

			// get bounding boxes in common parent's coordinate space
			var rect1:Rectangle = getElementRectangle( target1, commonParent, true );
			var rect2:Rectangle = getElementRectangle( target2, commonParent, true );

			// if there is no horizontal space in common, return NaN
			if( rect1.bottom <= rect2.top || rect2.bottom <= rect1.top )
				return 0;

			// reduce the rectangles down to only the common height
			rect1.top = rect2.top = Math.max( rect1.top, rect2.top );
			rect1.bottom = rect2.bottom = Math.min( rect1.bottom, rect2.bottom );

			// size of rect needs to integer size for bitmap data
			rect1.width = Math.ceil( rect1.width );
			rect1.height = Math.ceil( rect1.height );
			rect2.width = Math.ceil( rect2.width );
			rect2.height = Math.ceil( rect2.height );

			// get the alpha maps for the display objects
			var alpha1:BitmapData = getAlphaMap( target1, rect1, BitmapDataChannel.RED, commonParent );
			var alpha2:BitmapData = getAlphaMap( target2, rect2, BitmapDataChannel.GREEN, commonParent );

			var minSpace:Number = alpha1.width + alpha2.width;
			var lineMinSpace:Number;
			var leftX:Number;
			var rightX:Number;
			var pixColor:uint;
			// compare pixel lines for minSpace
			for( var idy:int = 0; idy < alpha1.height; idy++ )
			{
				// move from the right on alpha 1 until we hit a non-transparent pixel
				for( var idx:int = alpha1.width - 1; idx >= 0; idx-- )
				{
					leftX = alpha1.width;
					pixColor = alpha1.getPixel32( idx, idy );
					if( pixColor != 0xff000000 )
					{
						leftX = alpha1.width - idx - 1;
						break;
					}
					else
					{
						alpha1.setPixel32( idx, idy, 0xff0000ff );
					}
				}
				// move from the left on alpha 2 until we hit a non-transparent pixel
				for( idx = 0; idx < alpha2.width; idx++ )
				{
					rightX = alpha2.width;
					pixColor = alpha2.getPixel32( idx, idy );
					if( pixColor != 0xff000000 )
					{
						rightX = idx;
						break;
					}
					else
					{
						alpha2.setPixel32( idx, idy, 0xff0000ff );
					}
				}
				if( leftX + rightX < minSpace )
					minSpace = leftX + rightX;
			}
			// debug stuff for seeing the created bitmaps
			/*
			var bitmap1:Bitmap = new Bitmap(alpha1);
			bitmap1.width = alpha1.width;
			bitmap1.height = alpha1.height;
			var bitmap2:Bitmap = new Bitmap(alpha2);
			bitmap2.x = bitmap1.width;
			bitmap2.width = alpha2.width;
			bitmap2.height = alpha2.height;
			var stage:Stage = commonParent.stage;
			
			// remove previous bitmaps
			for(var idz:int = 0; idz < stage.numChildren; idz++)
			{
				var thisChild:DisplayObject = stage.getChildAt(idz);
				if(thisChild is Bitmap)
				{
					stage.removeChildAt(idz);
					idz--;
				}
			}
			stage.addChildAt(bitmap1, stage.numChildren);
			stage.addChildAt(bitmap2, stage.numChildren);
			*/
			// end debug code
			
			// comment these out for debug view
			alpha1.dispose();
			alpha2.dispose();
			
			return minSpace;
		}


		/** Get the collision rectangle between two display objects. **/
		public static function getCollisionRect( target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer, pixelPrecise:Boolean = false, tolerance:Number = 0 ):Rectangle
		{
			// get bounding boxes in common parent's coordinate space
			var rect1:Rectangle = getElementRectangle( target1, commonParent, true );
			var rect2:Rectangle = getElementRectangle( target2, commonParent, true );

			// find the intersection of the two bounding boxes
			var intersectionRect:Rectangle = rect1.intersection( rect2 );

			if( intersectionRect.size.length > 0 )
			{
				if( pixelPrecise )
				{
					// size of rect needs to integer size for bitmap data
					intersectionRect.width = Math.ceil( intersectionRect.width );
					intersectionRect.height = Math.ceil( intersectionRect.height );

					// get the alpha maps for the display objects
					var alpha1:BitmapData = getAlphaMap( target1, intersectionRect, BitmapDataChannel.RED, commonParent );
					var alpha2:BitmapData = getAlphaMap( target2, intersectionRect, BitmapDataChannel.GREEN, commonParent );

					// combine the alpha maps
					alpha1.draw( alpha2, null, null, BlendMode.LIGHTEN );

					if( target1.stage.numChildren > 1 )
					{
						target1.stage.removeChildAt( target1.stage.numChildren - 1 );
					}

					target1.stage.addChild( new Bitmap( alpha1 ));

					// calculate the search color
					var searchColor:uint;
					if( tolerance <= 0 )
					{
						searchColor = 0x010100;
					}
					else
					{
						if( tolerance > 1 )
							tolerance = 1;
						var byte:int = Math.round( tolerance * 255 );
						searchColor = ( byte << 16 ) | ( byte << 8 ) | 0;
					}

					// find color
					var collisionRect:Rectangle = alpha1.getColorBoundsRect( searchColor, searchColor );
					collisionRect.x += intersectionRect.x;
					collisionRect.y += intersectionRect.y;

					alpha1.dispose();
					alpha2.dispose();

					return collisionRect;
				}
				else
				{
					return intersectionRect;
				}
			}
			else
			{
				// no intersection
				return null;
			}
		}


		/** Gets the alpha map of the display object and places it in the specified channel. **/
		public static function getAlphaMap( target:DisplayObject, rect:Rectangle, channel:uint, commonParent:DisplayObjectContainer, sourceChannel:uint = BitmapDataChannel.ALPHA ):BitmapData
		{
			// calculate the transform for the display object relative to the common parent
			var parentXformInvert:Matrix = commonParent.transform.concatenatedMatrix.clone();
			parentXformInvert.invert();
			var targetXform:Matrix = target.transform.concatenatedMatrix.clone();
			targetXform.concat( parentXformInvert );

			// translate the target into the rect's space
			targetXform.translate( -rect.x, -rect.y );

			// draw the target and extract its alpha channel into a color channel
			var bitmapData:BitmapData = new BitmapData( (rect.width < 1 && rect.width >= 0 ) ? 1 : Math.ceil(rect.width), (rect.height < 1 && rect.height >= 0) ? 1 : Math.ceil(rect.height), true, 0 );
			bitmapData.draw( target, targetXform, null );
			var alphaChannel:BitmapData = new BitmapData( (rect.width < 1 && rect.width >= 0 ) ? 1 : Math.ceil(rect.width), (rect.height < 1 && rect.height >= 0) ? 1 : Math.ceil(rect.height), false, 0 );
			alphaChannel.copyChannel( bitmapData, bitmapData.rect, new Point( 0, 0 ), sourceChannel, channel );

			bitmapData.dispose();

			return alphaChannel;
		}


		/** Get the center of the collision's bounding box. **/
		public static function getTouchingPoint( target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer, pixelPrecise:Boolean = false, tolerance:Number = 0 ):Point
		{
			var collisionRect:Rectangle = getCollisionRect( target1, target2, commonParent, pixelPrecise, tolerance );

			if( collisionRect != null && collisionRect.size.length > 0 )
			{
				var x:Number = ( collisionRect.left + collisionRect.right ) / 2;
				var y:Number = ( collisionRect.top + collisionRect.bottom ) / 2;

				return new Point( x, y );
			}

			return null;
		}


		/** Are the two display objects colliding (overlapping)? **/
		public static function isTouching( target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer, pixelPrecise:Boolean = false, tolerance:Number = 0 ):Boolean
		{
			var collisionRect:Rectangle = getCollisionRect( target1, target2, commonParent, pixelPrecise, tolerance );

			if( collisionRect != null && collisionRect.size.length > 0 )
				return true;
			else
				return false;
		}
	}
}
