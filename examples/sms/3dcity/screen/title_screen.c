#include "title_screen.h"
#include "../engine/font_manager.h"
#include "../engine/global_manager.h"
#include "../engine/locale_manager.h"
#include "../engine/tile_manager.h"
#include <sms.h>
#include <stdlib.h>

extern unsigned int screen_bases_screen_count;
extern unsigned int screen_bases_screen_timer;
extern unsigned char screen_title_screen_delay;

void screen_title_screen_init()
{	
	screen_title_screen_delay = 50;
}

void screen_title_screen_load()
{
	engine_tile_manager_draw();
	engine_font_manager_draw_text(LOCALE_TITLE, GLOBAL_LFT_SIDE, GLOBAL_TOP_LINE);
	engine_font_manager_draw_text(LOCALE_START, GLOBAL_LFT_SIDE, GLOBAL_MID_LINE);

	engine_font_manager_draw_text(LOCALE_SEGA, GLOBAL_TXT_START, GLOBAL_TXT_LINE1);
	engine_font_manager_draw_text(LOCALE_TITLE1, GLOBAL_TXT_START, GLOBAL_TXT_LINE2);
	engine_font_manager_draw_text(LOCALE_TITLE2, GLOBAL_TXT_START, GLOBAL_TXT_LINE3);
}

void screen_title_screen_update(int *screen_type, int curr_joypad1, int prev_joypad1)
{
	rand();
	engine_tile_manager_update_middle();

	screen_bases_screen_timer++;
	if (screen_bases_screen_timer >= screen_title_screen_delay)
	{
		char *text = screen_bases_screen_count ? LOCALE_START : LOCALE_BLANK;
		engine_font_manager_draw_text(text, 1, GLOBAL_MID_LINE);

		screen_bases_screen_count = !screen_bases_screen_count;
		screen_bases_screen_timer = 0;
	}

	if (curr_joypad1 & JOY_FIREA && !(prev_joypad1 & JOY_FIREA) || curr_joypad1 & JOY_FIREB && !(prev_joypad1 & JOY_FIREB))
	{
		engine_font_manager_draw_text(LOCALE_BLANK, GLOBAL_LFT_SIDE, GLOBAL_MID_LINE);
		*screen_type = 3;//screen_type_level;
	}
}
