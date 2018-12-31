/*
 	Name: fn_lightB_Init
 	
 	Author(s):
		Renz

 	Description:
		Initializes lightBulb Chat and scripts 
		
		Issues:
		- Will show, but improperly when in: tank driver, some tank gunner
		- Will not show in sea vehicles
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		Called by ArmA via functions library.
*/

if (isServer) then {
	nul = [] execVM "\lightbulb\Functions\fn_ClientInit.sqf";
	
};



/* Debug Code
systemChat "Server Channels Active";
"lightBulbChat_serverPacket" addPublicVariableEventHandler {
		_netID = (lightBulbChat_serverPacket select 0);
		_chl = (lightBulbChat_serverPacket select 1);
		_msg = (lightBulbChat_serverPacket select 2);
		_sourceUnit = objectFromNetId _netID;
		_nearbyClients = [];
		_nearbyObjects = _sourceUnit nearEntities[["CAManBase", "Air", "Car", "Motorcycle", "Tank"],300];
		{	_crew = crew _x; 
			_nearbyClients = _nearbyClients + _crew;
		} forEach _nearbyObjects;
		lightBulbChat_clientPacket = [_netID, _chl, _msg];
		
		if (_chl == 0) exitWith {
			{if (isPlayer _x) then { (owner _x) publicVariableClient "lightBulbChat_clientPacket" } } forEach _nearbyClients;
		};
		
		if (_chl == 1) exitWith {
			{if (isPlayer _x AND {side _x == side _sourceUnit} ) then { (owner _x) publicVariableClient "lightBulbChat_clientPacket" } } forEach _nearbyClients
		};
		 
		if (_chl == 2) exitWith {
			{if (isPlayer _x AND {_x in (units group _sourceUnit) } ) then { (owner _x) publicVariableClient "lightBulbChat_clientPacket" }   } forEach _nearbyClients
		};
		
		if (_chl == 3) exitWith {
			{if (isPlayer _x AND {_x in (crew vehicle _sourceUnit) } ) then { (owner _x) publicVariableClient "lightBulbChat_clientPacket" } } forEach _nearbyClients
		};
		
		if (_chl == 4) exitWith {
			{if (isPlayer _x) then { (owner _x) publicVariableClient "lightBulbChat_clientPacket" } } forEach _nearbyClients;
		};
		
		if (_chl == 5) exitWith {
			{if (isPlayer _x AND {leader group _x == leader _x} ) then { (owner _x) publicVariableClient "lightBulbChat_clientPacket"} } forEach _nearbyClients;
		};
		
};

systemChat "Control Active";
_control = [] spawn {
	disableserialization;
	_ctrl = controlNull;
	_dspl = displayNull;
	for "_i" from 0 to 1 step 0 do {
		waitUntil {_dspl = (findDisplay 24); _ctrl = _dspl displayCtrl 101; str _ctrl != 'No control'}; player globalChat "Active";
		_dspl displayAddEventHandler ['KeyDown', {
			_dik = (_this select 1);
			if (_dik == 28 OR _dik == 156) then {
				RZ_source_g = ctrltext ((_this select 0) displayctrl 101);
				if (RZ_source_g != '') then {
					if (true) then {
						RZ_source_d = ctrltext ((finddisplay 63) displayctrl 101);
						if (RZ_source_d == 'Global channel') exitWith {RZ_source_d = 0};
						if (RZ_source_d == 'Side channel') exitWith {RZ_source_d = 1};
						if (RZ_source_d == 'Group channel') exitWith {RZ_source_d = 2};
						if (RZ_source_d == 'Vehicle channel') exitWith {RZ_source_d = 3};
						if (RZ_source_d == 'Direct communication') exitWith {RZ_source_d = 4};
						if (RZ_source_d == 'Command channel') exitWith {RZ_source_d = 5};
					};
					lightBulbChat_serverPacket = [netId player, RZ_source_d, RZ_source_g];
					publicVariableServer 'lightBulbChat_serverPacket'; 
				};
			};
			
		}];
		
		waituntil {_ctrl = (findDisplay 24) displayCtrl 101; str _ctrl == 'No control'}; player globalChat "Not Active";
	};
};

lightBulbChat_serverPacket = []; 
lightBulbChat_clientPacket = [];
remarkBank = [];
reference = [];
vehRole = "";
vehPoint = [];

systemChat "Client Packet Active";
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
	systemChat "Paragraph Active";
	_msgA = toArray _msg; 
	_msgLength = (count _msgA) - 1;
	_line = [];
	_lineLimit = 30;
	_paragraph = [];
	_wordLength = 0;
	_word = []; hint "1";
	{	if (_x == 32 OR _forEachIndex == _msgLength) then {
			comment "Manage spaces"; hint "5";	
			_line = _line + _word; 
			_line pushBack _x; 
			_word = []; 
			_wordLength = 0;	
		} else { 
			comment "Word builder"; 
			if (count _word == _lineLimit) then {
				comment "move word/part of word to next line";	
				player globalChat toString _word;
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
			player globalChat ("deleteAt " + str (_this select 1) );
		};
	};
	
};

systemChat "Display Active";
addMissionEventHandler ["Draw3D", {
	{	_remark = _x;    
		_unit = (_remark select 0);
		_visWorld = visiblePosition  _unit;
		_headPos = _unit modelToWorldVisual (_unit selectionPosition "Head");
		_visPos = _headPos;
		
		_veh = vehicle _unit; 
		if (_veh != _unit) then {
			_check = _veh getCargoIndex _unit;
			if (_check != (_remark select 4) ) then {
				
				_anchor = _veh worldToModelVisual [(_visWorld select 0), (_visWorld select 1), (_visWorld select 2) + 0.7];
				_x set [3,_anchor];
				_x set [4,_check];
			} else {
				_visPos = _veh modelToWorldVisual (_x select 3);
			};
		};
		
		hintSilent str _visPos; dot1 setpos _visPos;
		_dis =  _visPos distance positionCameraToWorld [0,0,0];
		_KK_getZoom = ( ( [0.5,0.5] distance worldToScreen positionCameraToWorld [0,1.05,1] ) * (getResolution select 5) );
		
		_textSize = ( (-0.00008*_dis) + 0.04) max 0;
		_n = 0;
		{	_n = _forEachIndex + 1;
			_m = (0.026933333*_n) + 0.025066667;
			_textHeight = ((_m*_dis) +  0.35);
			drawIcon3D ['#(argb,8,8,3)color(0,0,0,0)', (_remark select 2),  [(_visPos select 0), (_visPos select 1), (_visPos select 2) + (_textHeight / sqrt (_KK_getZoom + 0.07) )], 1, 1, 0, _x, 1.5, _textSize * sqrt (_KK_getZoom + 0.07), 'puristaMedium'];      
		} forEach (_remark select 1);
	} forEach remarkBank; 
	//hintSilent format["Remarks: %1\nReference: %2",remarkBank,reference];
}];
*/
