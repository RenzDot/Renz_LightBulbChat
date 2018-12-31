/*
 	Name: fn_lightB_clientPacket
 	
 	Author(s):
		Renz

 	Description:
		Manages the remarkBank.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		[] call fn_lightB_clientPacket;
*/
lightBulbChat_serverPacket = []; 
lightBulbChat_clientPacket = [];
remarkBank = [];
reference = [];
vehRole = "";
vehPoint = [];


'lightBulbChat_clientPacket' addPublicVariableEventHandler {
	_sourceUnit = objectFromNetId (lightBulbChat_clientPacket select 0);
	_chl = (lightBulbChat_clientPacket select 1);
	_msg = (lightBulbChat_clientPacket select 2);
	
	_hex = [0,0,0];
	//Find Hex Colour
	if (true) then {
		if (_chl == 0) exitWith {_hex = [1,1,1,1] };
		if (_chl == 1) exitWith {_hex = [0.573,0.741,0.91,1] };
		if (_chl == 2) exitWith {_hex = [0.459,0.851,0.329,1] };
		if (_chl == 3) exitWith {_hex = [0.902,0.722,0,1] };
		if (_chl == 4) exitWith {_hex = [0.9,0.9,0.9,1] };
		if (_chl == 5) exitWith {_hex = [0.902,0.902,0.361,1] };
	};

	//Manage messages
	_lineLength = 30;
	_lead = -1;
	_unitFound = false;

	{	if ( (_x select 0) == _sourceUnit) exitWith {
			remarkBank deleteAt _forEachIndex; 
			reference deleteAt _forEachIndex;
		};
	} forEach remarkBank;
	
	//Constructor
	
	_msgA = toArray _msg; 
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
	
	
	_anchor = [0,0,1000];
	_role = -1;
	_vehUnit = vehicle _sourceUnit;
	if (_vehUnit != _sourceUnit) then {
		_visPos = visiblePosition _sourceUnit;
		_anchor = _vehUnit worldToModelVisual [(_visPos select 0), (_visPos select 1), (_visPos select 2) + 0.7];
		_role = _vehUnit getCargoIndex _sourceUnit;
	};
	
	_remark = [_sourceUnit,_paragraph,_hex,_anchor,_role];
	remarkBank pushBack _remark;
	
	_ref = str _remark;
	reference pushBack _ref;
	_special = [_ref] spawn fn_light_special;
	
	_nul = [_ref] spawn {
		uiSleep 15; 
		_index = reference find (_this select 0);
		if (_index > -1) then {
			remarkBank deleteAt _index;
			reference deleteAt _index;
			
		};
	};
	
};