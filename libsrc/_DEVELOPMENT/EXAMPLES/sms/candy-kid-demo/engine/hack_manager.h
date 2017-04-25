#ifndef _HACK_MANAGER_H_
#define _HACK_MANAGER_H_

#define PEEK(addr)			(*(unsigned char *)(addr))
#define POKE(addr, data)	(*(unsigned char *)(addr) = (data))

extern unsigned char hacker_debug, hacker_splash;
extern unsigned char hacker_steps, hacker_delay, hacker_hands, hacker_music, hacker_sound, hacker_paths;

#define HACKER_START		0x0050

void engine_hack_manager_init()
{
	hacker_debug = PEEK(HACKER_START - 1);		// 0x004F		// 0=debug on otherwise off.
	hacker_splash= PEEK(HACKER_START - 2);		// 0x004E		// 0=splash off for testing.

	hacker_steps = PEEK(HACKER_START + 0);		// 0x0050		// 0=steps to move: 1,2,4,8.
	hacker_delay = PEEK(HACKER_START + 1);		// 0x0051		// 0=enemy to alternate arm.
	hacker_hands = PEEK(HACKER_START + 2);		// 0x0052		// 0=hands to alternate not.
	hacker_music = PEEK(HACKER_START + 3);		// 0x0053		// 0=music on otherwise off.
	hacker_sound = PEEK(HACKER_START + 4);		// 0x0054		// 0=sound on otherwise off.
	hacker_paths = PEEK(HACKER_START + 5);		// 0x0055		// 0=paths index to testing.
}

void engine_hack_manager_invert()
{
	hacker_splash = !hacker_splash;
	hacker_hands = !hacker_hands;
	hacker_music = !hacker_music;
	hacker_sound = !hacker_sound;
}

void engine_hack_manager_resetX()
{
	hacker_debug = 0;
	hacker_splash= 0;

	hacker_steps = 0;
	hacker_delay = 0;
	hacker_hands = 0;
	hacker_music = 0;
	hacker_sound = 0;
	hacker_paths = 0;
}

#endif//_HACK_MANAGER_H_