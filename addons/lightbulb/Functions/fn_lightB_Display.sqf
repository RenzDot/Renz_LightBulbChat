/*
 	Name: fn_lightB_Display
 	
 	Author(s):
		Renz

 	Description:
		Displays remarks in current remarkBank.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		[] call fn_lightB_Display;
*/

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