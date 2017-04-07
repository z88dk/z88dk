#include <arch/sms/SMSlib.h>
#include "../s8/types.h"
#include "../s8/vdp.h"
#include "../s8/metasprite.h"
#include "game_bullet.h"
#include "game_mines.h"
#include "game_enemies.h"
#include "game_bonus.h"
#include "game_data.h"
#include "game_setup.h"
#include "game_sound.h"
#include "../resource.h"


#define INIT_Y		FIX16(20*8 - 8) //based on player.minY
#define SPEED_Y		FIX16(2) 

fixPoint bulletPosition;

//it never change while flying
static u8 bulletX; 

void bullet_init( )
{
	SMS_loadTiles(bullet_bin, TILE_BULLET, bullet_bin_size);

	bullet_reset( );
}

void bullet_checkBombs( )
{
	if ( enemies_bombVSBullet( ) )
	{
		sound_playSFX(SOUND_SCORE);
		setup_addPoints( PTS_ENEMY );
	
		bullet_reset( );
	}
}

void bullet_checkEnemies( )
{
	if (enemies_groupVSBullet( ) )
	{
		sound_playSFX(SOUND_SCORE);

		setup_addPoints( PTS_ENEMY );
	
		bullet_reset( );
	}
}

void bullet_checkFlyingEnemies( )
{
	if ( enemies_flyingVSBullet( ) )
	{
		sound_playSFX(SOUND_SCORE);
	
		bonus_pop( &bulletPosition );
	
		setup_addPoints( PTS_FLYING );

		bullet_reset( );
	}
}

void bullet_checkMines( )
{
	if (mines_collideBullet( /*&bulletPosition*/) )
	{
		//mine dead or split is handled by mines_collideAt
		//setup_addPoints( 0 ); //no point for shooting a mine, since only dumb do this ! ;)
		bullet_reset( );
	}	
}

void bullet_update( u8 moveAllowed ) __z88dk_fastcall
{
	if ( bulletPosition.y == GARAGE_Y)	return;

	if (moveAllowed)
	{
		bulletPosition.y -= SPEED_Y;
		if (bulletPosition.y < 0)
		{
			//no longer on screen, bye!
			bullet_kill();
		}
	}
	SMS_addSprite( bulletX, fix16ToInt(bulletPosition.y), TILE_BULLET);		
}


/*
void bullet_updateV( )
{
	if ( bulletPosition.y == GARAGE_Y)	return;
//	nothing
}
*/

void bullet_reset( )
{
	bulletPosition.y = GARAGE_Y;
}


void bullet_kill( )
{
	bullet_reset( );
}


void bullet_fire(fix16 x) __z88dk_fastcall
{
	// already fired
	if (bulletPosition.y != GARAGE_Y)	return;
	
	//add it to the center of the ship (4 is center of bullet)
	bulletPosition.x = fix16Add(x, FIX16( ((32/2) - 4) ) );	
	bulletPosition.y = INIT_Y;
	
	bulletX = fix16ToInt(bulletPosition.x);

	sound_playSFX( SOUND_FIRE );
}
