#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "defines.h"
#include <arch/sms/SMSlib.h>
#include <arch/sms/PSGlib.h>
#include "fixedbank.h"
#include "vars.h"
#include "funcs.h"
#include "timeredlabel.h"
#include "map.h"
#include "scroller.h"
#include "barrom.h"
#include "explosion.h"
#include "warning.h"
#include "introovni.h"
#include "introsideplayer.h"
#include "introstar.h"
#include "intro3object.h"
#include "waveship.h"
#include "rectship.h"
#include "bombship.h"
#include "spreadship.h"
#include "stage4middleboss.h"
#include "stage4endboss.h"
#include "stage4endbossb.h"
#include "stage4object.h"
#include "stage2object.h"
#include "ww2plane.h"
#include "ww2planeb.h"
#include "ww2zeppelin.h"
#include "ww2ship.h"
#include "stage5missile.h"
#include "stage5endboss.h"
#include "fortressphantom.h"
#include "fortresssearcher.h"
#include "fortresswave.h"
#include "fortresscannon.h"
#include "fortressdoor.h"
#include "stage1middlebossc.h"
#include "stage1middlebossb.h"
#include "stage1middleboss.h"
#include "stage1endboss.h"
#include "monsterblob.h"
#include "monstermissil.h"
#include "monsterhead.h"
#include "stage7middleboss.h"
#include "stage7endboss.h"
#include "stage7object.h"
#include "vulcanstation.h"
#include "vulcantank.h"
#include "vulcanvulcan.h"
#include "vulcanlava.h"
#include "vulcanbird.h"
#include "vulcanlaser.h"
#include "stage2endboss.h"
#include "spacestation.h"
#include "spaceasteroid.h"
#include "spaceshooter.h"
#include "stage3laser.h"
#include "stage3endboss.h"
#include "stage3star.h"
#include "stage6endboss.h"
#include "stage6endbossb.h"
#include "stage6object.h"
#include "skullbone.h"
#include "turnship.h"
#include "stage8lateral.h"
#include "stage8bossa.h"
#include "stage8bossb.h"
#include "stage8bossc.h"
#include "rsgthing.h"
#include "enemy.h"
#include "scripter.h"
#include "mikgamesstage.h"
#include "logostage.h"
#include "jukeboxstage.h"
#include "intro1stage.h"
#include "intro2stage.h"
#include "intro3stage.h"
#include "intro4stage.h"
#include "finishstage.h"
#include "introstage.h"
#include "selectorstage.h"
#include "gameoverstage.h"
#include "stage1.h"
#include "stage2.h"
#include "stage3.h"
#include "stage4.h"
#include "stage5.h"
#include "stage6.h"
#include "stage7.h"
#include "stage8.h"
#include "enemyshoot.h"
#include "playershoot.h"
#include "powerup.h"
#include "player.h"
#include "playstage.h"

// Inicio del juego
void main()
{
	// Iniciamos la consola
	InitConsole();

	// Lo ponemos solo aquí
	gamelevel=0;
	gamestock=3;
	
	// Forever bucle
	while(1)
	{
		// Testing
		/*
		stagenum=8;
		numplayers=6;
		InitPlayerConstants();
		InitPlayer();
		InitPlayStage();
		*/
			
		// Mikgames
		InitMikGamesStage();
		
		// Game intro
		InitIntroStage(1);
		InitIntroStage(4);
		InitIntroStage(2);
		
		// Logo
		InitLogoStage();		

		// If we have jukebox before play
		if(dojukebox==1)
			InitJukeboxStage();
		
		// Selector
		InitSelectorStage();
		
		// Init stage and players
		stagenum=1;
		numplayers=gamestock;

		// Stage looping
		while(stagenum<10)
		{
			if(stagenum==0)
				InitGameoverStage();
			else if(stagenum==9)
			{
				InitIntroStage(5);
				InitIntroStage(3);
			}
			else InitPlayStage();
		}
	}
}

// SMS_EMBED_SEGA_ROM_HEADER(57300,0);  //;)
