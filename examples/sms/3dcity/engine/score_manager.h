#ifndef _SCORE_MANAGER_H_
#define _SCORE_MANAGER_H_

#define MAX_HIGH_SCORE	50000
#define ORG_HIGH_SCORE	1000
#define CUSTOM_LFT_SIDE	9
#define CUSTOM_RGT_SIDE	30

void engine_score_manager_init();
void engine_score_manager_load();
void engine_score_manager_update(unsigned int score);

void engine_score_manager_draw_player();
void engine_score_manager_draw_higher();

#endif//_SCORE_MANAGER_H_
