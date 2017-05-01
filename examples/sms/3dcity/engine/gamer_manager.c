#include "gamer_manager.h"
#include "global_manager.h"
#include "sprite_manager.h"
#include <sms.h>

extern unsigned char hacker_level, hacker_sound;

extern unsigned char targetX, targetY, offset;
extern unsigned char bulletX[MAX_BULLETS], bulletY[MAX_BULLETS], bulletCheck[MAX_BULLETS];
extern unsigned char bulletIndex[MAX_BULLETS], bulletFrame[MAX_BULLETS], bulletDelay[MAX_BULLETS], bulletTimer[MAX_BULLETS];

// Private helper methods.
static void update_bullet(unsigned char index);
static void draw_bullet(unsigned char index);

void engine_gamer_manager_load()
{
	unsigned char index;

	targetX = 120;	
	targetY = 144;

	// Reset bullets.
	for (index = 0; index < MAX_BULLETS; ++index)
	{
		bulletX[index] = 0; bulletY[index] = 0; bulletCheck[index] = 0;
		bulletFrame[index] = 0;	bulletTimer[index] = 0;
	}
}

void engine_gamer_manager_update_bullets()
{
	unsigned char index;
	for (index = 0; index < MAX_BULLETS; ++index)
	{
		if (0 != bulletFrame[index])
		{
			update_bullet(index);
		}
	}
}
static void update_bullet(unsigned char index)
{
	bulletTimer[index]++;
	if (bulletTimer[index] > bulletDelay[index])
	{
		bulletTimer[index] = 0;
		bulletFrame[index]++;
		if (bulletFrame[index] > MAX_BULLET_FRAMES)
		{
			bulletFrame[index] = 0;
			bulletCheck[index] = 1;
		}

		draw_bullet(index);
	}
}

void engine_gamer_manager_update_target(int joypad1)
{
	if (0 == joypad1)
	{
		return;
	}

	offset = OFFSET_LARGE;
	if (joypad1 & JOY_FIREB)
	{
		offset = OFFSET_SMALL;
	}

	if (joypad1 & JOY_LEFT)
	{
		if (targetX <= GAMER_BOUNDS_LFT + OFFSET_SMALL)
		{
			targetX = 0;
		}
		else
		{
			targetX -= offset;
		}
	}
	if (joypad1 & JOY_RIGHT)
	{
		if (targetX >= GAMER_BOUNDS_RGT - OFFSET_SMALL)
		{
			targetX = GAMER_BOUNDS_RGT;
		}
		else
		{
			targetX += offset;
		}
	}
	if (joypad1 & JOY_UP)
	{
		if (targetY <= GAMER_BOUNDS_TOP + OFFSET_SMALL)
		{
			targetY = GAMER_BOUNDS_TOP;
		}
		else
		{
			targetY -= offset;
		}
	}
	if (joypad1 & JOY_DOWN)
	{
		if (targetY >= GAMER_BOUNDS_BOT - OFFSET_SMALL)
		{
			targetY = GAMER_BOUNDS_BOT;
		}
		else
		{
			targetY += offset;
		}
	}

	engine_gamer_manager_draw_target();
}

void engine_gamer_manager_trigger_bullet()
{
	unsigned char index;
	char shoot = UNSELECTED;

	for (index = 0; index < MAX_BULLETS; ++index)
	{
		if (0 == bulletFrame[index])
		{
			shoot = index;
			break;
		}
	}

	if (UNSELECTED == shoot)
	{
		return;
	}

	// Bullet "found".
	if (hacker_sound)
	{
		set_sound_freq(1, 10);
		set_sound_volume(1, 0x0A);
	}

	bulletFrame[shoot] = 1;
	bulletX[shoot] = targetX;
	bulletY[shoot] = targetY;
	draw_bullet(index);
}

void engine_gamer_manager_draw_target()
{
	engine_sprite_manager_draw_target(targetX, targetY);
}
static void draw_bullet(unsigned char index)
{	
	engine_sprite_manager_draw_bullet(bulletIndex[index], bulletX[index], bulletY[index], bulletFrame[index]);
}

void engine_gamer_manager_init()
{
	unsigned char index, delay;
	
	delay = 10;
	if (hacker_level)
	{
		delay = 7;
	}
	for (index = 0; index < MAX_BULLETS; ++index)
	{
		bulletIndex[index] = ORG_BULLET_INDEX + (4 * index);
		bulletDelay[index] = delay;
	}	
}
