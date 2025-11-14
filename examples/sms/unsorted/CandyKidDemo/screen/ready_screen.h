#ifndef _READY_SCREEN_H_
#define _READY_SCREEN_H_

void screen_ready_screen_load()
{
	if (hacker_debug)
	{
		engine_font_manager_draw_data(SCREEN_TYPE_READY, 31, 2);
	}

	engine_text_manager_names();
	engine_gamer_manager_load();
	engine_enemy_manager_load();
}
void screen_ready_screen_update(unsigned char *screen_type, unsigned int curr_joypad1, unsigned int prev_joypad1)
{
	engine_gamer_manager_draw();
	engine_enemy_manager_draw();

	rand();
	engine_input_manager_update(curr_joypad1, prev_joypad1);
	if (curr_joypad1 & PORT_A_KEY_2 && !(prev_joypad1 & PORT_A_KEY_2))
	{
		engine_sound_manager_play();
	}

	// Begin demo here.
	if (curr_joypad1 & PORT_A_KEY_1 && !(prev_joypad1 & PORT_A_KEY_1))
	{
		*screen_type = SCREEN_TYPE_PLAY;
	}
}

#endif//_READY_SCREEN_H_