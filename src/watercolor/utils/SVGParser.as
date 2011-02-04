package watercolor.utils
{
	import flash.geom.Point;

	public class SVGParser
	{
		private var parseString:String = "";
		
		public function SVGParser(parseString:String)
		{
			this.parseString = parseString;
		}
		
		public function hasMore():Boolean
		{
			return parseString.length > 0;			
		}
		
		public function skipWhiteSpace():void
		{
			var index:int = parseString.search( /([MmCcSsLlHhVvZz.-\d])/ );
			if( index >= 0 )
			{
				parseString = parseString.substr( index );
			}
			else
			{
				parseString = "";
			}
		}
		
		
		public function getCommand():String
		{
			var cmd:String = "";
			skipWhiteSpace();
			var index:int = parseString.search( /([MmCcSsLlHhVvZz.-\d\s])/ );
			if( index >= 0 )
			{
				cmd = parseString.substr( index, 1 );
				
				// If its a command, send it on, if its a number, then use the last command.
				
				if( cmd.search( /([MmCcSsLlHhVvZz])/ ) == 0 )
				{
					parseString = parseString.substr( index + 1 );
				}
				else
				{
					cmd = "";
				}
			}
			else
			{
				parseString = "";
			}
			return cmd;
		}
		
		
		public function getNumber():Number
		{
			var number:Number;
			skipWhiteSpace();
			
			var index:int = parseString.search( /([\sMmCcSsLlHhVvZz])/ );
			if( index > 0 )
			{
				number = Number( parseString.substr( 0, index ));
				if (Math.abs(number) < .005)
				{
					number = 0;
				}
				parseString = parseString.substr( index );
			}
			else
			{
				number = Number( parseString );
				parseString = "";
			}
			
			return number;
		}
		
		
		public function getPoint():Point
		{
			return new Point( getNumber(), getNumber());
		}
	}
}