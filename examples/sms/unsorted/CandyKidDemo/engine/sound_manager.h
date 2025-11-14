#ifndef _SOUND_MANAGER_H_
#define _SOUND_MANAGER_H_

void engine_sound_manager_play()
{
	unsigned char sound;
	if (hacker_sound)
	{
		sound = rand() % SOUNDS_MAX;
		if (0 == sound)
		{
			PSGSFXPlay(SOUND1_PSG, SFX_CHANNEL2);
		}
		else if (1 == sound)
		{
			PSGSFXPlay(SOUND2_PSG, SFX_CHANNEL2);
		}
		else
		{
			PSGSFXPlay(SOUND3_PSG, SFX_CHANNEL2);
		}
	}
}

#endif//_SOUND_MANAGER_H_