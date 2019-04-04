//cb_T2_LocalPlayerInfo()
var _connectionId  = argument0;
var _receivedData  = argument1;

var _clientId = _receivedData[0]; //buffer_8
var _character = _receivedData[1]; //buffer_u6
var _username = _receivedData[2]; //buffer_string

fConsoleAddMessage("Received Local Player info which was " + string(_receivedData))

with (instance_create_depth(0,0,0,oPlayer))
{
	m_PlayerId = _clientId	
	playerState = PLAYER_STATE.PLAYING
	isLocal = true
	
	switch _character
	{
		case CHARACTER_LIST.NINJA:
		{
			hero = instance_create_depth(0,0,-100,oNinja)
			hero.itemList[NINJA_ITEMS.GUN] = instance_create_depth(0,0,-101,oNinjaGun)
			break;	
		}
	}
	
	with (hero)
	{
		isLocal = true
		latest_acknowleged_packet = [0,0,0,0,0,current_time] //update most recent position knowledge
		parent = other.id
		m_username = _username
		m_character = _character
	}
	
	with (oCamera)
	{
		localPlayer = other.id //make the camera follow the local player
		xTo = x = other.hero.x + (mouse_x - other.hero.x)/4 //snap x xoords
		yTo = y = other.hero.y + (mouse_y - other.hero.y)/4 //snap y coords
		state = CAMERA_STATE.FOLLOW_PLAYER_CREATE	
	}
}

with (O_ClientManager)
{
	managerState = PLAYING
}

