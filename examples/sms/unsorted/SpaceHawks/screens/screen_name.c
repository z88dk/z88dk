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
 * Enter your name...if you're on hiscore table !
 * If not, or after name input, move to hiscore OR launch other player game  
 * 
 * Cool stuff :
 * ==> save as screen_selector, metasprite
 * ==> letter selector, which ask to handle press and release event
 * 
 * Sound : none
 * 
 * Todo : GG version
 * 
 *************************/



#define LETTER_RATE	5

#ifdef TARGET_GG
#define SELECTOR_X			SPRITE_X(3*8)
#define SELECTOR_Y			SPRITE_Y(10*8 + 4)
#else
#define SELECTOR_X			SPRITE_X(9*8)
#define SELECTOR_Y			SPRITE_Y(16*8 + 4)
#endif

static bool done;
static u8 currentIdx;
static u8 currentLetter, letterRate;
static u8 blinkCounter;
static s8 letterSpeed;

static subSprite	subSelector[2];
static metaSprite 	selector;

static hiscore_t *playerHiScore;

static void decLetter()
{
	if (currentLetter > 0)
	{
		currentLetter--;
		playerHiScore->name[currentIdx] = currentLetter+0x20;
	}		
}

static void incLetter()
{
	if (currentLetter < 95 )
	{
		currentLetter++;
		playerHiScore->name[currentIdx] = currentLetter+0x20;
	}
}


static void joyPressed(unsigned char joy, unsigned int pressed, unsigned int state)
{
	// it was my first idea but it means you can't play 2P with 1 pad :(
	////only current player is allowed to enter his name
	//if ( (joy == JOY_2) && ( currentPlayer->id == PLAYER_1))	return;
	//if ( (joy == JOY_1) && ( currentPlayer->id == PLAYER_2))	return;
	
	if ( pressed & (PORT_A_KEY_1|PORT_B_KEY_1) )
	{
		done = true;
		return;
	}
	
	if (pressed & (PORT_A_KEY_RIGHT|PORT_B_KEY_RIGHT))
	{
		if (currentIdx < 6)
		{
			currentIdx++;
			currentLetter = playerHiScore->name[currentIdx]-0x20;
			if (currentLetter == ('.'-0x20))
			{
				playerHiScore->name[currentIdx] = 'A';
				currentLetter = 'A'-0x20;
			}
		}
	}
	else if ( pressed & (PORT_A_KEY_LEFT|PORT_B_KEY_LEFT) )
	{
		if (currentIdx > 0)
		{
			currentIdx--;
			currentLetter = playerHiScore->name[currentIdx]-0x20;
		}
	}
	else if ( pressed & (PORT_A_KEY_2|PORT_B_KEY_2) )
	{
		//delete
		if (currentIdx > 0)
		{
			playerHiScore->name[currentIdx]='.';
			currentIdx--;
		}
	}
	
	if ( pressed & (PORT_A_KEY_DOWN|PORT_B_KEY_DOWN) )
	{
		letterSpeed = -1;
		letterRate = LETTER_RATE*4;
		decLetter();
	}
	else if ( pressed & (PORT_A_KEY_UP|PORT_B_KEY_UP) )
	{
		letterSpeed = 1;
		letterRate = LETTER_RATE*4;
		incLetter();
	}


#ifdef TARGET_GG
	selector.x = SELECTOR_X + currentIdx*8; //16 because each letter is 2 tiles width
#else
	selector.x = SELECTOR_X + currentIdx*16; //16 because each letter is 2 tiles width
#endif

}

static void joyReleased(unsigned char joy, unsigned int released, unsigned int state)
{
	if ( released & (PORT_A_KEY_DOWN|PORT_B_KEY_DOWN) )
	{
		letterSpeed = 0;
	}
	if ( released & (PORT_A_KEY_UP|PORT_B_KEY_UP) )
	{
		letterSpeed = 0;
	}
}


static void jumpNext()
{
	setup_saveHiScores();

#ifndef TARGET_GG	
	if (gameSetup.nbPlayers == 2)
	{
		if ( (currentPlayer->id == PLAYER_1) && (gameSetup.player2->lives > 0))
		{
			currentPlayer = gameSetup.player2;
			setCurrentScreen(GAME_SCREEN);
			return;
		}

		if ( (currentPlayer->id == PLAYER_2) && (gameSetup.player1->lives > 0))
		{
			currentPlayer = gameSetup.player1;
			setCurrentScreen(GAME_SCREEN);
			return;
		}
	}
#endif

	setCurrentScreen(HISCORE_SCREEN);
}

static void nameInit( )
{
	playerHiScore = setup_getNewHiScore(currentPlayer->score);
	done = (playerHiScore == NULL);

	//not a hiscore, skip 
	if (done)	return;
	
	blinkCounter = 11; //so next update will be 10 and so yellow ;)
	currentIdx = 0;
	currentLetter = 'A'-0x20;
	letterSpeed = 0;


	SMS_displayOff();	

	TEXT_loadFontDouble(0);

	VDP_loadSpritePalette(shawks_pal_bin);
	VDP_setSpritePaletteColor(3, shawks_pal_bin, 2); //yellow

	SMS_loadTiles(selector_bin, FIRST_SPRITE_TILE, selector_bin_size);
	
#ifndef TARGET_GG
	hud_load();
	hud_refresh();//call it right now, it won't change on loop
#endif
	
	VDP_loadBGPalette(shawks_pal_bin);

#ifdef TARGET_GG
	TEXT_drawTextDouble("HIGH SCORE", TILE_X(5), TILE_Y(2));
	TEXT_drawTextDouble("Enter your name", TILE_X(3), TILE_Y(7));
	TEXT_drawTextDouble("Press 1", TILE_X(1+(20-7)/2), TILE_Y(18-1-1));
#else
	TEXT_drawTextDouble("HIGH SCORE", 5, 5);
	TEXT_drawTextDouble("Enter your name", 1, 9);
	TEXT_drawTextDouble("Player.......#", 1, 11);
	TEXT_drawNumber(currentPlayer->id, 29,11);
	TEXT_drawTextDouble("Press 1", 9, 22);
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
	JOY_setReleasedCallback(&joyReleased);

	SMS_displayOn();
}

static void nameUpdate( )
{
	if (done)
	{
		jumpNext();
		return;
	}
	
	//VDP stuff ALWAYS first!
#ifdef TARGET_GG
	TEXT_drawTextDouble(playerHiScore->name, TILE_X(3), TILE_Y(10));
#else
	TEXT_drawTextDouble(playerHiScore->name, 9, 16);
#endif


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
	
	//could be done on active display
	if ( (letterRate > 0) && (--letterRate == 0))
	{
		letterRate = LETTER_RATE;
	
		if (letterSpeed == -1)
		{
			decLetter();
		}
		else if (letterSpeed == 1)
		{
			incLetter();
		}
	}
	
	JOY_update();
}


gameScreen nameScreen =
{
		NAME_SCREEN,
		&nameInit,
		&nameUpdate,
		NULL,
		NULL,
		NULL
};
