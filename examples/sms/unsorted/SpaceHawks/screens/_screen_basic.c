#include <stdbool.h> //for true/false
#include <stddef.h> //for null
#include <arch/sms/SMSlib.h>
#include "../s8/joy.h"
#include "../s8/vdp.h"
#include "../resource.h"
#include "screenManager.h"

#define	FONT_TILE	0

static bool paused = false;
static bool done = false;

static void joyPressed(unsigned char joy, unsigned int pressed, unsigned int state)
{
	if (state == (PORT_A_KEY_UP|PORT_A_KEY_1))
	{
		done = true;
		return;
	}		

}

static void joyReleased(unsigned char joy, unsigned int released, unsigned int state)
{

}



static void spritesInit( )
{
	SMS_displayOff();
	
	paused = false;
	done = false;
	
	SMS_loadTiles(font_lib_bin, FONT_TILE, font_lib_bin_size);

	SMS_loadBGPalette(shawks_pal_bin);
	SMS_loadSpritePalette(shawks_pal_bin);

	JOY_init();
	JOY_setPressedCallback(&joyPressed);
	JOY_setReleasedCallback(&joyReleased);

	SMS_displayOn();
}

static void spritesUpdate( )
{
	if (done)
	{
		setCurrentScreen(TITLE_SCREEN);
		return;
	}
	
	if (SMS_queryPauseRequested()) {
		paused = !paused;
		SMS_resetPauseRequest();
	}

	if (!paused)
	{
		JOY_update();
		//sprite update
	}
	
	
	SMS_initSprites();
	//addMetaSprite(&hawk);
	SMS_finalizeSprites();
	SMS_copySpritestoSAT( );

}


gameScreen spritesScreen =
{
//		SPRITES_SCREEN,
		SPRITESMIND_SCREEN,
		&spritesInit,
		&spritesUpdate,
		NULL,
		NULL,
		NULL
};
