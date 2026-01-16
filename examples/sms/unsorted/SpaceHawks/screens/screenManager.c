#include <arch/sms/SMSlib.h>
#include <intrinsic.h>
#include "../s8/types.h"
#include "../s8/vdp.h"
#include "screenManager.h"

#define DISABLE_INTERRUPTS    intrinsic_di()
#define ENABLE_INTERRUPTS     intrinsic_ei()


void setCurrentScreen(int screenID) 
{
	//first thing to do because it breaks everything!
	SMS_disableLineInterrupt();
	
	SMS_displayOff();
	
	DISABLE_INTERRUPTS;
	//TODO better call ?
	//SMS_init(); 

	SMS_setBGScrollX (0);
	SMS_setBGScrollY (0);
	SMS_setBackdropColor(0);
	SMS_useFirstHalfTilesforSprites(false);
	SMS_setSpriteMode (SPRITEMODE_NORMAL);
	
	//TODO
	//clear VRAM ?
	VDP_clearBG();
	
	SMS_mapROMBank(2);
	
	SMS_initSprites();
	SMS_finalizeSprites();
	SMS_copySpritestoSAT();
	
#ifndef TARGET_GG
	//? needed ?
	SMS_resetPauseRequest();
#endif

	SMS_setLineInterruptHandler(&SCREEN_updateHBlank);

	ENABLE_INTERRUPTS;

	SMS_displayOn();
	
	switch(screenID)
	{
		case SPRITESMIND_SCREEN:
			SCREEN_setCurrent( &spritesmindScreen );
			break;
		case HISCORE_SCREEN:
			SCREEN_setCurrent( &hiscoreScreen );
			break;
		case TITLE_SCREEN:
			SCREEN_setCurrent( &titleScreen );
			break;
		case SELECT_SCREEN:
			SCREEN_setCurrent( &selectScreen );
			break;
		case GAME_SCREEN:
			SCREEN_setCurrent( &gameplayScreen );
			break;
		case WIN_SCREEN:
			SCREEN_setCurrent( &winScreen );
			break;
		case NAME_SCREEN:
			SCREEN_setCurrent( &nameScreen );
			break;
		case GAMEOVER_SCREEN:
			SCREEN_setCurrent( &gameoverScreen );
			break;
	}
}
