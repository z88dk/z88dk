#ifndef PSG_PLAYER_H
#define PSG_PLAYER_H

//based on my previous PSG engine on Genny
typedef struct
{
	u8 mixer; 	//llllnccc  l = loop (how many update use the same frame)
				//			n = noise enabled
				//			c = channels (1 bit per channel)
				//00000000 means end of sounds
	u8 noise;
	struct channel{
		u8 volume;
		u8 toneLatch;
		u8 toneData;
	}channels[3];	//noise is handled another way
}psgFrame;


void psgplayer_reset( );
void psgplayer_update( );
void psgplayer_play(u8 track, void *psgData); //const psgFrame (*psgData)[])

#endif /* PSG_PLAYER_H */
