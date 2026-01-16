#ifndef GAME_BONUS_H
#define GAME_BONUS_H


//for fixPoint
#include "game_data.h"

void bonus_init( );
void bonus_update( u8 moveAllowed );
//void bonus_updateV( );
void bonus_reset( );
void bonus_kill( );

void bonus_pop(fixPoint *enemyPosition) __z88dk_fastcall;

#endif /* GAME_BONUS_H */
