#include "hack_manager.h"

extern unsigned char hacker_death, hacker_level, hacker_enemy, hacker_music, hacker_sound, hacker_tiles, hacker_stars;

void engine_hack_manager_init()
{
	hacker_death = PEEK(HACKER_START + 0);		// 0x00C0		// Non-zero = invincibility!
	hacker_level = PEEK(HACKER_START + 1);		// 0x00C1		// 0=easy (default)  1=hard.
	hacker_enemy = PEEK(HACKER_START + 2);		// 0x00C2		// 0=3x enemies else 1 or 2.
	hacker_music = PEEK(HACKER_START + 3);		// 0x00C3		// 0=music on otherwise off.
	hacker_sound = PEEK(HACKER_START + 4);		// 0x00C4		// 0=sound on otherwise off.
	hacker_tiles = PEEK(HACKER_START + 5);		// 0x00C5		// 0=tiles on otherwise off.
	hacker_stars = PEEK(HACKER_START + 6);		// 0x00C6		// 0=stars on otherwise off.
}

void engine_hack_manager_invert()
{
	hacker_music = !hacker_music;
	hacker_sound = !hacker_sound;
	hacker_tiles = !hacker_tiles;
	hacker_stars = !hacker_stars;
}

void engine_hack_manager_resetX()
{
	hacker_death = 0;
	hacker_level = 0;
	hacker_enemy = 0;
	hacker_music = 0;
	hacker_sound = 0;
	hacker_tiles = 0;
	hacker_stars = 0;
}
