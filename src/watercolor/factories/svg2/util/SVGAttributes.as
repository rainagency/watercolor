package watercolor.factories.svg2.util
{
	import flash.geom.Matrix;
	
	import mx.collections.XMLListCollection;
	import mx.core.UIComponent;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	
	import spark.collections.Sort;
	
	import watercolor.elements.Text;
	import watercolor.utils.MatrixInfo;


	/**
	 *
	 * @author mediarain
	 */
	public class SVGAttributes
	{
		public static const LINE_BREAK:String = "\n";
		public static const BULLET_POINT:String = "&#8226;";
		public static const LINE_BREAK_EXPRESSION:RegExp = /\n/g;
		
		/**
		 * This function is for parsing through the attributes of an fxg node and inserting them into the
		 * matching element.  If an invalid attribute is specified in the fxg, then it will be ignored.
		 * @param node
		 * @param element
		 */
		public static function parseXMLAttributes( node:XML, element:Object, folderLocation:String = "" ):void
		{
			var list:XMLListCollection = new XMLListCollection(node.attributes());
			
			var sort:Sort = new Sort();
			sort.compareFunction = compareNodes;
			list.sort = sort;
			list.refresh();
			
			for each( var attribute:XML in list)
			{

				// try to set the property on the element
				try
				{
					switch( attribute.localName())
					{
						case "stroke-width":
							
							if (!element.stroke) {
								element.stroke = new SolidColorStroke();
							}
							
							element.stroke.weight = Number( attribute.toXMLString());
							break;
						
						case "stroke":
							
							if (!element.stroke) {
								element.stroke = new SolidColorStroke();
							}
							
							element.stroke.color = parseColor( attribute.toXMLString());
							break;
						
						case "fill":
							
							element.fill = new SolidColor(parseColor( attribute.toXMLString()));
							break;
						
						case "transform": // special case transform
							
							if (!(element is Text)) { 
								element.transform.matrix = parseTransform(attribute.toXMLString());
							}
							break;
						case "as3transform":
							element.transform.matrix = parseTransform(attribute.toXMLString());
							break;
						case "color": // special case color
						case "bg":
							element.color = parseColor( attribute.toXMLString());
							break;
						case "source":
							element.source = folderLocation + attribute.toXMLString();
							break;
						case "viewWidth":
							element.width = Number( attribute.toXMLString());
							break;
						case "textWidth":
							if (element is Text && Text(element).textInput.textDisplay is UIComponent) {
								Text(element).textWidth = Number( attribute.toXMLString());
							}
							break;
						case "viewHeight":
							element.height = Number( attribute.toXMLString());
							break;
						case "fill-mode":
							element.fillMode = attribute.toXMLString();
							break;
						case "href":
							element.source = attribute.toXMLString();
							break;
						case "version":
							break;
						/*case "data":
						   if (element is Path) {
						   element.data = TransformUtil.convertPathToAbsolute(attribute.toXMLString());
						   break;
						 }*/
						default: // everything else
							element[ attribute.localName()] = attribute.toXMLString();
							break;
					}
				}
				catch( err:Error )
				{
					trace( "Cannot create property " + attribute.localName() + " on " + element.toString());
				}
			}
		}
		
		/**
		 *
		 * @param value
		 * @return
		 */
		public static function parseColor( value:String ):uint
		{
			// trim whitespace from the value
			value = value.replace( /\s/g, "" );
			var matches:Array;

			if( value.toLowerCase() in colorNames )
			{
				return colorNames[ value.toLowerCase()];
			}
			// traditional #FFFFFF representation of the color
			else if(( matches = value.match( /^#?([a-zA-Z0-9]{6}|[a-zA-Z0-9]{3})$/ )))
			{
				value = matches[ 1 ];

				// turn an rgb value to an rrggbb value
				if( value.length == 3 )
					value = value.charAt( 0 ) + value.charAt( 0 ) + value.charAt( 1 ) + value.charAt( 1 ) + value.charAt( 2 ) + value.charAt( 2 );

				return parseInt( value, 16 );
			}
			else if(( matches = value.match( /^rgb\((\d{1,3})(%?),(\d{1,3})\2,(\d{1,3})\2\)$/ )))
			{
				var isPercent:Boolean = matches[ 2 ] == "%";

				// remove the % group in the array for simplicity
				matches.splice( 2, 1 );

				var color:uint = 0;

				for( var i:uint = 1; i <= 3; i++ )
				{
					var part:uint = isPercent ? Number( matches[ i ]) / 100 * 255 : Number( matches[ i ]);
					for( var j:uint = i; j < 3; j++ )
						part <<= 8;

					color = color | part;
				}

				return color;
			}

			return 0;
		}


		/**
		 *
		 * @param value
		 * @return
		 */
		public static function createColor( value:uint ):String
		{
			var clr:String = value.toString( 16 );
			while( clr.length < 6 )
				clr = "0" + clr;
			return "#" + clr;
		}


		/**
		 *
		 * @param value
		 * @return
		 */
		public static function parseURL( value:String ):String
		{
			return value.replace( /url\(#(.*)\)/, "$1" );
		}


		/**
		 *
		 * @param value
		 * @return
		 */
		public static function parseFill( value:String ):Object
		{
			if( value.toLowerCase() == "none" )
			{
				return "none";
			}
			else if( value.indexOf( 'url' ) == -1 )
			{
				return parseColor( value );
			}
			else
				return parseURL( value );
		}

		public static function parseMatrix(m:Matrix):String {
			return "matrix(" + m.a + " " + m.b + " " + m.c + " " + m.d + " " + m.tx + " " + m.ty + ")";
		}
		
		/**
		 *
		 * @param value
		 * @return
		 */
		public static function parseTransform( value:String ):Matrix
		{
			var matches:Array;
			var m:Matrix;
			var mi:MatrixInfo;
			var transform:Matrix = new Matrix();

			while( value.length )
			{
				if(( matches = value.match( /matrix\(([-\d.e]+)[, ]+([-\d.e]+)[, ]+([-\d.e]+)[, ]+([-\d.e]+)[, ]+([-\d.e]+)[, ]+([-\d.e]+)\)/ )))
				{
					transform.concat( new Matrix( matches[ 1 ], matches[ 2 ], matches[ 3 ], matches[ 4 ], matches[ 5 ], matches[ 6 ]));
				}
				else if(( matches = value.match( /^translate\(([-\d.]+)[, ]+([-\d.]+)\)/ )))
				{
					transform.translate( matches[ 1 ], matches[ 2 ]);
				}
				else if(( matches = value.match( /^scale\(([-\d.]+)([, ]+([-\d.]+))?\)/ )))
				{
					transform.scale( matches[ 1 ], matches[ 3 ] ? matches[ 3 ] : matches[ 1 ]);
				}
				else if(( matches = value.match( /^rotate\(([-\d.]+)\)/ )))
				{
					transform.rotate( matches[ 1 ]);
				}
				else if(( matches = value.match( /^rotate\(([-\d.e]+)[, ]+([-\d.e]+)[, ]+([-\d.e]+)\)/ )))
				{
					m = new Matrix();
					m.translate(-(matches[2]), -(matches[3]));
					m.rotate(matches[ 1 ] * (Math.PI / 180));
					m.translate(matches[2], matches[3]);
					transform.concat(m);
					
					//transform.rotate( matches[ 1 ]);
				}
				else if(( matches = value.match( /^skewX\(([-\d.]+)\)/ )))
				{
					mi = new MatrixInfo();
					mi.skewX = matches[ 1 ];
					transform.concat( mi.matrix );
				}
				else if(( matches = value.match( /^skewY\(([-\d.]+)\)/ )))
				{
					mi = new MatrixInfo();
					mi.skewY = matches[ 1 ];
					transform.concat( mi.matrix );
				}
				else
					break;

				value = value.replace( matches[ 0 ], "" );
				//value = value.substring(matches[0].length); // cut the last match out of the value and see if there is any more
				value = value.replace( /^\s+|\s+$/g, "" ); // trim any whitespace off of the string
			}

			return transform;
		}


		/**
		 *
		 * @default
		 */
		public static const colorNames:Object = { aliceblue:0xf0f8ff, antiquewhite:0xfaebd7, aqua:0x00ffff, aquamarine:0x7fffd4, azure:0xf0ffff, beige:0xf5f5dc, bisque:0xffe4c4, black:0x000000, blanchedalmond:0xffebcd, blue:0x0000ff, blueviolet:0x8a2be2, brown:0xa52a2a, burlywood:0xdeb887, cadetblue:0x5f9ea0, chartreuse:0x7fff00, chocolate:0xd2691e, coral:0xff7f50, cornflowerblue:0x6495ed, cornsilk:0xfff8dc, crimson:0xdc143c, cyan:0x00ffff, darkblue:0x00008b, darkcyan:0x008b8b, darkgoldenrod:0xb8860b, darkgray:0xa9a9a9, darkgreen:0x006400, darkgrey:0xa9a9a9, darkkhaki:0xbdb76b, darkmagenta:0x8b008b, darkolivegreen:0x556b2f, darkorange:0xff8c00, darkorchid:0x9932cc, darkred:0x8b0000, darksalmon:0xe9967a, darkseagreen:0x8fbc8f, darkslateblue:0x483d8b, darkslategray:0x2f4f4f, darkslategrey:0x2f4f4f, darkturquoise:0x00ced1, darkviolet:0x9400d3, deeppink:0xff1493, deepskyblue:0x00bfff, dimgray:0x696969, dimgrey:0x696969, dodgerblue:0x1e90ff, firebrick:0xb22222, floralwhite:0xfffaf0, forestgreen:0x228b22, fuchsia:0xff00ff, gainsboro:0xdcdcdc, ghostwhite:0xf8f8ff, gold:0xffd700, goldenrod:0xdaa520, gray:0x808080, grey:0x808080, green:0x008000, greenyellow:0xadff2f, honeydew:0xf0fff0, hotpink:0xff69b4, indianred:0xcd5c5c, indigo:0x4b0082, ivory:0xfffff0, khaki:0xf0e68c, lavender:0xe6e6fa, lavenderblush:0xfff0f5, lawngreen:0x7cfc00, lemonchiffon:0xfffacd, lightblue:0xadd8e6, lightcoral:0xf08080, lightcyan:0xe0ffff, lightgoldenrodyellow:0xfafad2, lightgray:0xd3d3d3, lightgreen:0x90ee90, lightgrey:0xd3d3d3, lightpink:0xffb6c1, lightsalmon:0xffa07a, lightseagreen:0x20b2aa, lightskyblue:0x87cefa, lightslategray:0x778899, lightslategrey:0x778899, lightsteelblue:0xb0c4de, lightyellow:0xffffe0, lime:0x00ff00, limegreen:0x32cd32, linen:0xfaf0e6, magenta:0xff00ff, maroon:0x800000, mediumaquamarine:0x66cdaa, mediumblue:0x0000cd, mediumorchid:0xba55d3, mediumpurple:0x9370db, mediumseagreen:0x3cb371, mediumslateblue:0x7b68ee, mediumspringgreen:0x00fa9a, mediumturquoise:0x48d1cc, mediumvioletred:0xc71585, midnightblue:0x191970, mintcream:0xf5fffa, mistyrose:0xffe4e1, moccasin:0xffe4b5, navajowhite:0xffdead, navy:0x000080, oldlace:0xfdf5e6, olive:0x808000, olivedrab:0x6b8e23, orange:0xffa500, orangered:0xff4500, orchid:0xda70d6, palegoldenrod:0xeee8aa, palegreen:0x98fb98, paleturquoise:0xafeeee, palevioletred:0xdb7093, papayawhip:0xffefd5, peachpuff:0xffdab9, peru:0xcd853f, pink:0xffc0cb, plum:0xdda0dd, powderblue:0xb0e0e6, purple:0x800080, red:0xff0000, rosybrown:0xbc8f8f, royalblue:0x4169e1, saddlebrown:0x8b4513, salmon:0xfa8072, sandybrown:0xf4a460, seagreen:0x2e8b57, seashell:0xfff5ee, sienna:0xa0522d, silver:0xc0c0c0, skyblue:0x87ceeb, slateblue:0x6a5acd, slategray:0x708090, slategrey:0x708090, snow:0xfffafa, springgreen:0x00ff7f, steelblue:0x4682b4, tan:0xd2b48c, teal:0x008080, thistle:0xd8bfd8, tomato:0xff6347, turquoise:0x40e0d0, violet:0xee82ee, wheat:0xf5deb3, white:0xffffff, whitesmoke:0xf5f5f5, yellow:0xffff00, yellowgreen:0x9acd32 }
			
			
		private static function compareNodes(a:Object, b:Object, fields:Array = null):int
		{
			if (a.localName() == "x" || a.localName() == "y") {
				return -1;
			}
			
			return 1;
		}
	}
}
