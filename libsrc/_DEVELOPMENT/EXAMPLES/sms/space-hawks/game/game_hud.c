#include <arch/sms/SMSlib.h>
#include "../s8/types.h"
#include "../s8/vdp.h"
#include "game_setup.h"
#include "game_hud.h"
#include "game_text.h"

/**
 * Unlike original game, I (for now) don't use 2 colors (blue current, red updated score)
 * 
 * It could be done using 2 set of tiles but i means more ROM and VRAM (10*8*2  = 96bytes)
 * so i first need to be sure it usable on each screen 
 **/
#ifdef TARGET_GG
static u16 oldScores[2];
#else
static u16 oldScores[3];
#endif

static void	drawScore(u16 value, u8 x, u8 y)
{
	//based on itoa (no magic here)
	u8 scoreString[6]; //99999 + \0
	u16 score;
	u8 idx = 4;
	u8 i=0;
	
	score = value;
	scoreString[4] = '0';
	scoreString[5] = 0;
	if (score > 9999)
	{
		scoreString[4] = '9';
		score = 9999;
	}
	
	do
	{
		scoreString[--idx] = '0'+ (score %10);
		score /= 10;
	}while(idx >0); 
	
	
	TEXT_drawTextDoubleExt(scoreString, x, y, TILE_USE_SPRITE_PALETTE | TILE_PRIORITY);
}



void hud_load( )
{
	//force redraw on first hud_update
	oldScores[0] = gameSetup.player1->score+1; 
	oldScores[1] = gameSetup.bestScore+1; 

#ifndef TARGET_GG
	oldScores[2] = gameSetup.player2->score+1; 

	//TILE_USE_SPRITE_PALETTE used to not being updated on raster effect
	//4+3*2+3+3*2+3+3*2+4
	TEXT_drawTextDoubleExt("1UP", 2, 0, TILE_USE_SPRITE_PALETTE | TILE_PRIORITY);
	TEXT_drawTextDoubleExt("TOP", 2*5+1+2, 0, TILE_USE_SPRITE_PALETTE | TILE_PRIORITY);
	TEXT_drawTextDoubleExt("2UP", 32 - 2*5 +2, 0, TILE_USE_SPRITE_PALETTE | TILE_PRIORITY);
#endif
}

void hud_refresh( )
{
	char intChar[5];
	
	if (oldScores[0] != gameSetup.player1->score)
	{
#ifdef TARGET_GG
		drawScore(gameSetup.player1->score, TILE_X(1), TILE_Y(0));
#else
		drawScore(gameSetup.player1->score, 0, 1);
#endif

		oldScores[0] = gameSetup.player1->score;
	}
	
	if (oldScores[1] != gameSetup.bestScore)
	{
#ifdef TARGET_GG
		drawScore(gameSetup.bestScore, TILE_X(20-5-1), TILE_Y(0));
#else
		drawScore(gameSetup.bestScore, 2*5 + 1, 1);
#endif

		oldScores[1] = gameSetup.bestScore;
	}

#ifndef TARGET_GG
	if (oldScores[2] != gameSetup.player2->score)
	{
		drawScore(gameSetup.player2->score, 32 - 2*5, 1);
		oldScores[2] = gameSetup.player2->score;
	}
#endif
}
