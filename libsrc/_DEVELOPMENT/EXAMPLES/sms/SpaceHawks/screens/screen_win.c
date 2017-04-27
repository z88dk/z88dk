#include <stdbool.h> //for true/false
#include <stddef.h> //for null
#include <arch/sms/SMSlib.h>
#include "../s8/joy.h"
#include "../s8/vdp.h"
#include "../game/game_hud.h"
#include "../game/game_player.h"
#include "../game/game_setup.h"
#include "../game/game_text.h"
#include "../resource.h"
#include "screenManager.h"



/*************************
 * 
 * Winning end screen : you killed all the aliens from all the levels
 * Wait input to exit (after at least 1sec)
 * Move the name screen, whatever the score is (sse screen_name)
 * 
 * Cool stuff : none
 * 
 * Sound : none
 * 
 * Todo : More GG version screen than just text
 * 
 *************************/


#define DELAY_MIN	60 //wait at least 1 second before exiting

static int delayCounter;
static bool done = false;


static void jumpNext()
{
	//let's see if player wins the right to enter his name
	setCurrentScreen(NAME_SCREEN);
}

static void joyPressed(unsigned char joy, unsigned int pressed, unsigned int state)
{
	if ( pressed & (PORT_A_KEY_1|PORT_B_KEY_1) )
		done = (delayCounter >= DELAY_MIN);
}



static void winInit( )
{
	// NO MORE ENEMIES !!!!!
	// congrats ;)
	
	done = false;
	delayCounter = 0;

	SMS_displayOff();
	
	TEXT_loadFontDouble(0);
	
	VDP_loadSpritePalette(shawks_pal_bin);

#ifndef TARGET_GG
	hud_load();
	hud_refresh();//call it right now, it won't change on loop
#endif
	
	//not really needed since xx_setBGPaletteColor follow 
	//VDP_loadBGPalette(shawks_pal_bin);
	VDP_setBGPaletteColor(1, shawks_pal_bin, 4); //force RED
	
#ifdef TARGET_GG
	TEXT_drawTextDouble("Congratulations", TILE_X(3), TILE_Y(3));
	TEXT_drawTextDouble("YOU DESTROYED", TILE_X(4), TILE_Y(8));
	TEXT_drawTextDouble("THE SWARMING HAWKS", TILE_X(1), TILE_Y(10));
	TEXT_drawTextDouble("Press 1", TILE_X(1+(20-7)/2), TILE_Y(18-1-1));
#else
	TEXT_drawTextDouble("Congratulations", 1, 5);
	TEXT_drawTextDouble("YOU DESTROYED", 3, 10);
	TEXT_drawTextDouble("THE SWARMING", 4, 12);
	TEXT_drawTextDouble("HAWKS", 11, 15);
	TEXT_drawTextDouble("Press 1", 9, 22);
#endif

	JOY_init();
	JOY_setPressedCallback(&joyPressed);

	SMS_displayOn();
}

static void winUpdate( )
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


gameScreen winScreen =
{
		WIN_SCREEN,
		&winInit,
		&winUpdate,
		NULL,
		NULL,
		NULL
};
