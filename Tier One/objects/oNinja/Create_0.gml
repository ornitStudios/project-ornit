m_coordinateArray = []

//Changeable variables
grv = 240;
walksp = 240;
jump_speed = 200;



hp = 100;

hasControl = true;

showingHitbox = false

parent = null

enum NINJA_ITEMS
{
	GUN	
}

itemList = []

itemList[NINJA_ITEMS.GUN] = instance_create_depth(0,0,-101,oNinjaGun)

m_unreadInputs = undefined

m_unreadInputs = ds_list_create()