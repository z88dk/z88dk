#include "tile_manager.h"

#include "../tile/bottom_tile.h"
#include "../tile/middle_tile.h"
#include "../tile/splash_tile.h"
#include "../tile/tophalf_tile.h"

extern unsigned char hacker_tiles, hacker_stars;
extern unsigned char middle_count, middle_total, middle_delay1, middle_delay2;
extern unsigned char bottom_count, bottom_delay, bottom_total1, bottom_total2, bottom_total3;

void engine_tile_manager_init()
{
	bottom_count = 0;
	middle_count = 0;
	middle_delay1 = MID_DELAY1;
	middle_delay2 = MID_DELAY2;
	middle_total = middle_delay1 + middle_delay2;

	engine_tile_tophalf_load_tiles(BEG_TOPHALF, NUM_TOPHALF);
	engine_tile_middle1_load_tiles(BEG_MIDDLE1, NUM_MIDDLE1);
	engine_tile_middle2_load_tiles(BEG_MIDDLE2, NUM_MIDDLE2);
	engine_tile_bottom1_load_tiles(BEG_BOTTOM1, NUM_BOTTOM);
	engine_tile_bottom2_load_tiles(BEG_BOTTOM2, NUM_BOTTOM);
	engine_tile_bottom2_load_tiles(BEG_BOTTOM3, NUM_BOTTOM);
	engine_tile_splash_load_tiles(BEG_SPLASH, NUM_SPLASH);
}

void engine_tile_manager_load(unsigned char level)
{
	bottom_delay = level;
	bottom_total1 = 1 * bottom_delay;
	bottom_total2 = 2 * bottom_delay;
	bottom_total3 = 3 * bottom_delay;
}

void engine_tile_manager_update_middle()
{
	if (!hacker_stars)
	{
		return;
	}

	middle_count++;
	if (middle_count >= middle_total)
	{
		engine_tile_middle1_show_tiles(0, 4, 32, 2);
		middle_count = 0;
	}
	else if (middle_count >= middle_delay1)
	{
		engine_tile_middle2_show_tiles(0, 4, 32, 2);
	}
}

void engine_tile_manager_update_bottom()
{
	if (!hacker_tiles)
	{
		return;
	}
	
	bottom_count++;
	if (bottom_count >= bottom_total3)
	{
		engine_tile_bottom1_show_tiles(0, 12, 32, 12);
		bottom_count = 0;
	}
	else if (bottom_count >= bottom_total2)
	{
		engine_tile_bottom3_show_tiles(0, 12, 32, 12);
	}
	else if (bottom_count >= bottom_total1)
	{
		engine_tile_bottom2_show_tiles(0, 12, 32, 12);
	}
}

void engine_tile_manager_draw()
{
	engine_tile_tophalf_show_tiles(0, 0, 32, 12);
	engine_tile_middle1_show_tiles(0, 4, 32, 2);
	engine_tile_bottom1_show_tiles(0, 12, 32, 12);
}
