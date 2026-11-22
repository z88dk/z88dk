#ifndef GAME_ENEMIES_H
#define GAME_ENEMIES_H

//for fixPoint
#include "game_data.h"

#define MAX_ENEMIES 5 	//number MAX of sprites flying across the screen
						// we need a lot for difficulty 7
						
//bullet speed vs bomb speed let me expect a 'small' number of bombs on screen at the same time
#define MAX_BOMBS 3 //number MAX of falling bomb
					//they fall fast so we don't need a lot but 2 is not enough

#define NB_ROW	5
#define NB_COL	6

#define SLOT_EMPTY	0	//no more enemy on this slot
#define SLOT_READY	1	//enemy slot
#define SLOT_BUSY	2	//enemy is currently flying

#define COLLIDE_NONE	0
#define COLLIDE_ENEMY	1
#define COLLIDE_FLYING	2
#define COLLIDE_BOMB	3

void enemies_init( );
void enemies_update( u8 moveAllowed );
void enemies_updateV( );
void enemies_reset( );
void enemies_kill( );

bool enemies_areDead();

bool enemies_flyingVSShip(/*fixPoint *shipPosition*/);
bool enemies_bombVSShip(/*fixPoint *shipPosition*/);

bool enemies_groupVSBullet();
bool enemies_flyingVSBullet();
bool enemies_bombVSBullet();


#endif /* GAME_ENEMIES_H */
