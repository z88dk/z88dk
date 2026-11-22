#ifndef GAME_SOUND_H
#define GAME_SOUND_H


#include "../s8/psg_player.h"

#define SOUND_DYING		0
#define SOUND_FIRE		(SOUND_DYING+1)
#define SOUND_GAME_1	(SOUND_FIRE+1)
#define SOUND_GAME_2	(SOUND_GAME_1+1)
#define SOUND_LAUNCH	(SOUND_GAME_2+1)
#define SOUND_NEW_LIFE	(SOUND_LAUNCH+1)
#define SOUND_SCORE		(SOUND_NEW_LIFE+1)

#define MAX_SOUND		(SOUND_SCORE+1)
#define NO_SOUND		0xff


#define sound_update( )	( psgplayer_update() )
//void sound_update( );

void sound_reset( );
void sound_playSFX( u8 id ) __z88dk_fastcall;
void sound_playTheme( );

#endif /* GAME_SOUND_H */
