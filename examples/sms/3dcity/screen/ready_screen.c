#include "ready_screen.h"
#include "../engine/enemy_manager.h"
#include "../engine/font_manager.h"
#include "../engine/gamer_manager.h"
#include "../engine/global_manager.h"
#include "../engine/locale_manager.h"
#include "../engine/music_manager.h"
#include "../engine/score_manager.h"
#include "../engine/tile_manager.h"
#include <sms.h>

extern unsigned char hacker_level, hacker_music;

extern unsigned int screen_bases_screen_count;
extern unsigned int screen_bases_screen_timer;
extern unsigned char screen_ready_screen_delay;

void screen_ready_screen_init()
{
	screen_ready_screen_delay = 100;
}

void screen_ready_screen_load()
{
	unsigned char delay;
	
	engine_score_manager_load();
	engine_enemy_manager_load();
	engine_gamer_manager_load();

	delay = 10;
	if (hacker_level)
	{
		delay = 7;
	}
	engine_tile_manager_load(delay);
	engine_tile_manager_draw();
	engine_font_manager_draw_text(LOCALE_TITLE, GLOBAL_LFT_SIDE, GLOBAL_TOP_LINE);
	engine_font_manager_draw_text(LOCALE_READY, GLOBAL_LFT_SIDE, GLOBAL_MID_LINE);

	// Draw score + high.
	engine_font_manager_draw_text(LOCALE_GAMER, GLOBAL_LFT_SIDE, GLOBAL_TOP_LINE);
	engine_score_manager_draw_player();
	engine_font_manager_draw_text(LOCALE_HIGHX, 23, GLOBAL_TOP_LINE);
	engine_score_manager_draw_higher();

	engine_gamer_manager_draw_target();
	if (hacker_music)
	{
		engine_music_manager_load_module();
		engine_music_manager_start_module();
	}
}

void screen_ready_screen_update(int *screen_type, int curr_joypad1, int prev_joypad1)
{
	unsigned char level = 0;
	engine_tile_manager_update_middle();
	engine_tile_manager_update_bottom();

	engine_gamer_manager_update_target(curr_joypad1);
	if (curr_joypad1 & JOY_FIREA && !(prev_joypad1 & JOY_FIREA) || curr_joypad1 & JOY_FIREB && !(prev_joypad1 & JOY_FIREB))
	{
		level = 1;
	}

	screen_bases_screen_timer++;
	if (screen_bases_screen_timer >= screen_ready_screen_delay)
	{
		level = 1;
	}
	
	if (level)
	{
		engine_font_manager_draw_text(LOCALE_BLANK, GLOBAL_LFT_SIDE, GLOBAL_MID_LINE);
		*screen_type = 5;//screen_type_play;
	}
}
