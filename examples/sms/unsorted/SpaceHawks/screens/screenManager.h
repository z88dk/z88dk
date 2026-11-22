#ifndef SCREENMANAGER_H_
#define SCREENMANAGER_H_

#include "../s8/types.h"
#include "../s8/screen.h" //for gameScreen

#define SPRITESMIND_SCREEN	1
#define HISCORE_SCREEN 		2
#define TITLE_SCREEN 		3
#define SELECT_SCREEN 		4
#define GAME_SCREEN 		5
#define WIN_SCREEN 			6
#define NAME_SCREEN 		7
#define GAMEOVER_SCREEN 	8


extern gameScreen spritesmindScreen;
extern gameScreen hiscoreScreen;
extern gameScreen titleScreen;
extern gameScreen selectScreen;
extern gameScreen gameplayScreen;
extern gameScreen winScreen;
extern gameScreen nameScreen;
extern gameScreen gameoverScreen;


void setCurrentScreen(int screenID);

#endif /* SCREENMANAGER_H_ */
