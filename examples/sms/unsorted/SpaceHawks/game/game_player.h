#ifndef GAME_PLAYER_H
#define GAME_PLAYER_H

#include "game_enemies.h"
#include "game_data.h"

extern fixPoint shipPosition;

#define PLAYER_1	1
#define PLAYER_2	2


typedef struct
{
	u8 id;
	u8 level;
	u8 lives;
	u8 slots[NB_COL*NB_ROW];
	u16 score;  //score /10 (to keep u16)
}player;

extern player player1;
extern player player2;


void player_init( );
bool player_update( );
void player_updateV( );
void player_reset( );
bool player_isReady();
void player_hit();

void player_checkFlyingEnemies( );
void player_checkBombs( );
void player_checkMines( );


void player_inputPressed( u16 pressed, u16 state);
void player_inputReleased( u16 pressed, u16 state);

#endif /* GAME_PLAYER_H */
