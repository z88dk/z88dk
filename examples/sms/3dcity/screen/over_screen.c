#include "over_screen.h"
#include "../engine/font_manager.h"
#include "../engine/global_manager.h"
#include "../engine/locale_manager.h"
#include "../engine/tile_manager.h"
#include "../engine/sprite_manager.h"
#include <sms.h>

extern unsigned int screen_bases_screen_timer;
extern unsigned int screen_over_screen_delay;
extern unsigned char hacker_sound;

void screen_over_screen_init()
{
	screen_over_screen_delay = 500;
	if (hacker_sound)
	{
		screen_over_screen_delay -= EXPLOSION;
	}
}

void screen_over_screen_load()
{
	unsigned char pause;
	engine_font_manager_draw_text(LOCALE_OVER, GLOBAL_LFT_SIDE, GLOBAL_MID_LINE);
	
	// Game over "explosion".
	if (!hacker_sound)
	{
		return;
	}
	
	set_sound_freq(3, 0xE4);
	set_sound_volume(3, 0x0F);
	for (pause = 0; pause < EXPLOSION; ++pause)
	{
		wait_vblank_noint();
	}

	set_sound_volume(3, 0);
}

void screen_over_screen_update(int *screen_type, int curr_joypad1, int prev_joypad1)
{
	unsigned char title;
	engine_tile_manager_update_middle();

	screen_bases_screen_timer++;
	if (screen_bases_screen_timer < screen_over_screen_delay / 2)
	{
		return;
	}

	title = 0;
	if (curr_joypad1 & JOY_FIREA && !(prev_joypad1 & JOY_FIREA) || curr_joypad1 & JOY_FIREB && !(prev_joypad1 & JOY_FIREB))
	{
		title = 1;
	}

	if (screen_bases_screen_timer >= screen_over_screen_delay)
	{
		title = 1;
	}
	
	if (title)
	{
		engine_font_manager_draw_text(LOCALE_BLANK, GLOBAL_LFT_SIDE, GLOBAL_MID_LINE);
		engine_sprite_manager_clear();
		*screen_type = 2;//screen_type_title;
	}
}
