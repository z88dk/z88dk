#include <arch/sms/SMSlib.h>
#include "../s8/types.h"
#include "../resource.h"
#include "game_sound.h"


/*
extern const psgFrame sfx_sw_sn7[];
extern const psgFrame sfx_launch_sn7[];
extern const psgFrame sfx_dying_sn7[];

// these SFX could be played at the same time
// so use 1 chan for each, not the same, if possible

// chan 0 (noise)
extern const psgFrame sfx_fire_sn7[1];

// chan 1
extern const psgFrame sfx_new_life_sn7[1];

// chan 2
extern const psgFrame sfx_back_sn7[1];
extern const psgFrame sfx_back2_sn7[1];

// chan 0 (noise)
extern const psgFrame sfx_score_update_sn7[1];
*/

void sound_playSFX( u8 id ) __z88dk_fastcall
{
	u8 trackIdx = 0;
	u8 allowMix = true;
	
	//const psgFrame (*psgData)[1];
	const void *psgData;


	if (id == NO_SOUND)	return;
	if (id > MAX_SOUND)	return;

	
	psgData = NULL;

	switch(id)
	{
		case SOUND_DYING:
			trackIdx = 0; 
			psgData =  &sfx_dying_sn7;
			allowMix = false;
			break;
		case SOUND_FIRE:
			trackIdx = 0;
			psgData = &sfx_fire_sn7;
			break;
		case SOUND_GAME_1:
			trackIdx = 2;
			psgData = &sfx_back_sn7;
			break;
		case SOUND_GAME_2:
			trackIdx = 2;
			psgData = &sfx_back2_sn7;
			break;
		case SOUND_LAUNCH:
			trackIdx = 0; //?
			psgData = &sfx_launch_sn7;
			allowMix = false;
			break;
		case SOUND_NEW_LIFE:
			trackIdx = 1;
			psgData = &sfx_new_life_sn7;
			break;
		case SOUND_SCORE:
			trackIdx = 0;
			psgData = &sfx_score_update_sn7;
			break;
	}

	if (allowMix == false)
	{
		psgplayer_reset( ); //shutdown PSG chans
	}
	
	psgplayer_play(trackIdx, (void *) psgData);
}

void sound_playTheme( )
{
	psgplayer_reset( ); //shutdown PSG chans
	psgplayer_play(0, &sfx_sw_sn7);
}

/*
void sound_update( )
{
	psgplayer_update();
}
* */

void sound_reset()
{
	psgplayer_reset( ); //shutdown PSG chans	
}