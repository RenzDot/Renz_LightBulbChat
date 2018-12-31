/*
 	Name: fn_lightB_paragraph
 	
 	Author(s):
		Renz

 	Description:
		Splits a string it into segments. These segments are put into an array.
	
	Parameters:
		STRING - Any kind of string
 	
 	Returns:
		ARRAY - Array of strings
 	
 	Example:
		["This text should be line 1, And this text should be in line 2, and so on"] call fn_lightB_paragraph;
*/


_msgA = toArray (_this select 0); 
_msgLength = (count _msgA) - 1;
_line = [];
_lineLimit = 30;
_paragraph = [];
_wordLength = 0;
_word = []; 
{	if (_x == 32 OR _forEachIndex == _msgLength) then {
		comment "Manage spaces"; 
		_line = _line + _word; 
		_line pushBack _x; 
		_word = []; 
		_wordLength = 0;	
	} else { 
		comment "Word builder"; 
		if (count _word == _lineLimit) then {
			comment "move word/part of word to next line";	
			
			_paragraph pushBack (toString _word); comment "successfully";
			_word = [45,_x];
			_line = [];	
		} else {
			_word pushBack _x;
			_wordLength = count _word;	
		};
		
	};
	
	if ( (count _line + _wordLength) > _lineLimit OR _forEachIndex == _msgLength) then {
			_paragraph pushBack (toString _line); 
			_line = [];
	};
} forEach _msgA; 
reverse _paragraph;

_paragraph 