#include <arch/sms/SMSlib.h>
#include "../s8/types.h"
#include "../s8/joy.h"
#include "../s8/vdp.h"
#include "../s8/metasprite.h"
#include "game_player.h"
#include "game_bullet.h"
#include "game_mines.h"
#include "game_enemies.h"
#include "game_setup.h"
#include "game_sound.h"
#include "game_data.h"
#include "../resource.h"


/***
 * 
 * SMS size : 32*16
 * GG size : 24*12
 * 
 ***/


#define STEP_INIT 1
#define STEP_PLAY 2
#define STEP_DYING 3

#define ANIM_PLAY		0
#define ANIM_ENTRY		(ANIM_PLAY+1)
#define ANIM_DEFEATED	(ANIM_ENTRY+1)

#ifdef TARGET_GG
#define MIN_X	FIX16(SPRITE_X(0))
#define MAX_X	FIX16(SPRITE_X(20*8 - 24)) //right - ship.width
#define MAX_Y	FIX16(SPRITE_Y(18*8))
#else
#define MIN_X	FIX16(0)
#define MAX_X	FIX16(32*8 - 32) //right - ship.width
#define MAX_Y	FIX16(200) //30*8)
#endif


#define PLAYER_SPEED_X	FIX16(2)
#define	PLAYER_SPEED_Y	FIX16(-0.4)


fixPoint shipPosition;
static fixPoint shipVelocity;


player player1;
player player2;

#ifdef TARGET_GG
static subSprite	subShip[3*2];
#else
static subSprite	subShip[4*2];
#endif

static metaSprite 	shipSprite;

static u8 currentStep;
static u8 dyingCounter;

//5 frames
#define	frame_size	(ship_bin_size/5)
#define loadFrame(frame) 	SMS_loadTiles(ship_bin + ((frame)*frame_size), TILE_SHIP, frame_size)


void player_init( )
{
	u8 idx = 0;
	
	loadFrame(0);

	subShip[idx].xOffset = 0;
	subShip[idx].yOffset = 0;
	subShip[idx].tileOffset = idx;

	idx++;
	subShip[idx].xOffset = 8;
	subShip[idx].yOffset = 0;
	subShip[idx].tileOffset = idx;
	
	idx++;
	subShip[idx].xOffset = 16;
	subShip[idx].yOffset = 0;
	subShip[idx].tileOffset = idx;

#ifndef TARGET_GG
	idx++;
	subShip[idx].xOffset = 24;
	subShip[idx].yOffset = 0;
	subShip[idx].tileOffset = idx;
#endif

	idx++;
	subShip[idx].xOffset = 0;
	subShip[idx].yOffset = 8;
	subShip[idx].tileOffset = idx;

	idx++;
	subShip[idx].xOffset = 8;
	subShip[idx].yOffset = 8;
	subShip[idx].tileOffset = idx;

	idx++;
	subShip[idx].xOffset = 16;
	subShip[idx].yOffset = 8;
	subShip[idx].tileOffset = idx;

#ifndef TARGET_GG
	idx++;
	subShip[idx].xOffset = 24;
	subShip[idx].yOffset = 8;
	subShip[idx].tileOffset = idx;
#endif
	
	idx++;
	shipSprite.tile = TILE_SHIP;
	shipSprite.nbSprites = idx;
	shipSprite.sprites =&subShip;
	
	//done in state_title, since player_init is called at each new level
	//player->score = 0;
	//player->lives = gameSetup.nbLives;

	player_reset( );
}

bool player_isReady()
{
	return (currentStep == STEP_PLAY);
}

void player_checkFlyingEnemies( )
{
	if (currentStep != STEP_PLAY)	return;

	if ( enemies_flyingVSShip( /*&shipPosition*/ ) == true )
		player_hit();
}

void player_checkBombs( )
{
	if (currentStep != STEP_PLAY)	return;

	if ( enemies_bombVSShip( /*&shipPosition*/ ) == true )
		player_hit();
}

void player_checkMines( )
{
	if (currentStep != STEP_PLAY)	return;
	 
	if ( mines_collideShip( /*&shipPosition */) == true ) 
		player_hit();
}


// return isDead 
bool player_update( )
{
	if (currentStep == STEP_INIT)
	{
		//auto move ship up
		shipPosition.y += shipVelocity.y;
		shipSprite.y = fix16ToRoundedInt(shipPosition.y);
		if (shipPosition.y <= SHIP_Y)
		{
			shipVelocity.y = 0;
			shipPosition.y = SHIP_Y;
			shipSprite.y = fix16ToRoundedInt(shipPosition.y);
			currentStep = STEP_PLAY;
		}
	}
	else if (currentStep == STEP_PLAY) 
	{
		//handle X
		shipPosition.x += shipVelocity.x;
		if (shipPosition.x < MIN_X)
		{
			shipPosition.x = MIN_X;
			shipVelocity.x = 0;
		}
		else if (shipPosition.x > MAX_X)
		{
			shipPosition.x = MAX_X;
			shipVelocity.x = 0;
		}
		shipSprite.x = fix16ToInt(shipPosition.x); //fix16ToRoundedInt(shipPosition.x);
		
		
	}
	else if (currentStep == STEP_DYING)
	{ 
		dyingCounter++;
		
		//load it on vblank
		////a loop is 4 frames at 2 framerate
		//loadFrame(1+(dyingCounter/2)%4);
		
		//dying sound is 70 frames
		if (dyingCounter >= 70)
		{
			setup_loseLife( );
			return true;
		}
	}

	addMetaSprite(&shipSprite);

	return false;
}


void player_updateV( )
{
	if (currentStep == STEP_DYING)
		loadFrame( 1+((dyingCounter/2)%4 ) );
}

void player_reset( )
{
	currentStep = STEP_INIT;

#ifdef	TARGET_GG
	shipPosition.x = FIX16( SPRITE_X(8*((20-3)/2)) ); //middle
#else
	shipPosition.x = FIX16( 8*((32-4)/2) ); //middle
#endif

	shipPosition.y = MAX_Y; //below down screen

	shipVelocity.x = 0;
	shipVelocity.y = PLAYER_SPEED_Y;

	shipSprite.x = fix16ToRoundedInt(shipPosition.x);
	shipSprite.y = fix16ToRoundedInt(shipPosition.y);

}

void player_hit()
{
	shipVelocity.y = 0;
	shipVelocity.x = 0;
	dyingCounter = 0;
	currentStep = STEP_DYING;
	sound_playSFX( SOUND_DYING );
}

static void adjustVelocity( u16 state ) __z88dk_fastcall
{
	shipVelocity.x = 0;
	if (state & (PORT_A_KEY_LEFT|PORT_B_KEY_LEFT) ) //RIGHT released, LEFT kept pressed
	{
		if (shipPosition.x > MIN_X)
			shipVelocity.x = -PLAYER_SPEED_X;
	}
	else if (state & (PORT_A_KEY_RIGHT|PORT_B_KEY_RIGHT) ) //LEFT released, RIGHT kept pressed
	{
		if (shipPosition.x < MAX_X)
			shipVelocity.x = PLAYER_SPEED_X;
	}
}


void player_inputPressed(u16 pressed, u16 state)
{
	//no move while dying or launching
	if (currentStep != STEP_PLAY)	return;

	if (pressed & (PORT_A_KEY_1|PORT_B_KEY_1) )
	{
		bullet_fire( shipPosition.x );
	}
	
	adjustVelocity(state);
}

void player_inputReleased(u16 released, u16 state)
{
	//no move while dying or launching
	if (currentStep != STEP_PLAY)	return;

	//if (released & (PORT_A_KEY_LEFT|PORT_B_KEY_LEFT|PORT_A_KEY_RIGHT|PORT_B_KEY_RIGHT) )
	//{
		adjustVelocity(state);
	//}
}