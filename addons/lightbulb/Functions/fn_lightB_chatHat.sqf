
[] spawn compile fn_lightB_clientPacket;
[] spawn compile fn_lightB_control;
[] spawn compile fn_lightB_display;

waitUntil{!isNil player};
lightBulbChat_JIP = netID player;
publicVariableServer "lightBulbChat_JIP";