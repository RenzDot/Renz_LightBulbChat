/*
 	Name: ServerInit
 	
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


nul = [] execVM "fn_lightB_channels.sqf";

fn_lightB_chatHat = preprocessFileLineNumbers "fn_lightB_chatHat.sqf"; 
fn_lightB_paragraph = preprocessFileLineNumbers "fn_lightB_paragraph.sqf";
fn_lightB_special = preprocessFileLineNumbers "fn_lightB_special.sqf";
fn_lightB_control = preprocessFileLineNumbers "fn_lightB_control.sqf";
fn_lightB_clientPacket =  preprocessFileLineNumbers "fn_lightB_clientPacket.sqf";
fn_lightB_Display = preprocessFileLineNumbers "fn_lightB_Display.sqf";

_public = [] spawn {
	{	_var = _x;
		_codePacket = [_var] spawn {publicVariable (_this select 0) }; 
		waitUntil{ scriptDone _codePacket} 
	} forEach ["fn_lightB_paragraph","fn_lightB_special","fn_lightB_chatHat","fn_lightB_control","fn_lightB_clientPacket","fn_lightB_Display"];
	
	
};



[{
	if (!(isNil "fn_lightB_chatHat")) exitWith {};
	waitUntil{ !(isNil "fn_lightB_chatHat") AND !(isNil "fn_lightB_clientPacket") AND !(isNil "fn_lightB_control") AND !(isNil "fn_lightB_Display") };
	_nul = [] spawn compile fn_lightB_chatHat;
	
},"BIS_fnc_spawn"] call BIS_fnc_MP;


[] spawn compile fn_lightB_chatHat; 