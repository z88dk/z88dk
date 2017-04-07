#include <arch/sms/SMSlib.h>
#include "../s8/types.h"
#include "../s8/psg.h"
#include "../s8/psg_player.h"


#define VOLUME	3

bool playingTracks[3];

//we mix up to 3 tracks, should be enought
typedef struct
{
	u16 frameIdx;
	u8 	loop;
	u8	previousNoise;
	u8	previousMixer;
	const psgFrame (*psgData)[1];
}track;

static track tracks[3];

//__z88dk_fastcall broke track_update for some reason...
static void track_update(u8 trackIdx) //__z88dk_fastcall
{	
	psgFrame *frame;
	u8 chan, mixer, prevMixer;
	track *t;

	if (playingTracks[trackIdx] == false )	return;
	
	t = &tracks[trackIdx];
	//if (t->psgData == NULL)	return;

	frame = (psgFrame *) t->psgData[t->frameIdx];
	mixer = frame->mixer;

	if (t->loop == 0)	t->loop = (mixer >>4); //loop 1, mean 1 play, so loop-- at first
	if (t->loop)		t->loop--;
	if (t->loop == 0)	t->frameIdx++;


	prevMixer = t->previousMixer;
	t->previousMixer = mixer;

	if ( !mixer )
	{
		//end of track
		//clean data and PSG channel
		t->psgData = NULL;
		if (prevMixer & 0x08)
		{
				//t->previousNoise = 0;
				PSG_setNoise(0,0);
				PSG_setEnvelope(3, PSG_ENVELOPE_SILENT); //silent
		}
		for (chan = 0; chan<3; chan++)
		{
			//only clear track channel (to avoid to clear another track's one
			if (prevMixer & (1<<chan))
			{
				PSG_setTone(chan, 0);
				PSG_setEnvelope(chan, PSG_ENVELOPE_SILENT); //silent
			}
		}

		playingTracks[trackIdx] = false;
		return;
	}

	if (mixer & 0x08)
	{
		// noise is alway 0xE?
		// where ? = 0trr
		// t =  type (0: periodic, 1: white)
		// rr = rate (0:PSGClock/2, 1: PSGClock/4, 2: PSGClock/8, 3: see tone 3)
		// 		with PSGClock = 3579545Hz  / 16 on NTSC
		// so it limits the possibilities...use volume to get different fx ?

		if (t->previousNoise != frame->noise)
		{
			PSG_write( frame->noise);
			t->previousNoise = frame->noise;
		}
		PSG_setEnvelope(3, VOLUME); //TODO get volume from data ?
	}
	else if (prevMixer & 0x08)
	{
		//clean noise if no longer used
		t->previousNoise = 0;
		PSG_setNoise(0,0);
		PSG_setEnvelope(3, PSG_ENVELOPE_SILENT); //silent
	}


/*
	for (chan = 0; chan<3; chan++)
	{
		if (mixer & (1<<chan))
		{
			PSG_setEnvelope(chan, VOLUME);
			//PSG_write( frame->channels[chan].volume )  ;
			PSG_write( frame->channels[chan].toneLatch );
			PSG_write( frame->channels[chan].toneData  );
		}
		else if (prevMixer & (1<<chan))
		{
			PSG_setTone(chan, 0);
			PSG_setEnvelope(chan, PSG_ENVELOPE_SILENT); //silent
		}
	}
*/	
	if (mixer & 1)
	{
		PSG_setEnvelope(0, VOLUME);
		//PSG_write( frame->channels[0].volume )  ;
		PSG_write( frame->channels[0].toneLatch );
		PSG_write( frame->channels[0].toneData  );
	}
	else if (prevMixer & 1)
	{
		PSG_setTone(0, 0);
		PSG_setEnvelope(0, PSG_ENVELOPE_SILENT); //silent
	}
	
	if (mixer & 2)
	{
		PSG_setEnvelope(1, VOLUME);
		//PSG_write( frame->channels[1].volume )  ;
		PSG_write( frame->channels[1].toneLatch );
		PSG_write( frame->channels[1].toneData  );
	}
	else if (prevMixer & 2)
	{
		PSG_setTone(1, 0);
		PSG_setEnvelope(1, PSG_ENVELOPE_SILENT); //silent
	}

	if (mixer & 4)
	{
		PSG_setEnvelope(2, VOLUME);
		//PSG_write( frame->channels[2].volume )  ;
		PSG_write( frame->channels[2].toneLatch );
		PSG_write( frame->channels[2].toneData  );
	}
	else if (prevMixer & 4)
	{
		PSG_setTone(2, 0);
		PSG_setEnvelope(2, PSG_ENVELOPE_SILENT); //silent
	}
}



void psgplayer_reset( )
{
	PSG_init(); //reset tone and silent of each channel
	
	psgplayer_play(0, NULL);
	playingTracks[0] = false;
	
	psgplayer_play(1, NULL);
	playingTracks[1] = false;
	
	psgplayer_play(2, NULL);
	playingTracks[2] = false;
	/*
	channels[0].psgData = NULL;
	channels[1].psgData = NULL;
	channels[2].psgData = NULL;
	*/
	
	//memset(&channels, 0, 3*sizeof(chanProperties));
}

void psgplayer_update( )
{
	track_update(0); 
	track_update(1); 
	track_update(2); 
}

void psgplayer_play(u8 trackIdx, void *psgData) //const psgFrame (*psgData)[])
{
	//TODO what should be done if track is already playing ?
	// stop it and clean data... 
	
	tracks[trackIdx].psgData = psgData;
	tracks[trackIdx].loop = 0;
	tracks[trackIdx].previousNoise = 0;
	tracks[trackIdx].frameIdx = 0;
	tracks[trackIdx].previousMixer = 0;

	playingTracks[trackIdx] = true;
}
