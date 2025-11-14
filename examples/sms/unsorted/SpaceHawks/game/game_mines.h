#ifndef GAME_MINES_H
#define GAME_MINES_H

//for fixPoint
#include "game_data.h"

void mines_init( );
void mines_update( u8 moveAllowed );// __z88dk_fastcall;
//void mines_updateV( );
void mines_reset( );
void mines_kill( );

bool mines_collideBullet( );
bool mines_collideShip( );
void mines_launch(fix16 x, fix16 y, u8 count);

#endif /* GAME_MINES_H */
