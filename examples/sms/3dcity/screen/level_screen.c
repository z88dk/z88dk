#include "level_screen.h"
#include "../engine/font_manager.h"
#include "../engine/global_manager.h"
#include "../engine/locale_manager.h"
#include "../engine/tile_manager.h"
#include <sms.h>
#include <stdlib.h>

extern unsigned char hacker_level;

static void display_arrow();

void screen_level_screen_load()
{
	engine_tile_manager_draw();
	engine_font_manager_draw_text(LOCALE_TITLE, GLOBAL_LFT_SIDE, GLOBAL_TOP_LINE);
	engine_font_manager_draw_text(LOCALE_LEVEL, GLOBAL_LFT_SIDE, GLOBAL_MID_LINE);

	engine_font_manager_draw_text(LOCALE_LEVEL1, GLOBAL_TXT_START, GLOBAL_TXT_LINE2);
	engine_font_manager_draw_text(LOCALE_LEVEL2, GLOBAL_TXT_START, GLOBAL_TXT_LINE3);
	display_arrow();
}

static void display_arrow()
{
	char *easy = hacker_level ? LOCALE_SPACE : LOCALE_ARROW;
	char *hard = hacker_level ? LOCALE_ARROW : LOCALE_SPACE;
	char *text = hacker_level ? LOCALE_HARD : LOCALE_EASY;
	
	engine_font_manager_draw_text(easy, EASY_SIDE, GLOBAL_MID_LINE);
	engine_font_manager_draw_text(hard, HARD_SIDE, GLOBAL_MID_LINE);
	engine_font_manager_draw_text(text, GLOBAL_TXT_START, GLOBAL_TXT_LINE1);
}

void screen_level_screen_update(int *screen_type, int curr_joypad1, int prev_joypad1)
{
	rand();
	engine_tile_manager_update_middle();
	if (0 == curr_joypad1)
	{
		return;
	}

	// Select level and return.
	if (curr_joypad1 & JOY_FIREA && !(prev_joypad1 & JOY_FIREA) || curr_joypad1 & JOY_FIREB && !(prev_joypad1 & JOY_FIREB))
	{
		*screen_type = 4;//screen_type_ready;
		return;
	}

	if (curr_joypad1 & JOY_LEFT && !(prev_joypad1 & JOY_LEFT))
	{
		hacker_level = !hacker_level;
	}
	else if (curr_joypad1 & JOY_RIGHT && !(prev_joypad1 & JOY_RIGHT))
	{
		hacker_level = !hacker_level;
	}
	else if (curr_joypad1 & JOY_UP && !(prev_joypad1 & JOY_UP))
	{
		hacker_level = !hacker_level;
	}
	else if (curr_joypad1 & JOY_DOWN && !(prev_joypad1 & JOY_DOWN))
	{
		hacker_level = !hacker_level;
	}

	display_arrow();
}
