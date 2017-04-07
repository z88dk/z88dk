#ifndef _INPUT_MANAGER_H_
#define _INPUT_MANAGER_H_

void engine_input_manager_update(unsigned int curr_joypad1, unsigned int prev_joypad1)
{
	if (curr_joypad1 & PORT_A_KEY_UP && !(prev_joypad1 & PORT_A_KEY_UP))
	{
		engine_gamer_manager_toggle_color();
	}
	if (curr_joypad1 & PORT_A_KEY_DOWN && !(prev_joypad1 & PORT_A_KEY_DOWN))
	{
		engine_enemy_manager_toggle_adi_color();
	}
	if (curr_joypad1 & PORT_A_KEY_LEFT && !(prev_joypad1 & PORT_A_KEY_LEFT))
	{
		engine_enemy_manager_toggle_suz_color();
	}
	if (curr_joypad1 & PORT_A_KEY_RIGHT && !(prev_joypad1 & PORT_A_KEY_RIGHT))
	{
		engine_enemy_manager_toggle_pro_color();
	}
}

#endif//_INPUT_MANAGER_H_