#ifndef _PLAY_SCREEN_H_
#define _PLAY_SCREEN_H_

void screen_play_screen_load()
{
	if (hacker_debug)
	{
		engine_font_manager_draw_data(SCREEN_TYPE_PLAY, 31, 2);
	}

	engine_text_manager_space();
	engine_gamer_manager_load();
	engine_enemy_manager_load();

	moveFrame = 0;
	if (hacker_paths)
	{
		pathIndex = hacker_paths - 1;
	}
	else
	{
		// Ensure do not repeat path!
		while (pathIndex == prevIndex)
		{
			pathIndex = rand() % GAMER_MAX_PATHS;
		}

		prevIndex = pathIndex;
	}

	direction = gamer_route[pathIndex][moveFrame];
	engine_gamer_manager_move();

	if (hacker_debug)
	{
		engine_font_manager_draw_data(pathIndex, 31, 3);
	}

	if (hacker_music)
	{
		PSGPlayNoRepeat(MUSIC_PSG);
	}
}
void screen_play_screen_update(unsigned char *screen_type, unsigned int curr_joypad1, unsigned int prev_joypad1)
{
	engine_gamer_manager_draw();
	engine_enemy_manager_draw();

	if (LIFECYCLE_IDLE == lifecycle)
	{
		moveFrame++;
		if (moveFrame >= GAMER_MAX_FRAME)
		{
			moveFrame = 0;
			*screen_type = SCREEN_TYPE_READY;
			return;
		}

		direction = gamer_route[pathIndex][moveFrame];
		engine_gamer_manager_move();
	}

	engine_gamer_manager_update();

	if (hacker_hands)
	{
		engine_enemy_manager_update();
	}

	engine_input_manager_update(curr_joypad1, prev_joypad1);
	if (curr_joypad1 & PORT_A_KEY_2 && !(prev_joypad1 & PORT_A_KEY_2))
	{
		engine_sound_manager_play();
	}
}

#endif//_PLAY_SCREEN_H_