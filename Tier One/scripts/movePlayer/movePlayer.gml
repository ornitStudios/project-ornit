var _id = argument0
var _currentInput = argument1

with(_id)
{
	#region Unpack Variables
	
	var hButton = _currentInput[NINJA_UNREAD_INPUTS.HBUTTON]
	var vButton = _currentInput[NINJA_UNREAD_INPUTS.VBUTTON]
	var packetNumber= _currentInput[NINJA_UNREAD_INPUTS.PACKET_NUMBER]
	var gunAngle = _currentInput[NINJA_UNREAD_INPUTS.GUN_ANGLE]
	var deltaTime = _currentInput[NINJA_UNREAD_INPUTS.DELTA_TIME]
		
	
	#endregion

	//Apply horisontal player input
	var hMove = hButton * walksp * deltaTime / ONE_MILLION;	

	//Apply Gravity
	vsp += grv * deltaTime / ONE_MILLION;
	
	//Check grounded
	var grounded = (InFloor(tilemap,x,bbox_bottom+1) >= 0)

	var left = InFloor(tilemap,bbox_left,bbox_bottom+1)
	var right = InFloor(tilemap,bbox_right,bbox_bottom+1)
	
	//jump
	if(grounded || right >= 0 || left >= 0)
	{
		if(vButton)
		{
			vsp = -jump_speed;
			grounded = false;
		}
	}
	
	//clamp vsp
	vsp = clamp(vsp, -maxVsp, maxVsp)
	
	
	//Calculate vMove
	var vMove = vsp * deltaTime / ONE_MILLION;
	
	//Re apply fractions
	hMove += hMove_fraction;
	vMove += vMove_fraction;

	//Store and Remove fractions
	//Important: go into collision with whole integers ONLY!
	hMove_fraction = hMove - (floor(abs(hMove)) * sign(hMove));
	hMove -= hMove_fraction;
	vMove_fraction = vMove - (floor(abs(vMove)) * sign(vMove));
	vMove -= vMove_fraction;

	//Horisontal collision
	var bbox_side = hMove>0 ? bbox_right : bbox_left;

	var p1 = tilemap_get_at_pixel(tilemap,bbox_side+hMove,bbox_top);
	var p2 = tilemap_get_at_pixel(tilemap,bbox_side+hMove,bbox_bottom);

	if(tilemap_get_at_pixel(tilemap,x,bbox_bottom+1) > 1) p2 = 0; //if on a slope ignore collision

	if (p1 == 1) || (p2 == 1) //inside a tile with a collision
	{
		if (hMove > 0) x = x - (x mod TILE_SIZE) + (TILE_SIZE-1) - (bbox_right - x);
		else x = x - (x mod TILE_SIZE) - (bbox_left - x);
		hMove = 0;
		hsp = 0;
		
	}
	
	x += hMove;


	//Vertical Collision
	if (vMove >= 0) bbox_side = bbox_bottom; else bbox_side = bbox_top;
	if (tilemap_get_at_pixel(tilemap,x,bbox_side+vMove) <=1)
	{
		p1 = tilemap_get_at_pixel(tilemap,bbox_left,bbox_side+vMove) 
		p2 = tilemap_get_at_pixel(tilemap,bbox_right,bbox_side+vMove)
	
	
		if (p1 == 1) || (p2 == 1)
		{
			if (vMove >= 0) y = y - (y mod TILE_SIZE) + (TILE_SIZE-1) - (bbox_bottom - y);
			else y = y - (y mod TILE_SIZE) - (bbox_top - y);
			vMove = 0;
			vsp = 0;
		}
	}

	y += vMove; 


	var floorDist = InFloor(tilemap,x,bbox_bottom)

	if (floorDist >= 0)
	{
		y -= floorDist + 1; 
		vsp = 0;
		vMove = 0;
		floorDist = -1;
	}
	
	#region Walk down slope, bounce protection
	if(grounded)
	{
		if(abs(floorDist) < 10) //snap limit of 10 if greater then obv not moving onto next tile
		{
			y += abs(floorDist) - 1 //moves to base of tileset
		
			if((bbox_bottom mod TILE_SIZE) == TILE_SIZE-1) //if at base of current tile
			{
			
				//if the slope continues 
				var tmap = tilemap_get_at_pixel(tilemap,x,bbox_bottom + 1)
				if(tmap > 1)
				{
					//move there
					var dis = InFloor(tilemap,x,bbox_bottom+1);
					y += abs(dis)
				}
			
			}
		}
		
	}
	#endregion


	var roofDist = InRoof(tilemap,x,bbox_top-1)

	if(roofDist > 0)
	{
		//check isnt just tile below
		var floorDist = InFloor(tilemap,x,bbox_top-1)
		if(floorDist >= 0) //if floorDist < 0 likely that the player is standing at the very bottom of a ramp
		{
			var r = 0
			while(roofDist > -1) //sometimes will move player down and into a new tile
			{
				y += (roofDist + 1)
				vsp = 0
				vMove = 0;
				roofDist = InRoof(tilemap,x,bbox_top-1)
				r++
			}
		}

	}	
	else
	{
		var left = InRoof(tilemap,bbox_left,bbox_top-1)
		var right = InRoof(tilemap,bbox_right,bbox_top-1)

		var dis = max(left,right)

		var floorDistL = InFloor(tilemap,bbox_left,bbox_top-1)
		var floorDistR = InFloor(tilemap,bbox_right,bbox_top-1)
	
		var floorDist = max(floorDistL, floorDistR)
	
		if(floorDist >= 0) //if floorDist < 0 likely that the player is standing at the very bottom of a ramp
		{
			var r = 0
			while(dis > -1) //sometimes will move player down and into a new tile
			{
				y += (dis + 1)
				vsp = 0
				vMove = 0
			
				//redefine dis
				var left = InRoof(tilemap,bbox_left,bbox_top-1)
				var right = InRoof(tilemap,bbox_right,bbox_top-1)
	
				var dis = max(left,right)
				r++
			}
		}
	}
				

	if (hMove != 0) image_xscale = sign(hMove);
}