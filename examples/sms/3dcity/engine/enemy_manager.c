#include "enemy_manager.h"
#include "global_manager.h"
#include "sprite_manager.h"
#include <sms.h>
#include <stdlib.h>

extern unsigned char hacker_death, hacker_level, hacker_enemy, hacker_sound;

extern unsigned char enemyX[MAX_ENEMIES], enemyY[MAX_ENEMIES];
extern unsigned char enemyStart[MAX_ENEMIES], enemyDelta[MAX_ENEMIES], enemyScore[MAX_ENEMIES];
extern unsigned char enemyCheck[MAX_ENEMIES], enemyFrame[MAX_ENEMIES], enemyTimer[MAX_ENEMIES];
extern unsigned char enemyIndex[MAX_ENEMIES], enemyDelay[MAX_ENEMIES], enemyWidth[MAX_ENEMIES];
extern char enemyBound[MAX_ENEMIES];
extern unsigned char bombsX[MAX_ENEMIES], bombsY[MAX_ENEMIES], explosions[MAX_ENEMIES];
extern unsigned char bombsIndex[MAX_ENEMIES], bombsDelay[MAX_ENEMIES], bombsFrame[MAX_ENEMIES], bombsTimer[MAX_ENEMIES];

// Private helper methods.
static void update_enemy(unsigned char index);
static void update_bombs(unsigned char index);
static void spawn_enemy(unsigned char index);
static void draw_enemy(unsigned char index);
static void draw_bombs(unsigned char index);

void engine_enemy_manager_load()
{
	unsigned char index, baser, delay, enemy, space, value;
	for (index = 0; index < hacker_enemy; ++index)
	{
		enemyX[index] = enemyY[index] = bombsX[index] = bombsY[index] = 0;
		enemyCheck[index] = explosions[index] = 0;
		enemyFrame[index] = enemyTimer[index] = 0;
		bombsFrame[index] = bombsTimer[index] = 0;
	}

	// Redo the enemy delays every game.
	baser = BEG_ENEMY_DELAY;
	if (hacker_level)
	{
		baser = MIN_ENEMY_DELAY;
	}
	for (index = 0; index < MAX_ENEMIES; ++index)
	{
		enemy = rand() % MAX_ENEMIES;
		value = (MIN_ENEMY_DELAY - 1) * enemy;

		space = rand() % MIN_ENEMY_DELAY;
		delay = baser + value + space;

		enemyDelay[index] = delay;
	}
}

void engine_enemy_manager_update_enemies()
{
	unsigned char index;
	for (index = 0; index < hacker_enemy; ++index)
	{
		if (1 == explosions[index])
		{
			update_bombs(index);
			continue;
		}

		update_enemy(index);
	}
}
static void update_enemy(unsigned char index)
{
	unsigned char delay = enemyDelay[index];
	if (5 == enemyFrame[index] || 7 == enemyFrame[index])
	{
		delay = delay / 2;
	}
	else if (4 == enemyFrame[index] || 6 == enemyFrame[index])
	{
		delay = hacker_level ? FAST_BLINK_DELAY : SLOW_BLINK_DELAY;
	}
	
	enemyTimer[index]++;
	if (enemyTimer[index] > delay)
	{
		enemyTimer[index] = 0;
		enemyFrame[index]++;

		// Best place to spawn enemy (frame #1).
		if (1 == enemyFrame[index])
		{
			spawn_enemy(index);
		}

		if (enemyFrame[index] > MAX_ENEMY_FRAMES)
		{
			enemyFrame[index] = 0;
			enemyCheck[index] = 1;
		}

		// If end of frames then check for death.
		// Unless invincibility flag set to true.
		if (1 != enemyCheck[index] || hacker_death)
		{
			draw_enemy(index);
		}
	}
}
static void update_bombs(unsigned char index)
{
	// Explosion sound fx.
	if (hacker_sound)
	{
		set_sound_freq(3, 0xE4);
		set_sound_volume(3, 0x0F);
	}

	bombsTimer[index]++;
	if (bombsTimer[index] > bombsDelay[index])
	{
		bombsTimer[index] = 0;
		bombsFrame[index]++;
		if (bombsFrame[index] > MAX_BOMBS_FRAMES)
		{
			bombsFrame[index] = 0;
			explosions[index] = 0;
			set_sound_volume(3, 0);
		}

		draw_bombs(index);
	}
}

void engine_enemy_manager_trigger_explosion(unsigned char index)
{
	set_sound_volume(3, 0);
	explosions[index] = 1;
	bombsFrame[index] = 1;

	enemyFrame[index] = 0;
	enemyTimer[index] = 0;
	draw_enemy(index);

	bombsX[index] = enemyX[index];
	bombsY[index] = enemyY[index];
	bombsFrame[index] = 1;
	bombsTimer[index] = 0;
	draw_bombs(index);

	// Decrease enemy delay = attack faster!
	if (enemyDelay[index] > MIN_ENEMY_DELAY)
	{
		enemyDelay[index]--;
	}

	// Hard level increases ALL enemies speed!
	if (!hacker_level)
	{
		return;
	}
	for (index = 0; index < hacker_enemy; ++index)
	{
		if (enemyDelay[index] > MIN_ENEMY_DELAY)
		{
			enemyDelay[index]--;
		}
	}
}

static void spawn_enemy(unsigned char index)
{
	enemyX[index] = rand() % ENEMY_BOUNDS_RGT;
	enemyY[index] = rand() % enemyDelta[index] + enemyStart[index];
}
static void draw_enemy(unsigned char index)
{
	engine_sprite_manager_draw_enemies(enemyIndex[index], enemyX[index], enemyY[index], enemyFrame[index]);
}
static void draw_bombs(unsigned char index)
{
	engine_sprite_manager_draw_explode(bombsIndex[index], bombsX[index], bombsY[index], bombsFrame[index]);
}

void engine_enemy_manager_init()
{
	unsigned char index;
	for (index = 0; index < MAX_ENEMIES; ++index)
	{
		enemyDelay[index] = 0;
		bombsDelay[index] = BOMBS_DELAYS_ACE;
		enemyIndex[index] = ORG_ENEMY_INDEX + (16 * index);
		bombsIndex[index] = enemyIndex[index];

		enemyX[index] = enemyY[index] = bombsX[index] = bombsY[index] = 0;
		enemyCheck[index] = explosions[index] = 0;
		enemyStart[index] = enemyDelta[index] = 0;
		enemyFrame[index] = enemyTimer[index] = 0;
		bombsFrame[index] = bombsTimer[index] = 0;
	}

	// Set the enemy boundaries.
	if (1 == hacker_enemy)
	{
		enemyStart[0] = 16;  enemyStart[1] = 0; enemyStart[2] = 0;
		enemyDelta[0] = 144; enemyDelta[1] = 0; enemyDelta[2] = 0;
	}
	else if (2 == hacker_enemy)
	{
		enemyStart[0] = 16; enemyStart[1] = 96; enemyStart[2] = 0;
		enemyDelta[0] = 48; enemyDelta[1] = 64; enemyDelta[2] = 0;
	}
	else	// default 3x enemies.
	{
		enemyStart[0] = 16; enemyStart[1] = 64; enemyStart[2] = 128;
		enemyDelta[0] = 16; enemyDelta[1] = 32; enemyDelta[2] = 32;
	}

	enemyBound[0] = -4;  enemyBound[1] = 0;  enemyBound[2] = 8;
	enemyWidth[0] = 8;   enemyWidth[1] = 16; enemyWidth[2] = 32;
	enemyScore[0] = 100; enemyScore[1] = 50; enemyScore[2] = 25;
}
