/*
 	Name: fn_lightB_channels
 	
 	Author(s):
		Renz

 	Description:
		Manages messages from clients.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		[] call fn_lightB_channels;
*/

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


