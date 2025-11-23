#ifndef GAME_BULLET_H
#define GAME_BULLET_H

#include "game_data.h"

extern fixPoint bulletPosition;

void bullet_init( );
void bullet_update( u8 moveAllowed ) __z88dk_fastcall;
//void bullet_updateV( );
void bullet_reset( );
void bullet_kill( );

void bullet_checkEnemies( );
void bullet_checkFlyingEnemies( );
void bullet_checkBombs( );
void bullet_checkMines( );

//called by game_player.c
void bullet_fire(fix16 x) __z88dk_fastcall;

#endif /* GAME_BULLET_H */
