#include <stdio.h>
#include <arch/sms/SMSlib.h>
#include "../s8/joy.h"
#include "../s8/vdp.h"
#include "../s8/rastercolor.h"
#include "../s8/types.h"
#include "../game/game_hud.h"
#include "../game/game_setup.h"
#include "../game/game_text.h"
#include "../resource.h"
#include "screenManager.h"


/*************************
 * 
 * Draw 15 hiscore (12 on GG)
 * Auto jump to title if no input after 8sec (yes, looong)
 * or if input after at all scores drawn 
 * 
 * Cool stuff : Raster !
 * => every score use a color of the pal, using raster, we avoid 8 fonts
 * 
 * Sound : none
 * 
 * Todo : none
 * 
 *************************/



#define	FONT_TILE	0
#define TITLE_Y	3

#define DELAY	5
static int delayCounter;
static u8 scoreToDraw;

static bool done = false;

static u8 nextHiscoreValue[6];//99999 + \0


//convert a 32bits value to string tooks to much time for VBlank
//it makes the screen flicker on lineinterrupt since not finished
//and we probably draw the score while lineinterrupt so VDP garbage
//
//only answer is to compute it whenever we want 
//to draw it just after frameInterrupt
static void	computeHiscoreValue()
{
	//based on itoa (no magic here)
	u8 invertString[6]; //99999 + \0
	u16 score;
	u8 idx = 4;
	u8 i=0;
	
	if (scoreToDraw >= NB_HISCORE)	return;
	
	score = hiscores[scoreToDraw].score;
	nextHiscoreValue[4] = '0';
	nextHiscoreValue[5] = 0;
	if (score > 9999)
	{
		nextHiscoreValue[4] = '9';
		score = 9999;
	}
	
	do
	{
		nextHiscoreValue[--idx] = '0'+ (score %10);
		score /= 10;
	}while(idx >0); //value != 0);
}




static void joyPressed(unsigned char joy, unsigned int pressed, unsigned int state)
{
	if ( (scoreToDraw > 15) && (pressed & PORT_A_KEY_1) )
	{
		done = true;
		return;
	}		
}

static void jumpNext()
{
	setCurrentScreen(TITLE_SCREEN);	
}

static void drawScore()
{
	//faster/easier this way ;)

#ifdef TARGET_GG
	u8 idxTile = scoreToDraw>8?(16+1):(16+0);	
	SMS_setNextTileatXY(TILE_X(1), TILE_Y(2+scoreToDraw));
	SMS_setTile(idxTile);
	idxTile = 16 + ((scoreToDraw+1) % 10);
	SMS_setTile(idxTile);
#else
	u8 idxTile = scoreToDraw>8?(16+1)*2:(16+0)*2;	

	SMS_setNextTileatXY(1, TITLE_Y+1+1+scoreToDraw);
	SMS_setTile(idxTile);
	SMS_setTile(idxTile+1);
	
	idxTile = 32 + ((scoreToDraw+1) % 10)*2;
	SMS_setTile(idxTile);
	SMS_setTile(idxTile+1);
#endif




#ifdef TARGET_GG
	TEXT_drawTextDouble(hiscores[scoreToDraw].name, TILE_X(4), TILE_Y(2+scoreToDraw));
	TEXT_drawTextDouble(nextHiscoreValue, TILE_X(20-5-1), TILE_Y(2+scoreToDraw));
#else
	TEXT_drawTextDouble(hiscores[scoreToDraw].name, 6, TITLE_Y+1+1+scoreToDraw);
	TEXT_drawTextDouble(nextHiscoreValue, (32-1-5*2), TITLE_Y+1+1+scoreToDraw);
#endif


	//don't call it here!
	//too many Z80 Tstates needed and so few left on VBlank
	//keep it for activeDisplay (after TEXT_xxxxx)
	//computeHiscoreValue();
	
}


static void hiInit( )
{
	u8 idx;

	done = false;

	delayCounter = 0;
	scoreToDraw = 0;

	SMS_displayOff();

	TEXT_loadFontDouble(0);

	VDP_loadSpritePalette(shawks_pal_bin);

#ifndef TARGET_GG
	hud_load();
	hud_refresh(); //call it right now, it won't change on loop
#endif

	VDP_loadBGPalette(shawks_pal_bin);
#ifdef TARGET_GG
	TEXT_drawTextDouble("HIGH SCORES", TILE_X(1+(20-11)/2), TILE_Y(0));
	TEXT_drawTextDouble("Press 1", TILE_X(1+(20-7)/2), TILE_Y(18-1-1));
#else
	TEXT_drawTextDouble("HIGH   SCORES", 3, TITLE_Y);
	TEXT_drawTextDouble("Press 1", 8, 22); //TITLE_Y + 1 + 15 + 1 +1);
#endif

	JOY_init();
	JOY_setPressedCallback(&joyPressed);
	
	rastercolor_init();
	rastercolor_fill(shawks_pal_bin, 1);
	
#ifdef TARGET_GG
	for (idx = 0; idx< 9; idx++)
	{
		rastercolor_setRowColor(TILE_Y(2+idx), shawks_pal_bin, idx+1);
	}
	for (idx = 0; idx< (NB_HISCORE-9); idx++)
	{
		rastercolor_setRowColor(TILE_Y(2+9+idx), shawks_pal_bin, idx+1);
	}
#else
	for (idx = 0; idx< 9; idx++)
	{
		rastercolor_setRowColor(TITLE_Y+1+1+idx, shawks_pal_bin, idx+1);
	}
	for (idx = 0; idx< (NB_HISCORE-9); idx++)
	{
		rastercolor_setRowColor(TITLE_Y+1+1+9+idx, shawks_pal_bin , idx+1);
	}
#endif

	rastercolor_start();
	
	//compute first hiscore
	computeHiscoreValue();
		
	SMS_displayOn();
}

static void hiUpdate( )
{
	//do it first, VERY important
	rastercolor_vint();
	
	if (done)
	{
		jumpNext();
		return;
	}

	delayCounter++;
	if ( delayCounter == DELAY) 
	{
		if (scoreToDraw < NB_HISCORE)
			drawScore();
		else if (scoreToDraw == ( (8*50/DELAY) + NB_HISCORE) ) // => 8sec after last score drawn
			jumpNext();

		delayCounter = 0;
		scoreToDraw++;

		//we're sure it's done AFTER VDP access (drawscore) so no artifact on screen
		computeHiscoreValue();

	}

	JOY_update();
}

/*
 * alreay called on setCurrentScreen
void hiClose()
{
	SMS_disableLineInterrupt();
	
}
* */


gameScreen hiscoreScreen =
{
		HISCORE_SCREEN,
		&hiInit,
		&hiUpdate,
		NULL,
		&rastercolor_hint,
		NULL //&hiClose
};
