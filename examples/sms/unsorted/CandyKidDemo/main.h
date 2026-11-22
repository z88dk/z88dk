#ifndef __MAIN__
#define __MAIN__

#include <stdbool.h>
#include <stdlib.h>
#include <arch/sms/SMSlib.h>
#include <arch/sms/PSGlib.h>
#include "gfx.h"
#include "psg.h"

#include "engine/global_manager.h"
#include "engine/locale_manager.h"
#include "engine/hack_manager.h"
#include "engine/enum_manager.h"
#include "engine/content_manager.h"
#include "engine/font_manager.h"
#include "engine/path_manager.h"
#include "engine/text_manager.h"
#include "engine/tree_manager.h"
#include "engine/sound_manager.h"
#include "engine/sprite_manager.h"
#include "engine/gamer_manager.h"
#include "engine/enemy_manager.h"
#include "engine/input_manager.h"
#include "engine/asm_manager.h"

#include "screen/splash_screen.h"
#include "screen/title_screen.h"
#include "screen/ready_screen.h"
#include "screen/play_screen.h"

//_ENEMY_MANAGER_H_
unsigned char proX, proY, proColor, proFrame, proTile;
unsigned char adiX, adiY, adiColor, adiFrame, adiTile;
unsigned char suzX, suzY, suzColor, suzFrame, suzTile;
unsigned int enemy_delay,enemy_timer;

//_GAMER_MANAGER_H_
unsigned char kidX, kidY, velZ, kidColor, kidFrame, kidTile;
unsigned char pathIndex, prevIndex, moveFrame, direction, lifecycle;

//_PATH_MANAGER_H_
unsigned char gamer_route[GAMER_MAX_PATHS][GAMER_MAX_FRAME];

//_BASES_SCREEN_H_
unsigned int screen_bases_screen_count, screen_bases_screen_timer;

//_SPLASH_SCREEN_H_
unsigned char screen_splash_screen_delay;

#endif//__MAIN__