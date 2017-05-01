#ifndef _MAIN_H_
#define _MAIN_H_

#include <sms.h>
#include <stdio.h>
#include <stdlib.h>

#include "engine/enemy_manager.h"
#include "engine/font_manager.h"
#include "engine/global_manager.h"
#include "engine/gamer_manager.h"
#include "engine/hack_manager.h"
#include "engine/locale_manager.h"
#include "engine/music_manager.h"
#include "engine/score_manager.h"
#include "engine/sprite_manager.h"
#include "engine/tile_manager.h"

#include "screen/bases_screen.h"
#include "screen/level_screen.h"
#include "screen/over_screen.h"
#include "screen/play_screen.h"
#include "screen/ready_screen.h"
#include "screen/splash_screen.h"
#include "screen/title_screen.h"

//_ENEMY_MANAGER_H_
unsigned char enemyX[MAX_ENEMIES], enemyY[MAX_ENEMIES];
unsigned char enemyStart[MAX_ENEMIES], enemyDelta[MAX_ENEMIES], enemyScore[MAX_ENEMIES];
unsigned char enemyCheck[MAX_ENEMIES], enemyFrame[MAX_ENEMIES], enemyTimer[MAX_ENEMIES];
unsigned char enemyIndex[MAX_ENEMIES], enemyDelay[MAX_ENEMIES], enemyWidth[MAX_ENEMIES];
char enemyBound[MAX_ENEMIES];
unsigned char bombsX[MAX_ENEMIES], bombsY[MAX_ENEMIES], explosions[MAX_ENEMIES];
unsigned char bombsIndex[MAX_ENEMIES], bombsDelay[MAX_ENEMIES], bombsFrame[MAX_ENEMIES], bombsTimer[MAX_ENEMIES];

//_GAMER_MANAGER_H_
unsigned char targetX, targetY, offset;
unsigned char bulletX[MAX_BULLETS], bulletY[MAX_BULLETS], bulletCheck[MAX_BULLETS];
unsigned char bulletIndex[MAX_BULLETS], bulletFrame[MAX_BULLETS], bulletDelay[MAX_BULLETS], bulletTimer[MAX_BULLETS];

//_SCORE_MANAGER_H_
unsigned int global_high_score, custom_game_score;

//_TILE_MANAGER_H_
unsigned char middle_count, middle_total, middle_delay1, middle_delay2;
unsigned char bottom_count, bottom_delay, bottom_total1, bottom_total2, bottom_total3;

//_BASES_SCREEN_H_
unsigned int screen_bases_screen_count, screen_bases_screen_timer;

//_SPLASH_SCREEN_H_
unsigned char screen_splash_screen_delay;

//_TITLE_SCREEN_H_
unsigned char screen_title_screen_delay;

//_READY_SCREEN_H_
unsigned char screen_ready_screen_delay;

//_PLAY_SCREEN_H_
unsigned char screen_play_screen_miss, screen_play_screen_base;

//_OVER_SCREEN_H_
unsigned int screen_over_screen_delay;


unsigned char pal1[] = {0x00, 0x02, 0x08, 0x0A, 0x20, 0x22, 0x28, 0x2A, 0x3F, 0x03, 0x0C, 0x0F, 0x30, 0x33, 0x3C, 0x3F};
unsigned char pal2[] = {0x00, 0x02, 0x08, 0x0A, 0x20, 0x22, 0x28, 0x2A, 0x3F, 0x03, 0x0C, 0x0F, 0x30, 0x33, 0x3C, 0x00};

#endif//_MAIN_H_
