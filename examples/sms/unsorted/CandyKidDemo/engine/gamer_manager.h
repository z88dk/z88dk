#ifndef _GAMER_MANAGER_H_
#define _GAMER_MANAGER_H_

extern unsigned char kidX, kidY, velZ, kidColor, kidFrame, kidTile;
extern unsigned char pathIndex, prevIndex, moveFrame, direction, lifecycle;

#define KID_BASE_TILE	SPRITE_TILES + 0

static void kid_calculate_tile();

void engine_gamer_manager_init()
{
	kidColor = 0;
	pathIndex = 0;
	prevIndex = 0;
	moveFrame = 0;
}
void engine_gamer_manager_load()
{
	kidX = 32;
	kidY = 32;
	velZ = 0;
	kidFrame = 0;
	kid_calculate_tile();
	direction = DIRECTION_NONE;
	lifecycle = LIFECYCLE_IDLE;
}
void engine_gamer_manager_toggle_color()
{
	kidColor = (1 - kidColor);
	kid_calculate_tile();
}
void engine_gamer_manager_toggle_frame()
{
	kidFrame = (1 - kidFrame);
	kid_calculate_tile();
}
void engine_gamer_manager_move()
{
	lifecycle = LIFECYCLE_MOVE;
	engine_gamer_manager_toggle_frame();
}
void engine_gamer_manager_update()
{
	velZ += hacker_steps;
	if (velZ >= GAMER_MAX_STEPS)
	{
		velZ = 0;
		if (1 == kidFrame)
		{
			engine_gamer_manager_toggle_frame();
		}
		else
		{
			lifecycle = LIFECYCLE_IDLE;
		}
	}

	if (DIRECTION_UP == direction)
	{
		kidY -= hacker_steps;
	}
	if (DIRECTION_DOWN == direction)
	{
		kidY += hacker_steps;
	}
	if (DIRECTION_LEFT == direction)
	{
		kidX -= hacker_steps;
	}
	if (DIRECTION_RIGHT == direction)
	{
		kidX += hacker_steps;
	}
}
void engine_gamer_manager_draw()
{
	engine_sprite_manager_draw(kidX, kidY, kidTile);
}

static void kid_calculate_tile()
{
	kidTile = KID_BASE_TILE + ((kidColor * 2) + kidFrame) * 2;
}

#endif//_GAMER_MANAGER_H_