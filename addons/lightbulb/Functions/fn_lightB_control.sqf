/*
 	Name: fn_lightB_control
 	
 	Author(s):
		Renz

 	Description:
		Communicates with server.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		[] call fn_lightB_control;
*/

_control = [] spawn {
	disableserialization;
	_ctrl = controlNull;
	_dspl = displayNull;
	for "_i" from 0 to 1 step 0 do {
		waitUntil {_dspl = (findDisplay 24); _ctrl = _dspl displayCtrl 101; str _ctrl != 'No control'}; 
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
		
		waituntil {_ctrl = (findDisplay 24) displayCtrl 101; str _ctrl == 'No control'};
	};
};