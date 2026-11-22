#include <arch/sms/SMSlib.h>
#include "../s8/joy.h"
#include "../s8/vdp.h"
#include "../s8/types.h"
#include "../s8/metasprite.h"
#include "../game/game_hud.h"
#include "../game/game_sound.h"
#include "../game/game_player.h"
#include "../game/game_bullet.h"
#include "../game/game_bonus.h"
#include "../game/game_mines.h"
#include "../game/game_setup.h"
#include "../game/game_text.h"
#include "../resource.h"
#include "screenManager.h"


//return true if update should end
typedef u8 _updateCallback();

static _voidCallback *subVBlank;
static _updateCallback *subUpdate;


static u16 scorePool;

static u8 stateInitialized = false;

static void levelInit();
static void levelCompleted();

static u8 collideStep;
static void resetHandlers()
{
	subUpdate = NULL;
	subVBlank = NULL;
}

/// STEP 3 :  score update
static u8 scoreUpdate()
{
	setup_addPoints( 2 );
	sound_playSFX(SOUND_SCORE);

	scorePool -= 2;
	
	//to not call, so they don't move
	//bullet_update( );
	//mines_update( );
	//every thing is dead (shoot, enemy, bombs)
	//the only thing in place is MINES 
	mines_update( false );


	if (scorePool == 0)
	{
		//step end, select next one : game end or reset level
		stateInitialized = false;
		resetHandlers();

		//original game works this way (complete 9 levels of selected difficulty)
		//another way would to difficulty++
		//but the 99999 score limit won't be enough
		//and I can't write more than 5 digits per score due to doubleWidth font
		if (currentPlayer->level == 8)
		{
			setCurrentScreen(WIN_SCREEN);
			return true;
		}
		else
			levelInit( );
	}

	return false;
}

/*
static void scoreUpdateV()
{
	//since we won, bullet shot disappears with last enemy killed
	//	bullet_updateV( );
	mines_updateV( );
}
*/

/// STEP 2 : game
static void joyPressed(unsigned char joy, unsigned int pressed, unsigned int state)
{
	//if ( (joy == JOY_2) && ( currentPlayer->id == PLAYER_1))	return;
	//if ( (joy == JOY_1) && ( currentPlayer->id == PLAYER_2))	return;
	
	player_inputPressed(pressed, state);
}

static void joyReleased(unsigned char joy, unsigned int released, unsigned int state)
{
	//if ( (joy == JOY_2) && ( currentPlayer->id == PLAYER_1))	return;
	//if ( (joy == JOY_1) && ( currentPlayer->id == PLAYER_2))	return;

	player_inputReleased(released, state);
}

static u8 playUpdate()
{
	u8 allowMove = player_isReady(); 

	bullet_update( allowMove );
	mines_update( allowMove );
	enemies_update( allowMove );
	bonus_update( allowMove );

	if ( allowMove )
	{
		// BULLET vs MINE(S)
		//bullet move 2pixels/frame
		//mine 1pixel/frame 
		//both are 8x8
		//we have 4 frame to detect collide
		//BUT since mine move h&v, we could miss it easily :(
		//==> every 2 frames
		
		// BULLET vs BOMB(S)
		//bomb move 1.7pixel frame
		//bullet move 2pixels/frame
		//both are 8x8
		//we have 4 frame to detect collide
		//==> every 4 frames

		// BULLET vs GROUP
		//enemy group move vertical 1px every 2 frame
		//enemy is 8x24
		//bullet move 2pixels/frame
		//we have 4 frames to detect collide
		//==> every 4 frames

		// BULLET vs FLYING
		//flying enemy vertical 0.7pixel/frame but 1.5pixel/frame horizontal
		//since enemy are 8x24
		//bullet move 2pixels/frame
		//we have 3 frames to detect collide
		//==> every 4 frames

		// PLAYER vs MINE(s)
		//mine 1pixel/frame h&v
		//8x8 
		//player is 2px/frame
		//32x16
		//the available frames to detect collide are defined by much factor
		// - player moving ?
		// - in which direction ?
		// - mine direction ?
		// - invert of player ?
		// high number (8) makes player a way to escape mine
		// low number (1) makes collide on topleft or topright seems wrong
		// plus collide is heavy
		// so make it easier...every 3 frames does it 
		//==> every 3 frames

	
		// PLAYER vs FLYING
		//flying enemy vertical 0.7pixel/frame but 1.5pixel/frame horizontal
		//8x24
		//player is 2px/frame
		//32x16

		//  PLAYER vs BOMB
		//bomb move 1.7pixel frame v  / 0 frame H
		//8x8 
		//player is 2px/frame H  / 0 frame V
		//32x16
		//==> 8 frames
/*
				bullet_checkMines( );
				bullet_checkBombs();
				bullet_checkEnemies();		
				bullet_checkFlyingEnemies();		

				player_checkMines( );
				player_checkFlyingEnemies( );
				player_checkBombs( );
*/
		switch(collideStep & 0x7)
		{
			case 0:
				bullet_checkMines( );
				player_checkFlyingEnemies( );
				break;
			case 1:
				bullet_checkBombs();
				bullet_checkFlyingEnemies();		
				break;
			case 2:
				bullet_checkMines( );
				player_checkBombs( );
				break;
			case 3:
				bullet_checkEnemies();		
				player_checkMines( );
				break;
			case 4:
				bullet_checkMines( );
				player_checkFlyingEnemies( );
				break;
			case 5:
				bullet_checkBombs();
				bullet_checkFlyingEnemies();		
				break;
			case 6:
				bullet_checkMines( );
				player_checkBombs( );
				break;
			case 7:
				bullet_checkEnemies();		
				player_checkMines( );
				break;
		}

		collideStep++;
	}

	if (enemies_areDead() == true)
	{
		levelCompleted( );
		return true;
	}

	return false;
}

/*
static void playUpdateV()
{
	//bullet_updateV( );
	//mines_updateV( );
	enemies_updateV( );
	//bonus_updateV( );
}
*/


static void levelCompleted()
{
	stateInitialized = false;

	resetHandlers();
	subUpdate = &scoreUpdate;
	//subVBlank = &scoreUpdateV;
	
	//reset joy handler : you can't move while scoring
	JOY_init();

	//reset player move
	player_inputReleased(0xFFFF, 0);

	scorePool = PTS_END;

	bullet_kill();
	enemies_kill();
	bonus_kill();
	
	//reset slots for next level
	setup_resetSlots();

	currentPlayer->level++;

	stateInitialized = true;
}

static void levelInit( )
{
	stateInitialized = false;


	collideStep = 0;
	//redraw hud, cleared few ticks before ;)
	hud_load();

	sound_reset();

	enemies_reset();

	// mine on level 2+ or if difficulty 2+
	if ( (currentPlayer->level > 2) || (gameSetup.difficulty > 1))
		mines_launch( FIX16( (8*32/2) ), FIX16( (8*24/2) ), 1); //middle screen


	subUpdate = &playUpdate;
	subVBlank = &enemies_updateV; //&playUpdateV;

	JOY_init();
	JOY_setPressedCallback(&joyPressed);
	JOY_setReleasedCallback(&joyReleased);

	stateInitialized = true;
}

/// STEP 1 : ship come from bottom
static u8 shipEntry()
{
	if ( player_isReady() == false )	return false;
	
	//remove texts
	VDP_clearBG( );

	levelInit( );

	return false;
}



/// all steps
static void gameOver( )
{
	stateInitialized = false;

	resetHandlers();

	//reset player move
	player_inputReleased(0xFFFF, 0);

	mines_kill();
	enemies_kill();
	
	//handle multi player, life left, ....
	setCurrentScreen(GAMEOVER_SCREEN);
}

static void gameInit( )
{
	stateInitialized = false;

	SMS_displayOff();

	scorePool = 0;	
	
	TEXT_loadFontDouble(0);
	VDP_loadSpritePalette(shawks_pal_bin);

	hud_load();
	hud_refresh();	//call it right now, it won't change on loop

	player_init(); //ready to launch
	bullet_init();	
	mines_init();	
	bonus_init();
	enemies_init();	

#ifdef TARGET_GG
	GG_setBGPaletteColor(1, ((u16 *) shawks_pal_bin)[4]); //force RED

	TEXT_drawTextDouble("PLAYER", TILE_X(6), TILE_Y(7));
	TEXT_drawTextDouble("1", TILE_X(20-6-1), TILE_Y(7));
	TEXT_drawTextDouble("LIVES", TILE_X(6), TILE_Y(8));
	TEXT_drawNumber((currentPlayer->lives > 9)?9:currentPlayer->lives, TILE_X(20-6-1), TILE_Y(8));
#else
	SMS_setBGPaletteColor(1, shawks_pal_bin[4]); //force RED

	TEXT_drawTextDouble("PLAYER", 8, 9);
	TEXT_drawNumber(currentPlayer->id, 22, 9);
	TEXT_drawTextDouble("LIVES", 8, 11);
	TEXT_drawNumber((currentPlayer->lives > 9)?9:currentPlayer->lives, 22, 11);
#endif

	
	sound_playSFX(SOUND_LAUNCH);
	
	resetHandlers();
	subUpdate = &shipEntry;
	
	//no joy handler....yet

	SMS_initSprites();

	SMS_displayOn();

	stateInitialized = true;	
}

static void gameUpdate( )
{
	if (!stateInitialized) return;

	//first, anything which write to VDP, to avoid artifacts...
	SMS_finalizeSprites();
	SMS_copySpritestoSAT( );	

	//according step
	if (subVBlank != NULL)	subVBlank();

	//each step
	player_updateV( );
	
	//write score
	hud_refresh();

	
	//...then anything not VDP related
	SMS_initSprites();
	sound_update( );
		
	if (subUpdate != NULL)
	{
		if ( subUpdate() ) return;
	}
	
	//move it ...so yes, move come AFTER draw for performance reasons
	JOY_update();
	if( player_update( ) )
	{
		gameOver();
		return;
	}
}
static void gameClose( )
{
	sound_reset();
}


gameScreen gameplayScreen =
{
		GAME_SCREEN,
		&gameInit,
		&gameUpdate,
		NULL,
		NULL,
		&gameClose
};
