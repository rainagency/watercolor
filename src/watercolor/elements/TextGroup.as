package watercolor.elements
{
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.core.IVisualElement;
	
	import watercolor.elements.interfaces.ITextGroup;
	import watercolor.events.TextGroupEvent;
	import watercolor.utils.VisualElementUtil;


	/**
	 *
	 * @author mediarain
	 */
	public class TextGroup extends Group
	{
		/**
		 *
		 * @default
		 */
		public static const DIRECTION_VERTICAL:String = "directionVertical";


		/**
		 *
		 * @default
		 */
		public static const DIRECTION_HORIZONTAL:String = "directionHorizontal";


		/**
		 *
		 * @default
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "horizontalAlignLeft";


		/**
		 *
		 * @default
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "horizontalAlignRight";


		/**
		 *
		 * @default
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "horizontalAlignCenter";


		/**
		 *
		 * @default
		 */
		public static const VERTICAL_ALIGN_TOP:String = "verticalAlignTop";


		/**
		 *
		 * @default
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "verticalAlignBottom";


		/**
		 *
		 * @default
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "verticalAlignMiddle";

		public static const BLOCK_SPACING:String = "blockSpacing";
		public static const CHARACTER_SPACING:String = "characterSpacing";

		/**
		 * The adapter to use for loading letters and setting the space width
		 */
		protected var _adapter:ITextGroup;


		/**
		 *
		 * @return
		 */
		public function get adapter():ITextGroup
		{
			return _adapter;
		}


		/**
		 *
		 * @param value
		 */
		public function set adapter( value:ITextGroup ):void
		{

			_adapter = value;

			// store a new TextChange object that changes the text completely.
			textChanges.push( new TextChange( TextChange.COMPLETE_CHANGE, _text ));

			processTextChanges();
		}


		/**
		 * Value to indicate which direction the text should go
		 * By default it should start horizontal
		 */
		protected var _textDirection:String = DIRECTION_HORIZONTAL;


		/**
		 *
		 * @return
		 */
		public function get textDirection():String
		{
			return _textDirection;
		}


		/**
		 *
		 * @param value
		 */
		public function set textDirection( value:String ):void
		{

			// if the value is the same that it already is then don't do anything
			if( _textDirection == value )
			{
				return;
			}

			// change the value and rerender the text
			_textDirection = value;
			render();
		}


		/**
		 * Value to indicate which horizontal alignment to use when the text is vertical
		 * By default it should start on the left
		 */
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;


		/**
		 *
		 * @return
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}


		/**
		 *
		 * @param value
		 */
		public function set horizontalAlign( value:String ):void
		{

			// if the value is the same that it already is then don't do anything
			if( _horizontalAlign == value )
			{
				return;
			}

			// change the value and rerender the text
			_horizontalAlign = value;
			render();
		}


		/**
		 * Value to indicate which vertical alignment to use when the text is horizontal
		 * By default it should start on the bottom
		 */
		protected var _verticalAlign:String = VERTICAL_ALIGN_BOTTOM;


		/**
		 *
		 * @return
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}


		/**
		 *
		 * @param value
		 */
		public function set verticalAlign( value:String ):void
		{

			// if the value is the same that it already is then don't do anything
			if( _verticalAlign == value )
			{
				return;
			}

			// change the value and rerender the text
			_verticalAlign = value;
			render();
		}


		/**
		 * The space between the letters.
		 */
		protected var _letterSpacing:Number = 5;


		/**
		 *
		 * @return
		 */
		public function get letterSpacing():Number
		{
			return _letterSpacing;
		}


		/**
		 *
		 * @param value
		 */
		public function set letterSpacing( value:Number ):void
		{

			// if the value is the same that it already is then don't do anything
			if( _letterSpacing == value )
			{
				return;
			}

			// change the value and rerender the text
			_letterSpacing = value;
			render();
		}


		/**
		 * The method to determine letter spacing.
		 */
		protected var _letterSpacingMethod:String = CHARACTER_SPACING;
		
		
		/**
		 *
		 * @return
		 */
		public function get letterSpacingMethod():String
		{
			return _letterSpacingMethod;
		}
		
		
		/**
		 *
		 * @param value
		 */
		public function set letterSpacingMethod(value:String):void
		{
			
			// if the value is the same that it already is then don't do anything
			if( _letterSpacingMethod == value ) return;
			
			// change the value and rerender the text
			_letterSpacingMethod = value;
			render();
		}
		
		
		/**
		 * Text for the area. This is the text that the user types.
		 */
		private var _text:String = "";


		/**
		 *
		 * @return
		 */
		public function get text():String
		{
			return _text;
		}


		/**
		 *
		 * @param value
		 */
		public function set text( value:String ):void
		{

			// compare the value to the stored value. We will treat null as an empty string.
			if( value === null )
			{
				value = "";
			}

			if( value == _text )
			{
				return;
			}

			// store a new TextChange object that changes the text completely.
			textChanges.push( new TextChange( TextChange.COMPLETE_CHANGE, value ));

			_text = value;

			// process the changes that are requested
			processTextChanges();
		}


		/**
		 * This is a string of the characters from the Letter objects in the lettersByIndex array.
		 */
		private var _lettersString:String = "";


		/**
		 *
		 * @param value
		 */
		protected function set lettersString( value:String ):void
		{
			_lettersString = value;
		}


		/**
		 * all the Letter objects for each letter image, stored at the same index they appear in the string.
		 * Be aware about looping through this array, it is likely at any index that there won't be an object, for spaces and unrecognized characters.
		 */
		private var _lettersByIndex:Array = new Array();


		/**
		 *
		 * @return
		 */
		public function get lettersByIndex():Array
		{
			return _lettersByIndex;
		}


		/**
		 * The scale of the letter objects.
		 */
		public function get lettersScale():Number
		{

			if( scaleX == scaleY )
			{
				return scaleX;
			}
			else
			{
				return 1;
			}
		}


		/**
		 *
		 * @param value
		 */
		public function set lettersScale( value:Number ):void
		{
			scaleX = value;
			scaleY = value;

			dispatchEvent( new TextGroupEvent( TextGroupEvent.RENDER ));
		}


		private var _currentLetter:int = 0;


		/**
		 * A que of TextChange objects that are changes to the text of the area.
		 * These changes are executed in the processTextChanges function.
		 */
		protected var textChanges:Array = new Array();


		/**
		 *
		 * @param adapter
		 */
		public function TextGroup( adapter:ITextGroup = null )
		{

			_adapter = adapter;
		}


		/**
		 * Make an edit to the text. Only changes the affected letters and their associated Letter objects, and leaves the rest alone.
		 *
		 * @param index		The index where to start the edit.
		 * @param length	How many characters from the index to replace.
		 * @param newChars	The new characters to put in the editted area.
		 *
		 */
		public function placeCharacters( index:int, length:uint, newChars:String ):void
		{

			// if there is nothing to do then do nothing
			if( !length && !newChars.length )
			{
				return;
			}

			// if the beigining index of the edit is beyond the end of the text
			if( index > _text.length )
			{

				// then the index will be placed at the end of the string
				index = _text.length;

				// and we don't replace characters since there aren't any after the end of the string
				length = 0;
			}

			// else if index is before the begining of the string
			else if( index < 0 )
			{

				// we want to shorten the length by how many the index is below 0
				length += index;

				// set the index to the begining of the string
				index = 0;
			}

			// get the characters up to the index, add the new characters,
			// add the characters after the index + length
			_text = _text.substring( 0, index ) + newChars + _text.substring( index + length );

			// que up the TextChange that will update the Letter objects.
			textChanges.push( new TextChange( TextChange.REPLACE_CHARACTERS, newChars, index, length ));

			processTextChanges();

			// if the user deleted some text then go ahead and render here
			if( newChars.length == 0 )
			{
				render();
			}
		}


		/**
		 * Remove all the letters.
		 */
		private function clearLetters():void
		{

			// get rid of all the letters
			for( var i:uint = 0, len:uint = _lettersByIndex.length; i < len; i++ )
			{
				clearLetter( _lettersByIndex[ i ] as Element );
			}

			// remove references to the old indexedLetterInfos by making a new blank array
			_lettersByIndex = new Array();
		}


		/**
		 * Remove the Letter child.
		 *
		 * @param letter	The Letter object to remove.
		 */
		private function clearLetter( letter:Element ):void
		{

			// if this function received nothing then it will do nothing
			if( !letter )
				return;

			if( contains( letter ))
			{
				removeElement( letter );
			}
		}


		/**
		 * load all the letters for the string.
		 */
		private function createLetters( newText:String ):void
		{

			// if we have no text then do nothing
			if( !newText )
			{
				return;
			}

			var letter:Element;
			var char:String;

			_lettersByIndex = new Array();

			_currentLetter += newText.length;
			
			// loop through all the characters in the string and create a letter info object for it
			for( var i:uint = 0, len:uint = newText.length; i < len; i++ )
			{

				// the character at index i
				char = newText.charAt( i );

				// create a Letter object for this character 
				createLetter( char, i );
			}
		}


		/**
		 * Create a letter object for this character.
		 *
		 * @param char The character to make a letter info object for.
		 */
		private function createLetter( char:String, index:int ):void
		{

			// add a listener to listen for when the letter is finished loading
			adapter.addEventListener( TextGroupEvent.EVENT_LETTER_LOADED, letterLoaded );
						
			// create the letter
			adapter.createLetter( char, _lettersByIndex, index );
		}


		/**
		 * Handler for once a letter has been loaded
		 * @param event
		 */
		private function letterLoaded( event:TextGroupEvent ):void
		{

			_currentLetter--;

			if (event.letter)
			{
				var thisLetter:IVisualElement = addElement(event.letter);
				// don't show the letter until it gets positioned
				thisLetter.visible = false;
			}
			
			// check if we have any more changes to work on and if not then go ahead and render the text
			if( textChanges.length == 0 && _currentLetter <= 0 && event.letter )
			{
				_currentLetter = 0;
				event.currentTarget.removeEventListener( TextGroupEvent.EVENT_LETTER_LOADED, letterLoaded );
				
				// TODO: figure a better way around this hack
				callLater(callLater,[callLater,[callLater,[render]]]);
			}
		}


		/**
		 * Looks are the current text and makes the changes
		 * @param change
		 */
		private function replaceCharacters( change:TextChange ):void
		{

			// if the beigining index of the edit is beyond the end of the text
			if( change.index > _lettersString.length )
			{

				// then the index will be placed at the end of the string
				change.index = _lettersString.length;

				// and we don't replace characters since there aren't any after the end of the string
				change.length = 0;
			}

			// if index is before the begining of the string
			else if( change.index < 0 )
			{

				// we want to shorten the length by how many the index is below 0
				change.length += change.index;

				// set the index to the begining of the string
				change.index = 0;
			}

			// will hold a reference to the letter we should select
			var letterToSelect:Element;

			// will hold the edited text
			var editedText:String = "";

			// a copy of the lettersByIndex array. Used to get references to the letters at the index they were at.
			var origLettersByIndex:Array = new Array().concat( _lettersByIndex );

			// will hold the current character for each loop
			var char:String;

			var letter:Element;

			// loop through the old letters
			for( var i:int = 0, newLettersIndex:uint = 0, len:uint = _lettersString.length; i <= len; i++, newLettersIndex++ )
			{

				// if our looping is at the index where we want to make the edit
				if( i == change.index )
				{

					// if length is greater than 0, meaning that we're replacing some characters from the text
					if( change.length )
					{

						// loop through the indexed letter array and remove those letters
						for( var limit:uint = i + change.length; i < limit; i++ )
						{

							// remove this letter from the display
							clearLetter( origLettersByIndex[ i ] as Element );
						}

						_lettersByIndex.splice( change.index, change.length );
					}

					_currentLetter+=change.text.length;
					
					// loop through the new characters
					for( var j:uint = 0, jen:uint = change.text.length; j < jen; j++, newLettersIndex++ )
					{

						// get the new character at this index
						char = change.text.charAt( j );

						createLetter(char, newLettersIndex);
						
						// if there was a character made, instead of a space
						if( _lettersByIndex[ newLettersIndex ])
						{

							// we want to select the last new letter
							letterToSelect = _lettersByIndex[ newLettersIndex ];
						}
						else // else there was a space so update the screen to include the space
						{
							render();
						}

						// add the new character to the edited text
						editedText += char;
					}

					// if the index is at the end or beyond the end of the text
					// then we're done building the array of letters
					if( change.index + change.length >= len )
					{

						// if we created less new characters than letters we replaced
						if( change.text.length < change.length )
						{

							// then get rid of that many positions at the end of the array
							_lettersByIndex.splice( change.index + change.text.length, change.length - change.text.length );
						}

						// we are done so exit the for loop
						break;
					}
				}

				// we are not at the index where the change happened
				// but if we are beyond the end of the original text
				else if( i >= len )
				{

					// if the new string is shorter than the original string
					if( newLettersIndex < len )
					{

						// then get rid of the items at the end
						_lettersByIndex.splice( newLettersIndex, len - newLettersIndex );
					}

					break;
				}

				// get the letter that was at this index
				letter = origLettersByIndex[ i ];

				// keep the letter info at the new index
				_lettersByIndex[ newLettersIndex ] = letter;

				// add this character to the edited text
				editedText += _lettersString.charAt( i );
			}

			// replace the text with the text we just build.
			// use the lettersString setter to put it into the node as well.
			lettersString = editedText;
		}


		/**
		 * Positions all of the letters
		 */
		private function layoutLetters():void
		{

			// if there are no letter objects in the array then we don't have anything to layout, so do nothing
			if( !_lettersByIndex.length )
				return;

			// as we loop through we'll place the next letter at this position, and it will change after each letter
			var pos:Number = 0;

			var position:Point;
			var matrix:Matrix;
			var lettersByPosition:Dictionary = new Dictionary();

			// create a new rectangle to store the text block information
			var textBlockRect:Rectangle = new Rectangle();

			// loop through the letters and position them
			for( var i:uint = 0, len:uint = _lettersByIndex.length; i < len; i++ )
			{

				var letter:Element = _lettersByIndex[ i ];
				var lastLetter:Element;
				var minSpacing:Number = 0;
				
				// if there is a letter object for this character at this position
				if( letter )
				{

					if(i>0)
					{
						/**
						 *  NOTICE!:
						 *  If vertical text, or vertical text alignment is every fully implemented
						 *  the getMinimumSpacing method will need to be updated to continue to work.
						 **/
						lastLetter = _lettersByIndex[i-1];
						if(lastLetter != null && letterSpacingMethod == CHARACTER_SPACING) minSpacing = VisualElementUtil.getMinimumSpacing(lastLetter, letter, this);
					}
	
					// create a new point ready to hold the layout information
					var letterPos:Point = new Point();

					if( _textDirection == DIRECTION_VERTICAL )
					{

						// store the letter's position
						letterPos.y = pos;
						letterPos.x = -Number( letter.width );

						// update the starting position for the next character
						pos += letter.height + _letterSpacing;

					}
					else
					{
						pos -= Number(minSpacing);
						
						// store the letter's position
						letterPos.x = pos;
						letterPos.y = -Number( letter.height );

						// update the starting position for the next character
						pos += letter.width + _letterSpacing;
					}

					// update the text block boundaries with this letter
					textBlockRect.left = Math.min( textBlockRect.left, letterPos.x );
					textBlockRect.top = Math.min( textBlockRect.top, letterPos.y );
					textBlockRect.right = Math.max( textBlockRect.right, letterPos.x + letter.width );
					textBlockRect.bottom = Math.max( textBlockRect.bottom, letterPos.y + letter.height );

					lettersByPosition[ letter ] = letterPos;

				}
				else
				{

					// so treat this character as a space and update the starting position for the next character
					pos += adapter.spaceWidth + _letterSpacing;
				}
			}

			// loop through the letters and position them
			for( var ltr:Object in lettersByPosition )
			{
				// new letters can be shown now
				ltr.visible = true;
				
				position = lettersByPosition[ ltr ];

				// reset the width and height of the text group
				width = textBlockRect.width;
				height = textBlockRect.height;

				matrix = ltr.transform.matrix;

				// if we want the direction to go vertical
				if( _textDirection == DIRECTION_VERTICAL )
				{

					// if we want the horizontal alignment to be on the left
					if( _horizontalAlign == HORIZONTAL_ALIGN_LEFT )
					{
						matrix.tx = 0;
					}
					else if( _horizontalAlign == HORIZONTAL_ALIGN_RIGHT ) // else if we want the horizontal alignment to be on the right
					{
						matrix.tx = ( -textBlockRect.left + position.x );
					}
					else // else we will center everything
					{
						matrix.tx = (( -textBlockRect.left + position.x ) / 2 );
					}

					matrix.ty = ( -textBlockRect.top + position.y );
				}

				// if we want the direction to go horizontal
				if( _textDirection == DIRECTION_HORIZONTAL )
				{

					// if we want the vertical alignment to be on the top
					if( _verticalAlign == VERTICAL_ALIGN_TOP )
					{
						matrix.ty = 0;			
					}
					else if( _verticalAlign == VERTICAL_ALIGN_BOTTOM ) // else if we want the vertical alignment to be on the bottom
					{
						matrix.ty = ( -textBlockRect.top + position.y );	
					}
					else // else if we want the vertical alignment to be in the middle
					{
						matrix.ty = (( -textBlockRect.top + position.y ) / 2 );
					}

					matrix.tx = ( -textBlockRect.left + position.x );
				}

				ltr.transform.matrix = matrix;
			}
			dispatchEvent( new TextGroupEvent( TextGroupEvent.LAYOUT ));

		}


		/**
		 * Adjust the display of the text
		 */
		private function render():void
		{

			if( _lettersByIndex.length > 0 )
			{
				layoutLetters();
			}

			// dispatch an event to indicate that the display has changed
			dispatchEvent( new TextGroupEvent( TextGroupEvent.RENDER ));
		}


		/**
		 * Apply the qued text changes.
		 */
		private function processTextChanges():void
		{

			var change:TextChange;
			
			// loop through all the text changes
			for each( var textChange:TextChange in textChanges )
			{

				change = textChange;
				textChanges.splice(textChanges.indexOf(textChange, 1));
				
				// if the textChange is a complete change of the text
				if( change.type == TextChange.COMPLETE_CHANGE )
				{

					// clear the current letters
					clearLetters();

					// create the new letters and catch the returned letter as the one we will select
					createLetters( change.text );

					// update the lettersString
					lettersString = change.text;

					// displatch an event to indicate that the text has completely changed
					dispatchEvent( new TextGroupEvent( TextGroupEvent.CHANGE ));
				}

				// else if the text change is replacing some of the characters
				else if( change.type == TextChange.REPLACE_CHARACTERS )
				{

					// pass the info to the replace characters function and catch the letter returned
					// as the letter to select
					replaceCharacters( change );

					// displatch an event to indicate that something has changed
					dispatchEvent( new TextGroupEvent( TextGroupEvent.REPLACE ));
				}				
			}

			// set the area's local text to the letter's string
			_text = _lettersString;
		}
	}
}


/**
 * Information on how to change the text.
 */
class TextChange
{
	/**
	 * The whole string is replaced by a new string.
	 */
	public static const COMPLETE_CHANGE:uint = 0;


	/**
	 * Replaces some characters, starting at index, extedended by the length count,
	 * and adds the text in that place.
	 */
	public static const REPLACE_CHARACTERS:uint = 1;


	/**
	 * The type of change this is. Use the constants' values for this.
	 */
	public var type:uint;


	/**
	 * The text for this change. Used for complete and replace characters changes.
	 */
	public var text:String;


	/**
	 * Index of the beginning of the change. Used for a replace characters change.
	 */
	public var index:uint;


	/**
	 * The length of the change from the index. Used for a replace characters change.
	 */
	public var length:uint;


	/**
	 * The current letter being processed.  Used for keeping track of how many letters are left to process.
	 */
	public var currentIndex:int = 0;


	/**
	 * Store the change parameters when the object is created.
	 */
	public function TextChange( type:uint, text:String = "", index:uint = 0, length:uint = 0 )
	{
		this.type = type;
		this.text = text;
		this.index = index;
		this.length = length;
		this.currentIndex = text.length;
	}
}
