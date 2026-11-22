#include <arch/sms/SMSlib.h>
#include "../s8/joy.h"
#include "../s8/metasprite.h"
#include "../s8/types.h"
#include "../s8/vdp.h"
#include "../game/game_hud.h"
#include "../game/game_player.h"
#include "../game/game_setup.h"
#include "../game/game_text.h"
#include "../resource.h"
#include "screenManager.h"



/*************************
 * 
 * Select the difficulty level (impact mines and enemies speed)
 * then launch game
 * 
 * 
 * Cool stuff :
 * => no raster effect needed here, just define color on the run
 * => use metasprite for selector (even if 2 SMS_addSprite call would be enough and cost less RAM/cpu clock )
 * 
 * Sound : none
 * 
 * Todo : 
 * 	GG check selector tile : 1 pixel missing ?
 * 
 *************************/

#ifdef TARGET_GG
#define SELECTOR_X			SPRITE_X(2*8 - 1)  //TODO it's strange we need this -1 
#define SELECTOR_Y			SPRITE_Y(12*8 + 4)
#else
#define SELECTOR_X			SPRITE_X(1*8)
#define SELECTOR_Y			SPRITE_Y(15*8 + 4)
#endif

static u8 currentIdx;
static u8 blinkCounter;

static subSprite	subSelector[2];
static metaSprite 	selector;

static bool done = false;

//player 1 select level (sorry player 2)
static void joyPressed(unsigned char joy, unsigned int pressed, unsigned int state)
{
	if (pressed & PORT_A_KEY_1)
	{
		done = true;
		return;		
	}		
	
	if (pressed & PORT_A_KEY_RIGHT)
	{
		currentIdx++;
		if (currentIdx == 8)	currentIdx--;
	}
	else if (pressed & PORT_A_KEY_LEFT)
	{
		if (currentIdx)	currentIdx--;
	}
	
#ifdef TARGET_GG
	selector.x = SELECTOR_X + currentIdx*(8+8); //8+8 because each letter is 1 tile width + space
#else
	selector.x = SELECTOR_X + currentIdx*(16+16); //16+16 because each letter is 2 tiles width + space
#endif

}


static void launchGame()
{
	gameSetup.difficulty = currentIdx;
	currentPlayer = gameSetup.player1;
	setCurrentScreen(GAME_SCREEN);
}


static void selectInit( )
{
	SMS_displayOff();
	
	done = false;
	
	currentIdx = 0;
	blinkCounter = 11;

	
	TEXT_loadFontDouble(0);

	VDP_loadSpritePalette(shawks_pal_bin);
	
	//I used index 3 since index 1 (blue) is used by hud
	VDP_setSpritePaletteColor(3, shawks_pal_bin,2); //yellow

	SMS_loadTiles(selector_bin, FIRST_SPRITE_TILE, selector_bin_size);

#ifndef TARGET_GG	
	hud_load();
	hud_refresh(); //call it right now, it won't change on loop
#endif

	VDP_loadBGPalette(shawks_pal_bin);
	VDP_setBGPaletteColor(1, shawks_pal_bin,7); //GREEN

#ifdef TARGET_GG
	TEXT_drawTextDouble("WHICH LEVEL", TILE_X((20-11)/2), TILE_Y(6));
	TEXT_drawTextDouble("DARE YOU TRY ?", TILE_X((20-14)/2), TILE_Y(8));
	TEXT_drawTextDouble("0 1 2 3 4 5 6 7", TILE_X(2), TILE_Y(12));
#else
	TEXT_drawTextDouble("WHICH LEVEL", TILE_X(5), TILE_Y(8));
	TEXT_drawTextDouble("DARE YOU TRY ?", TILE_X(2), TILE_Y(10));
	TEXT_drawTextDouble("0 1 2 3 4 5 6 7", TILE_X(1), TILE_Y(15));
#endif
	
		
	subSelector[0].xOffset = 0;
	subSelector[0].yOffset = 0;
	subSelector[0].tileOffset = 0;
#ifndef TARGET_GG	
	subSelector[1].xOffset = 8;
	subSelector[1].yOffset = 0;
	subSelector[1].tileOffset = 1; 	
#endif
	
	selector.x = SELECTOR_X;
	selector.y = SELECTOR_Y;
	selector.tile = FIRST_SPRITE_TILE;
#ifdef TARGET_GG	
	selector.nbSprites = 1;
#else
	selector.nbSprites = 2;
#endif
	selector.sprites =&subSelector;


	JOY_init();
	JOY_setPressedCallback(&joyPressed);

	SMS_displayOn();
}

static void selectUpdate( )
{
	if (done)
	{
		launchGame();
		return;
	}
	
	//update palette while we're still on vblank, to avoid VDP corruption
	blinkCounter--;
	if (blinkCounter == 10)
	{
		VDP_setSpritePaletteColor(3, shawks_pal_bin, 2); //yellow
	}
	else if (blinkCounter == 0)
	{
		blinkCounter = 30;
		
		VDP_setSpritePaletteColor(3, shawks_pal_bin, 8); //green light
	}

	SMS_initSprites();
	addMetaSprite(&selector);
	SMS_finalizeSprites();
	SMS_copySpritestoSAT( );
	
	JOY_update();
}


gameScreen selectScreen =
{
		SELECT_SCREEN,
		&selectInit,
		&selectUpdate,
		NULL,
		NULL,
		NULL
};
