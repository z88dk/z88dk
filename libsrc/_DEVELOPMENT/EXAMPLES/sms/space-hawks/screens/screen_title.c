#include <stdbool.h> //for true/false
#include <stddef.h> //for null
#include <arch/sms/SMSlib.h>
#include "../s8/joy.h"
#include "../s8/rastercolor.h"
#include "../s8/vdp.h"
#include "../game/game_hud.h"
#include "../game/game_setup.h"
#include "../game/game_text.h"
#include "../game/game_sound.h"
#include "../resource.h"
#include "screenManager.h"


/*************************
 * 
 * Draw one of the two title screen
 * Reset setup (ready for next game)
 * Auto jump to hiscore if no input after end of SW theme (20sec)
 * 1 to 1 player mode
 * 2 to 2 players mode, on SMS
 * then move to level select screen
 * 
 * 
 * Cool stuff :
 * => some rows need another color.
 * On Genny, I would use several of the 4 available pals but here, raster is the key
 * 
 * Sound : infamous Star Wars theme ripoff !
 * 
 * Todo : More GG version title (perhaps 1 only, not 2)
 * 
 *************************/


#define DELAY	20*50 //20 seconds because of sw theme length
#define DELAY_MIN	30 //wait at least 1/2 second before exiting
static int delayCounter;

static bool done = false;

static u8 titleID = 0;

static void jumpBack()
{
	setCurrentScreen(HISCORE_SCREEN);
}

static void launchGame()
{
	//reset id
	titleID = 0;
	
	currentPlayer = gameSetup.player1;
	gameSetup.difficulty = 0;

	setCurrentScreen(SELECT_SCREEN);
}

//player1 select if 1 or 2 players mode
//2 players mode could be done with 1 or 2 pads
//in case of 2 pads, it's up to players to avoid playing at the same time
//not perfect but....
static void joyPressed(unsigned char joy, unsigned int pressed, unsigned int state)
{
	if (delayCounter < DELAY_MIN)	return;

#ifndef TARGET_GG	
	if (pressed & PORT_A_KEY_2) // PORT_B_KEY_1)
	{
		gameSetup.nbPlayers = 2;
		done = true;
		return;
	}
#endif

	if (pressed & PORT_A_KEY_1)
	{
		gameSetup.nbPlayers = 1;
		done = true;
	}
}

static void titleInit( )
{
	done = false;
	delayCounter = 0;
	
	SMS_displayOff();
	
	setup_reset();

	TEXT_loadFontDouble(0);

	VDP_loadSpritePalette(shawks_pal_bin);

#ifndef TARGET_GG
	hud_load();
	hud_refresh(); //call it right now, it won't change on loop
#endif

	VDP_loadBGPalette(shawks_pal_bin);

	rastercolor_init();
	rastercolor_fill(shawks_pal_bin, 1);

	if (titleID == 1)
	{
		//green
#ifdef TARGET_GG
		TEXT_drawTextDouble("S  P  A  C  E", TILE_X(1), TILE_Y(6));
		TEXT_drawTextDouble("H  A  W  K  S", TILE_X(5), TILE_Y(8));
		rastercolor_setRowColor(TILE_Y(6), shawks_pal_bin, 7);
		rastercolor_setRowColor(TILE_Y(8), shawks_pal_bin, 7);

		//white
		rastercolor_setRowColor(TILE_Y(18-1-1), shawks_pal_bin, 9);
#else
		TEXT_drawTextDouble("S  P  A  C  E", 1, 10);
		TEXT_drawTextDouble("H  A  W  K  S", 5, 12);
		rastercolor_setRowColor(10, shawks_pal_bin, 7);
		rastercolor_setRowColor(12, shawks_pal_bin, 7);
		//white
		rastercolor_setRowColor(22, shawks_pal_bin, 9);
#endif		
	}
	else
	{
		//yellow
	
#ifdef TARGET_GG
		TEXT_drawTextDouble("Space Hawks", TILE_X((20-11)/2), TILE_Y(4));
		TEXT_drawTextDouble("S.Francis    84", TILE_X(2), TILE_Y(10));
		TEXT_drawTextDouble("SpritesMind  16", TILE_X(2) , TILE_Y(12));
		rastercolor_setRowColor(  TILE_Y(4), shawks_pal_bin, 2);
		rastercolor_setRowColor( TILE_Y(10), shawks_pal_bin, 2);
		rastercolor_setRowColor( TILE_Y(12), shawks_pal_bin, 2);
		//red
		rastercolor_setRowColor(TILE_Y(18-1-1), shawks_pal_bin, 4);
#else
		TEXT_drawTextDouble("Space Hawks", TILE_X(5), 8);
		TEXT_drawTextDouble("S.Francis    84", TILE_X(1), 13);
		TEXT_drawTextDouble("SpritesMind  16", TILE_X(1) , 15);
		rastercolor_setRowColor( 8, shawks_pal_bin, 2);
		rastercolor_setRowColor(13, shawks_pal_bin, 2);
		rastercolor_setRowColor(15, shawks_pal_bin, 2);
		//red
		rastercolor_setRowColor(22, shawks_pal_bin, 4);
#endif

	}	
	
	//white or red
#ifdef TARGET_GG
	TEXT_drawTextDouble("Press 1", TILE_X(1+(20-7)/2), TILE_Y(18-1-1));
#else
	TEXT_drawTextDouble("Press 1 or 2",  TILE_X(4), TILE_Y(22));
#endif
	
	JOY_init();
	JOY_setPressedCallback(&joyPressed);
	
	rastercolor_start();
	
	SMS_displayOn();

	titleID++;
	titleID%=2;
	
	sound_playTheme( );
}

static void titleUpdate( )
{
	rastercolor_vint();

	if (done)
	{
		launchGame();
		return;
	}

	//nothing to draw on VBlank here
	//just update sound
	sound_update( );

	JOY_update();
		
	delayCounter++;
	if ( delayCounter == DELAY) 
	{
		jumpBack();
		delayCounter = 0;
	}
}

static void titleClose( )
{
	sound_reset();
}

gameScreen titleScreen =
{
		TITLE_SCREEN,
		&titleInit,
		&titleUpdate,
		NULL,
		&rastercolor_hint,
		&titleClose
};
