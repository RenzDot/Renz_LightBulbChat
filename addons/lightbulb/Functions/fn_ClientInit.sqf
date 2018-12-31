fn_lightB_channels = preprocessFileLineNumbers "\lightbulb\Functions\fn_lightB_channels.sqf";
fn_lightB_control = preprocessFileLineNumbers "\lightbulb\Functions\fn_lightB_control.sqf";
fn_lightB_clientPacket = preprocessFileLineNumbers "\lightbulb\Functions\fn_lightB_clientPacket.sqf";
fn_lightB_Display = preprocessFileLineNumbers "\lightbulb\Functions\fn_lightB_Display.sqf";

_public = [] spawn {
	{	_var = _x;
		_codePacket = [_var] spawn {publicVariable (_this select 0) }; 
		waitUntil{ scriptDone _codePacket} 
	} forEach ["fn_lightB_channels","fn_lightB_control","fn_lightB_clientPacket","fn_lightB_Display"];
	
	
};

[{	waitUntil{ !(isNil "fn_lightB_channels") && !(isNil "fn_lightB_control") && !(isNil "fn_lightB_channels") &&  !(isNil "fn_lightB_channels") &&  !(isNil "fn_lightB_channels")  }; 
	nul = [] spawn compile fn_lightB_channels;
	nul = [] spawn compile fn_lightB_control;
	nul = [] spawn compile fn_lightB_clientPacket;
	nul = [] spawn compile fn_lightB_Display;
},"BIS_fnc_spawn",true,true] call BIS_fnc_MP;