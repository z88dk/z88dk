#include <arch/sms/SMSlib.h>
#include "../s8/types.h"
#include "../s8/vdp.h"
#include "game_bonus.h"
#include "game_data.h"
#include "game_setup.h"
#include "../resource.h"

#define LIFE		(30) // 0.5 sec
#define SPEED_Y		FIX16(0.5)

//one and only sprite
static fixPoint bonusPosition;
static u16 lifeTime;

static u8 bonusX, bonusY;

void bonus_init()
{
	SMS_loadTiles(bonus_300pts_bin, TILE_BONUS, bonus_300pts_bin_size);

	bonus_reset( );
}

//we don't care of moveAllowed with bonus
void bonus_update( u8 moveAllowed )
{
	u8 x,y;

	if (lifeTime == 0)	return;
	
	if (--lifeTime == 0)
		bonus_reset();

	x = bonusX; // & 0xFF;
	y = bonusY; // & 0xFF;
	
	SMS_addSprite(x+0 , y, TILE_BONUS);			
	SMS_addSprite(x+8 , y, TILE_BONUS+1);			
	SMS_addSprite(x+16, y, TILE_BONUS+2);
}

/*
void bonus_updateV( )
{

}
*/

void bonus_reset( )
{
	bonusPosition.y = GARAGE_Y;
	bonusY = fix16ToInt(bonusPosition.y); // & 0xFF;
	
	lifeTime = 0;
}


void bonus_kill( )
{
	bonus_reset( );
}


void bonus_pop(fixPoint *enemyPosition) __z88dk_fastcall
{	
	bonusPosition.x = enemyPosition->x; 
	bonusPosition.y = enemyPosition->y;
	
	//compute on pop, since it doesn't change
	bonusX = fix16ToInt(bonusPosition.x); // & 0xFF;
	bonusY = fix16ToInt(bonusPosition.y); // & 0xFF;
	
	lifeTime = LIFE;
}
