#include <arch/sms/SMSlib.h>
#include "../s8/joy.h"
#include "../s8/types.h"
#include "../s8/vdp.h"
#include "../game/game_setup.h"
#include "../resource.h"
#include "screenManager.h"

/*************************
 * 
 * Draw SpritesMind logo
 * Init setup (mainly hiscores)
 * Auto jump to HiScore if no input
 * or if input after at least 0.5s (Saw my logo, newcomer!)
 * 
 * GG optimized
 * 
 * Cool stuff : none
 * 
 * Sound : none
 * 
 * Todo : n/a
 * 
 *************************/

#define DELAY	200 //50*4 => so about 4 seconds
#define DELAY_MIN	30 //wait at least 1/2 second before exiting
static int delayCounter;

static bool done = false;

void VDP_drawTileMapArea(unsigned char x, unsigned char y, unsigned char width, unsigned char height, unsigned int tile)
{
	unsigned char idxH, idxW;
	unsigned int currentTile =tile;
	
	for(idxH =0; idxH < height; idxH++)
	{
		SMS_setNextTileatXY(x,y+idxH);
		for(idxW =0; idxW < width; idxW++)
		{
			SMS_setTile(currentTile++);
		}
	}
	
}


static void joyPressed(unsigned char joy, unsigned int pressed, unsigned int state)
{
	//any input does it
	done = ((delayCounter > DELAY_MIN) && (pressed & PORT_A_KEY_1));
}

static void spritesmindInit( )
{
	done = false;
	delayCounter = 0;
	
	SMS_displayOff();
	
	setup_init();
	
	SMS_loadPSGaidencompressedTiles(logo_sm_psgcompr, 1);
	
	VDP_loadBGPalette(spritesmind_pal_bin);
#ifdef TARGET_GG
	VDP_drawTileMapArea(TILE_X((160-120)/16), TILE_Y((144-40)/16), 120/8, 40/8, 1);
#else
	VDP_drawTileMapArea(TILE_X(4), TILE_Y(8), 192/8, 64/8, 1);
#endif
	
	JOY_init();
	JOY_setPressedCallback(&joyPressed);

	SMS_displayOn();
}

static void spritesmindUpdate( )
{
	if (done)
	{
		setCurrentScreen(HISCORE_SCREEN);
		return;
	}

	JOY_update();
	
	delayCounter++;
	//..or auto pass after give delay
	if ( delayCounter == DELAY)
	{
		//fade palette  25 frames ?
	}
	else if ( delayCounter == (DELAY+25) )
	{
		done = true;
		return;
	}
}


gameScreen spritesmindScreen =
{
		SPRITESMIND_SCREEN,
		&spritesmindInit,
		&spritesmindUpdate,
		NULL,
		NULL,
		NULL
};
