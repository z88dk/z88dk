#ifndef GAME_SETUP_H_
#define GAME_SETUP_H_

#include "../s8/types.h"
#include "game_player.h"

#ifdef TARGET_GG
#define	NB_HISCORE	12
#else
#define	NB_HISCORE	15
#endif


#define PTS_FLYING	30//0
#define PTS_ENEMY	15//0
#define PTS_MINE	0
#define PTS_END		300//0

typedef struct
{
	u8 nbPlayers;
	u8 nbLives;
	u8 difficulty;
	u16 bestScore;// /10 to use u16

	player *player1;
	player *player2;
}setup;

typedef struct
{
	u8 name[8]; //7 char + \0
	u16 score; // /10 to use u16
}hiscore_t;

extern hiscore_t hiscores[NB_HISCORE];

extern setup gameSetup;
extern u8 spawnIndex;

extern player *currentPlayer;

void setup_init();
void setup_reset();
void setup_saveHiScores();
void setup_addPoints( u16 points ) __z88dk_fastcall; //points/10
void setup_gainLife( );
void setup_loseLife( );
void setup_resetSlots( );

hiscore_t *setup_getNewHiScore(u16 score);

#endif /* GAME_SETUP_H_ */
