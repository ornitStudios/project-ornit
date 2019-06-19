playerState = parent.playerState

switch playerState
{
	case PLAYER_STATE.PLAYING:
	{
		if(isLocal)
		{
			switch(state)
			{
				case PLAYERSTATE.FREE:
				{
					#region Local code
					var _unreadList = O_ClientManager.m_unreadImputs
					var _unreadListSize = array_length_1d(_unreadList)
	
					var _x = latest_acknowleged_packet[LOCAL_LATEST_POSITION.X];
					var _y = latest_acknowleged_packet[LOCAL_LATEST_POSITION.Y];

					var _hsp = latest_acknowleged_packet[LOCAL_LATEST_POSITION.HSP];
					var _vsp = latest_acknowleged_packet[LOCAL_LATEST_POSITION.VSP];	
					
					var _state = latest_acknowleged_packet[LOCAL_LATEST_POSITION.STATE]
	
					if (_unreadListSize != 0)
					{
						for (var i = _unreadListSize - 1; i >= 0; i--)
						{
							#region Loop through each unread imput and calucate a new position
							var _currentImput = _unreadList[i];
		
							var _deltaTime = _currentImput[UNREAD_IMPUTS.DELTA_TIME]
		
							_hsp = _currentImput[UNREAD_IMPUTS.HSP] * walksp * _deltaTime / ONE_MILLION;
		
							vMove = _currentImput[UNREAD_IMPUTS.VSP];
		
							_vsp += grv * _deltaTime / ONE_MILLION;

							//Jump
							if (place_meeting(_x,_y+1,oWall)) && (vMove = 1)
							{
								_vsp = -jump_speed	
							}

							//Horisontal collision
							if (place_meeting(_x+_hsp,_y,oWall))
							{
								while (!place_meeting(_x+sign(_hsp),_y,oWall))
								{
									_x += sign(_hsp);	
								}
								_hsp = 0;
							}
							_x += _hsp;

							//Vertical collision
				
							if (place_meeting(_x,_y+_vsp,oWall))
							{
								while (!place_meeting(_x,_y+sign(_vsp),oWall))
								{
									_y += sign(_vsp);	
								}
								_vsp = 0;
							}
							_y += _vsp;

							if (_hsp != 0) image_xscale = sign(_hsp);								
							#endregion
						}
					}
	
					x = _x;
					y = _y;
			
					#endregion
					break;	
				}
				
				case PLAYERSTATE.ATTACK_SLASH:
				{
				
					break;
				}
				
				case PLAYERSTATE.ATTACK_COMBO:
				{
					
					break;	
				}
			}
		}
		else
		{
			#region Interpolation code
			// Compute render timestamp.

			var now = current_time
			var render_timestamp = now - (1000.0 / SERVER_FPS);
  
			var buff_length = array_length_1d(m_coordinateArray)

			if (buff_length >= 2)
			{
				m_coordinateArray = fArrayTrim(m_coordinateArray,2)
				var old_position = m_coordinateArray[1]
				var new_position = m_coordinateArray[0]
				var buff_length = array_length_1d(m_coordinateArray)

				// Interpolate between the two surrounding authoritative positions.
				if ((buff_length >= 2) && (old_position[2] <= render_timestamp) && (render_timestamp <= new_position[2])) 
				{
					    var x0 = old_position[0];
					    var x1 = new_position[0];
		  
						var y0 = old_position[1];
						var y1 = new_position[1];
		
						var ga0 = old_position[3];
						var ga1 = new_position[3];
						
					    var t0 = old_position[2];
					    var t1 = new_position[2];

					    x = x0 + (x1 - x0) * (render_timestamp - t0) / (t1 - t0);
		  
						y = y0 + (y1 - y0) * (render_timestamp - t0) / (t1 - t0);
					
				}
			}
			#endregion
		}
		break;
	}
}

