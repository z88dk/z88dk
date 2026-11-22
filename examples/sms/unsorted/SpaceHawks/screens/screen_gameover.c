#include <arch/sms/SMSlib.h>
#include "../s8/joy.h"
#include "../s8/vdp.h"
#include "../s8/types.h"
#include "../game/game_hud.h"
#include "../game/game_player.h"
#include "../game/game_setup.h"
#include "../game/game_text.h"
#include "../resource.h"
#include "screenManager.h"


/*************************
 * 
 * Loser end screen : you lost a live...but is the last one ? 
 * reload game (for you or p2) if you still got life (trick to reinit a game from start)
 * Wait input to exit (after at least 1sec)
 * Move the name screen, whatever the score is (sse screen_name)
 * 
 * Cool stuff : none
 * 
 * Sound : none
 * 
 * Todo : More GG version (to avoid this pityful 2 words on screen center)
 * 
 *************************/


#define DELAY_MIN	60 //wait at least 1 second before exiting

static int delayCounter;

static bool done = false;


static void jumpNext()
{
	//let's see if player wins the right to enter his name,even if he failed
	setCurrentScreen(NAME_SCREEN);
}

static void joyPressed(unsigned char joy, unsigned int pressed, unsigned int state)
{
	if ( pressed & (PORT_A_KEY_1|PORT_B_KEY_1) )
		done = (delayCounter >= DELAY_MIN);
}

static void gameoverInit( )
{
	SMS_displayOff();
	
	done = false;	
	delayCounter = 0;

	//gameOver or just lost a live ?
	//(yes, check was done here, it helps to reset gameScreen for next live)
	if (currentPlayer->lives != 0)
	{
#ifndef TARGET_GG
		//player only lost a live so, move to next player if it exists
		if (gameSetup.nbPlayers == 2)
		{
			if (currentPlayer->id == PLAYER_1)
			{
				if (gameSetup.player2->lives  > 0)
				{
					currentPlayer = gameSetup.player2;
				}
				//else keep current player1
			}
			else
			{
				if (gameSetup.player1->lives  > 0)
				{
					currentPlayer = gameSetup.player1;
				}
				//else keep current player2
			}
		}
		//else keep current player1
#endif
		
		setCurrentScreen(GAME_SCREEN);
		return;
	}
	//else  current player lost all his life : true gameOver
	
	VDP_loadSpritePalette(shawks_pal_bin);

#ifndef TARGET_GG
	hud_load();
	hud_refresh();	//call it right now, it won't change on loop
#endif

	VDP_loadBGPalette(shawks_pal_bin);
	VDP_setBGPaletteColor(1, shawks_pal_bin, 4); //force RED

	TEXT_loadFontDouble(0);

#ifdef TARGET_GG
	TEXT_drawTextDouble("GAME OVER", TILE_X(6), TILE_Y(8));
	TEXT_drawTextDouble("Press 1", TILE_X(1+(20-7)/2), TILE_Y(18-1-1));
#else
	TEXT_drawTextDouble("GAME OVER", 7, 10);
	TEXT_drawTextDouble("Press 1", 9, 22);
	TEXT_drawTextDouble("PLAYER", 7, 12);
	TEXT_drawNumber(currentPlayer->id, 21, 12);
#endif
	

	JOY_init();
	JOY_setPressedCallback(&joyPressed);

	SMS_displayOn();
}

static void gameoverUpdate( )
{
	if (done)
	{
		jumpNext();
		return;
	}
	
	if (delayCounter < DELAY_MIN)
		delayCounter++;

	JOY_update();
}

gameScreen gameoverScreen =
{
		GAMEOVER_SCREEN,
		&gameoverInit,
		&gameoverUpdate,
		NULL,
		NULL,
		NULL
};
