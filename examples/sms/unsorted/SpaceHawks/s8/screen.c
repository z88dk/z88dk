#include <arch/sms/SMSlib.h>
#include "screen.h"

static gameScreen *currentScreen;

void SCREEN_setCurrent( gameScreen *screen )
{
	//this way we wait for hint/eint/vint to finish
	SMS_waitForVBlank();
	

	if (currentScreen && (currentScreen->close))
		currentScreen->close();

	currentScreen = screen;

	if (currentScreen && (currentScreen->init))
		currentScreen->init();
	
}


bool SCREEN_isSCurrent( unsigned char id  ) __z88dk_fastcall
{
	if (currentScreen && (currentScreen->uid == id))
		return true;
	else
		return false;

}


/**
 * Update game logic
 */
void SCREEN_update( )
{
	if (currentScreen && (currentScreen->update))
		currentScreen->update();
}

/**
 * 
 */
void SCREEN_updateVBlank(  )
{
	if (currentScreen && (currentScreen->updateVBlank))
		currentScreen->updateVBlank();
}

/**
 * Line update
 **/
void SCREEN_updateHBlank(  )
{
	if (currentScreen && (currentScreen->updateHBlank))
		currentScreen->updateHBlank();
}

