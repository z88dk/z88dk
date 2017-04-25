#include <arch/sms/SMSlib.h>
#include <string.h>
#include "../s8/types.h"
#include "game_setup.h"
#include "game_sound.h"

#define LIFE_BONUS_VALUE	1000/*0*/


setup gameSetup;
hiscore_t hiscores[NB_HISCORE];
player *currentPlayer;


//which enemy spawn index
// see enemies.c
// never reset it on game, to avoid "deja vu" at each level start
u8 spawnIndex;


void setup_init()
{
#ifdef USE_SRAM	
	if (1) //sram_read(&hiscores, sizeof(hiscore_t)*15) == FALSE )
	{
#endif
		//default values
		u8 i;
		for (i= 0; i < NB_HISCORE; i++)
		{
			if (i%2)
				strcpy(hiscores[i].name, "..HAWKS");
			else
				strcpy(hiscores[i].name, "SPACE..");
				
			hiscores[i].score = 1000/*0*/;	
		}

#ifdef USE_SRAM
		//sram_write(&hiscores, sizeof(hiscore_t)*15);
	}
#endif

	//to init player.score = 0 and bestscore
	setup_reset();
}

void setup_reset()
{
	spawnIndex = 0;
	
	gameSetup.difficulty = 0;
	gameSetup.nbLives = 3;
	gameSetup.nbPlayers = 1;
	gameSetup.bestScore = hiscores[0].score;

#ifndef TARGET_GG
	//reset p2
	player2.id = PLAYER_2;
	player2.level = 0;
	player2.lives = gameSetup.nbLives;
	player2.score = 0;
	gameSetup.player2 = &player2;

	currentPlayer = gameSetup.player2;
	setup_resetSlots();
#endif

	//reset P1
	player1.id = PLAYER_1;
	player1.level = 0;
	player1.lives = gameSetup.nbLives;
	player1.score = 0;
	gameSetup.player1 = &player1;

	currentPlayer = gameSetup.player1;
	setup_resetSlots();
}


void setup_addPoints( u16 points ) __z88dk_fastcall
{
	u16 oldScore = currentPlayer->score / LIFE_BONUS_VALUE;
	currentPlayer->score += points;
	
	if (oldScore < (currentPlayer->score/LIFE_BONUS_VALUE))
	{
		currentPlayer->lives++;
		sound_playSFX( SOUND_NEW_LIFE );
	}
	
	if (currentPlayer->score > gameSetup.bestScore)
	{
		gameSetup.bestScore = currentPlayer->score;
	}
}

void setup_saveHiScores()
{
#ifdef USE_SRAM
//	sram_write(&hiscores, sizeof(hiscore_t)*NB_HISCORE);
#endif
}

hiscore_t *setup_getNewHiScore(u16 score)
{
	u8 i,j;
	hiscore_t *newHiscore = NULL;
	
	for (i=0; i < NB_HISCORE; i++)
	{
		if (hiscores[i].score < score)
		{
			newHiscore = &(hiscores[i]);
			if (i < (NB_HISCORE-1))
			{
				for (j = (NB_HISCORE-1); j>i; j-- )
				{
					hiscores[j].score = hiscores[j-1].score;
					strcpy(hiscores[j].name, hiscores[j-1].name);
				}
			}
			newHiscore->score = score;
			strcpy(newHiscore->name, "A......");
			break;
		}
	}
	
	gameSetup.bestScore = hiscores[0].score;
	return newHiscore;
}

void setup_gainLife( )
{
	currentPlayer->lives++;

}

void setup_loseLife( )
{
	currentPlayer->lives--;
}


void setup_resetSlots()
{
	u8 i;
	for (i = 0; i < NB_ROW*NB_COL; i++)
	{
		currentPlayer->slots[i] = SLOT_READY;
	}
}
