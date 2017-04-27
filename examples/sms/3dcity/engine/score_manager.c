#include "score_manager.h"
#include "font_manager.h"
#include "global_manager.h"

extern unsigned int global_high_score, custom_game_score;

void engine_score_manager_init()
{
	global_high_score = ORG_HIGH_SCORE;
	custom_game_score = 0;
}
void engine_score_manager_load()
{
	custom_game_score = 0;
}
void engine_score_manager_update(unsigned int score)
{
	custom_game_score += score;
	if (custom_game_score > MAX_HIGH_SCORE)
	{
		custom_game_score = MAX_HIGH_SCORE;
	}

	engine_font_manager_draw_score(custom_game_score, CUSTOM_LFT_SIDE, GLOBAL_TOP_LINE);
	if (custom_game_score > global_high_score)
	{
		global_high_score = custom_game_score;
		engine_font_manager_draw_score(global_high_score, CUSTOM_RGT_SIDE, GLOBAL_TOP_LINE);
	}
}
void engine_score_manager_draw_player()
{
	engine_font_manager_draw_score(custom_game_score, CUSTOM_LFT_SIDE, GLOBAL_TOP_LINE);
}
void engine_score_manager_draw_higher()
{
	engine_font_manager_draw_score(global_high_score, CUSTOM_RGT_SIDE, GLOBAL_TOP_LINE);
}
