#include "play_screen.h"
#include "../engine/enemy_manager.h"
#include "../engine/font_manager.h"
#include "../engine/gamer_manager.h"
#include "../engine/global_manager.h"
#include "../engine/music_manager.h"
#include "../engine/score_manager.h"
#include "../engine/sprite_manager.h"
#include "../engine/tile_manager.h"
#include <sms.h>

// gamer_manager.c
extern unsigned char targetX, targetY;
extern unsigned char bulletX[MAX_BULLETS], bulletY[MAX_BULLETS], bulletCheck[MAX_BULLETS];

// enemy_manager.c
extern unsigned char enemyX[MAX_ENEMIES], enemyY[MAX_ENEMIES], enemyScore[MAX_ENEMIES];
extern unsigned char enemyCheck[MAX_ENEMIES], enemyFrame[MAX_ENEMIES];
extern unsigned char enemyIndex[MAX_ENEMIES], enemyWidth[MAX_ENEMIES];
extern char enemyBound[MAX_ENEMIES];

extern unsigned char hacker_death, hacker_enemy, hacker_music, hacker_sound;
extern unsigned char screen_play_screen_miss, screen_play_screen_base;

void screen_play_screen_load()
{
	screen_play_screen_miss = 0;
	screen_play_screen_base = 4;
}

void screen_play_bullet_collide()
{
	unsigned char index, check, frame, width, detectX, detectY;
	char bound;

	// Check each bullet for enemy collision.
	for (index = 0; index < MAX_BULLETS; ++index)
	{
		if (1 != bulletCheck[index])
		{
			continue;
		}

		bulletCheck[index] = 0;
		for (check = 0; check < hacker_enemy; ++check)
		{
			frame = enemyFrame[check];
			if (0 == frame)
			{
				continue;
			}

			// zero-index.
			frame = frame - 1;
			if (frame > 2)
			{
				// If enemy=2 then may be blinking;
				// that is frame = 2, 3, 4, 5 or 6.
				frame = 2;
			}
			bound = enemyBound[frame];
			width = enemyWidth[frame];

			detectX = bulletX[index] + bound;
			detectY = bulletY[index] + bound;

			// Check collision with this bullet and enemy.
			if (detectX >= enemyX[check] && detectX <= enemyX[check] + width && 
				detectY >= enemyY[check] && detectY <= enemyY[check] + width)
			{
				// Kill enemy and update score.
				engine_enemy_manager_trigger_explosion(check);
				engine_score_manager_update(enemyScore[frame]);
			}
		}
	}
}

void screen_play_screen_update(int *screen_type, int curr_joypad1, int prev_joypad1)
{
	unsigned char check, detectX, detectY, missY, overX;

	engine_tile_manager_update_middle();
	engine_tile_manager_update_bottom();

	engine_gamer_manager_update_target(curr_joypad1);
	engine_gamer_manager_update_bullets();
	engine_enemy_manager_update_enemies();

	if (curr_joypad1 & JOY_FIREA && !(prev_joypad1 & JOY_FIREA))
	{
		engine_gamer_manager_trigger_bullet();
	}

	// Bullet vs. enemy collision detection.
	if (1 == bulletCheck[0] || 1 == bulletCheck[1] || 1 == bulletCheck[2])
	{
		screen_play_bullet_collide();
	}

	// Invincibility.
	if (hacker_death)
	{
		return;
	}
	
	// Target vs. enemy collision detection.
	overX = 0;
	if (1 == enemyCheck[0] || 1 == enemyCheck[1] || 1 == enemyCheck[2])
	{
		for (check = 0; check < hacker_enemy; ++check)
		{
			if (1 != enemyCheck[check])
			{
				continue;
			}

			enemyCheck[check] = 0;
			detectX = targetX + TARGET_BOUND;
			detectY = targetY + TARGET_BOUND;

			// Enemy collides with target.
			if (detectX >= enemyX[check] && detectX <= enemyX[check] + TARGET_WIDTH && 
				detectY >= enemyY[check] && detectY <= enemyY[check] + TARGET_WIDTH)
			{			
				overX = 1;
				break;
			}
			else
			{
				// Target has maximum misses.
				engine_sprite_manager_draw_enemies(enemyIndex[check], enemyX[check], enemyY[check], 0);				
				screen_play_screen_miss++;
				
				// Very short sound.
				if (hacker_sound)
				{
					set_sound_freq(1, 100);
					set_sound_volume(1, 0x0F);
				}

				missY = ((MAX_MISS_NUM + 2 - screen_play_screen_miss) * 2) + screen_play_screen_miss;
				engine_font_manager_draw_text("X", 31, missY);
				if (screen_play_screen_miss >= MAX_MISS_NUM)
				{
					overX = 1;
					break;
				}
			}
		}
	}

	// GAME OVER!
	if (0 != overX)
	{
		if (hacker_music)
		{
			engine_music_manager_pause_module();
		}

		*screen_type = 6;//screen_type_over;
	}
}
