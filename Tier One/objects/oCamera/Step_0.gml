switch state
{
	case CAMERA_STATE.INIT:
	{
		state = CAMERA_STATE.SHOW_FULL_MAP	
		
		with (oRespawn)
		{
			state = RESPAWN_STATE.CLICKABLE
		}
		break;	
	}
	case CAMERA_STATE.FOLLOW_PLAYER:
	{
		#region Follow the player
		
		x += (xTo - x)/25
		y += (yTo - y)/25
		
		if (localPlayer != id)
		{
			xTo = localPlayer.hero.x + (mouse_x - other.x)/4 
			yTo = localPlayer.hero.y + (mouse_y - other.y)/4 
		}
		else
		{
			state = CAMERA_STATE.SHOW_FULL_MAP	
			
			with (oRespawn)
			{
				state = RESPAWN_STATE.CLICKABLE
			}
		}
		
		//Dont let it go outside
		x = clamp(x,cameraWidth/2,room_width - cameraWidth/2)
		y = clamp(y,cameraHeight/2,room_height - cameraHeight/2)
		
		var vm = matrix_build_lookat(x,y,depthMin,x,y,0,false,true,false);
		camera_set_view_mat(camera,vm);
		
		#endregion
		break;
	}
	
	case CAMERA_STATE.FOLLOW_PLAYER_CREATE:
	{
		#region Create event for following the player
		
		
		//check local isnt undefined
		if localPlayer == id
		{
			state = CAMERA_STATE.SHOW_FULL_MAP
			fConsoleAddMessage("Coldnt follow the player, no local player has been set (camera)")
		}
		
		//check hero isnt undefined
		if localPlayer.hero == null
		{
			state = CAMERA_STATE.SHOW_FULL_MAP
	
		}
		
		//change projection to zoom in
		cameraWidth = 1920;
		cameraHeight = 1080;
		var pm = matrix_build_projection_ortho(cameraWidth,cameraHeight,0,lookDistance);
		camera_set_proj_mat(camera,pm);
		
		x = localPlayer.hero.x;
		y = localPlayer.hero.y;
		
		//Dont let it go outside
		x = clamp(x,xResolution/2,room_width - xResolution/2);
		y = clamp(y,yResolution/2,room_height - yResolution/2);
		
		with (oRespawn)
		{
			state = RESPAWN_STATE.INACTIVE;
			buttonState = BUTTON_STATE.NOTHING;
		}
			
		
		//Set the state
		state = CAMERA_STATE.FOLLOW_PLAYER;
		
		#endregion
		break;	
	}
	
	case CAMERA_STATE.SHOW_FULL_MAP:
	{
		#region show full map
		
		var vm = matrix_build_lookat(room_width/2,room_height/2,depthMin,room_width/2,room_height/2,0,false,true,false);
		cameraWidth = room_width
		cameraHeight = room_height
		var pm = matrix_build_projection_ortho(cameraWidth,cameraHeight,0,lookDistance);
		
		camera_set_view_mat(camera,vm);
		camera_set_proj_mat(camera,pm);
		
		#endregion
		break;
	}
	
}