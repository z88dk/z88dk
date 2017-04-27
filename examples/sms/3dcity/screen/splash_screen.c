#include "splash_screen.h"
#include "../tile/splash_tile.h"
#include <sms.h>

extern unsigned int screen_bases_screen_count;
extern unsigned int screen_bases_screen_timer;
extern unsigned char screen_splash_screen_delay;

void screen_splash_screen_init()
{
	screen_splash_screen_delay = 150;
}
void screen_splash_screen_load()
{
	engine_tile_splash_show_tiles(0, 0, 32, 24);
}

void screen_splash_screen_update(int *screen_type, int curr_joypad1, int prev_joypad1)
{
	unsigned char level = 0;
	if (curr_joypad1 & JOY_FIREA && !(prev_joypad1 & JOY_FIREA) || curr_joypad1 & JOY_FIREB && !(prev_joypad1 & JOY_FIREB))
	{
		level = 1;
	}
	screen_bases_screen_timer++;
	if (screen_bases_screen_timer >= screen_splash_screen_delay)
	{
		level = 1;
	}

	if (level)
	{
		*screen_type = 2;//screen_type_title;
	}
}
