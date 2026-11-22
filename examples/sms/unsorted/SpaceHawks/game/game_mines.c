#include <arch/sms/SMSlib.h>
#include "../s8/types.h"
#include "../s8/vdp.h"
#include "../s8/metasprite.h"
#include "game_mines.h"
#include "game_bullet.h"
#include "game_data.h"
#include "game_setup.h"
#include "../resource.h"

#define SPEED		FIX16(1)
#define	FLY_LEFT	0x00
#define FLY_RIGHT	0x01
#define FLY_UP		0x00
#define FLY_BOTTOM	0x10


//4 sprites max
static fixPoint minesPosition[4];

static u8 minesDir[4];
static u8 mineOnScreen;

void mines_init( )
{
	SMS_loadTiles(mine_bin, TILE_MINE, mine_bin_size);
	
	mines_reset( );
}

//don't use __z88dk_fastcall here, moveAllowed will be erased from stack
void mines_update( u8 moveAllowed ) //__z88dk_fastcall
{
	u8 i = 0;

	//optimisation tip : only one !
	//if you try to do the same with minesVelocity, you lost winning point of this method
	//because SDCC will rely on statck to switch from a pointer to another :(
	fixPoint *point;
	
	if (mineOnScreen == 0 )	return;

	point = &minesPosition[0];
	do
	{
		if (point->y == GARAGE_Y)	goto nextUpd;

		if (moveAllowed)
		{
			if (minesDir[i] & FLY_RIGHT)
			{
				point->x += SPEED;
				if (point->x > FIX16(31*8))	minesDir[i] &= 0xF0;
			}
			else
			{
				point->x -= SPEED;			
				if (point->x < FIX16(8))	minesDir[i] |= FLY_RIGHT;
			}
			
			if (minesDir[i] & FLY_BOTTOM)
			{
				point->y += SPEED;
				if (point->y > FIX16(23*8))	minesDir[i] &= 0x0F;
			}
			else
			{
				point->y -= SPEED;
				if (point->y < FIX16(8*2))	minesDir[i] |= FLY_BOTTOM;
			}
		}
		
		SMS_addSprite( fix16ToInt(point->x), fix16ToInt(point->y), TILE_MINE);
nextUpd:
		point++;
	}while(++i<4);
}

/*
void mines_updateV( )
{
	u8 i = 4;

	if (mineOnScreen == 0 )	return;
	
	for(i=0; i<4; i++)
	{
		fixPoint *point;
		point = &minesPosition[i];
		if (point->y == GARAGE_Y) continue;
		
		//nothing
	}
}
*/

void mines_reset( )
{
	u8 i;
	
	mineOnScreen = 0;

	for(i=0; i<4; i++)
	{
		minesPosition[i].y = GARAGE_Y;
		//minesDir[i] = FLY_BOTTOM | FLY_RIGHT;
	}
}


void mines_kill( )
{
	mineOnScreen = 0;
}


bool mines_collideBullet( )
{
	u8 i;
	fix16 diff;
	fixPoint *minePos;

	if (bulletPosition.y == GARAGE_Y)	return false;


	//no loop optimisation here because SDCC already does it
	for(i=0; i<4; i++)
	{
		minePos = &minesPosition[i];
		//if (minePos->y == GARAGE_Y) goto nextCol;
		
		//hint:SDCC optimizes better if you make the 2 compare y
		//then the 2 compare X (it keeps the value in memory rathen than
		// loading it everytime)

		diff = fix16Sub(minePos->y, bulletPosition.y);
		//below or garage
		if (diff < FIX16(-8))	continue;
		//behind
		if (diff > FIX16(8))	continue;
		
		diff = fix16Sub(minePos->x, bulletPosition.x);
		//right
		if (diff < FIX16(-8))	continue;
		//left
		if (diff > FIX16(8))	continue;

		//if we reach this part of code, bullet collided a mine
		
		if (--mineOnScreen == 0)
		{
			//if you shoot the last mine, it will split in 4 !
			mines_launch(minePos->x, minePos->y, 4);		
		}
		else
		{
			minePos->y = GARAGE_Y;
		}
		
		return true;
	}
	
	return false;
}

bool mines_collideShip( )
{
	u8 i;
	fixPoint *point;
	fix16 diff;

//no loop optimisation here because SDCC already does it
//possible because : 1 pointer (=>HL) and 1 value to compare (shipPosition.x=>BC)	
	for(i=0; i<4; i++)
	{	
		/**
		 * if we want to be correct, we shouldn't test a box because
		 * ship is more like
		 *  000001100000
		 *  000001100000
		 *  110011110011
		 *  111111111111
		 *  111101101111
		 *  110000000011
		 *  
		 * but it would be a rather complex "pixel perfect" collide
		 * and we don't really care ;) 
		 * 
		 **/
		point = &minesPosition[i];
		//if (point->y == GARAGE_Y) continue;
		
		//hint:SDCC optimizes better if you make the 2 compare y
		//then the 2 compare X (it keeps the value in memory rathen than
		// loading it everytime)
			 
		//below or garage_y
		if ( point->y < fix16Sub(SHIP_Y, FIX16(8))  )	continue;
		//behind
		if ( point->y > fix16Add(SHIP_Y, FIX16(8))  )	continue; 
		
		
		diff = fix16Sub(shipPosition.x, point->x);
		//ship right
		if (diff > FIX16(8))	continue;
		//ship left
		if (diff < FIX16(-32))	continue;
		//mine collided ship
		
		return true;
	}
	
	return false;
}

//1 or 4, this doesn't handle "is there a mine on garage to use ?"
//just know what you're doing !
void mines_launch(fix16 x, fix16 y, u8 count)
{
	u8 i, dir;
	fixPoint *point;
	
	//if already on screen, keep it like this
	if ( mineOnScreen >= count )	return;
	
	for(i=0; i<count; i++)
	{
		point = &minesPosition[i];
		point->x = x;
		point->y = y;

		dir = FLY_BOTTOM; //left/bottom
		if (i&1) //1 & 3
			dir |= FLY_RIGHT; //right/bottom
		if (i&2) //2 & 3
			dir &= 0x0F; //(right or left)/top
			
		minesDir[i] = dir;
	}

	mineOnScreen = count;	
}
