#ifndef _SPLASH_SCREEN_H_
#define _SPLASH_SCREEN_H_

extern unsigned int screen_bases_screen_count;
extern unsigned int screen_bases_screen_timer;
extern unsigned char screen_splash_screen_delay;

void screen_splash_screen_load()
{
	screen_splash_screen_delay = SPLASH_DELAY;
}
void screen_splash_screen_update(unsigned char *screen_type, unsigned int curr_joypad1, unsigned int prev_joypad1)
{
	unsigned char level = 0;
	if ((curr_joypad1 & PORT_A_KEY_1 && !(prev_joypad1 & PORT_A_KEY_1)) ||
		(curr_joypad1 & PORT_A_KEY_2 && !(prev_joypad1 & PORT_A_KEY_2)))
	{
		level = 1;
	}

	screen_bases_screen_timer++;
	if (screen_bases_screen_timer >= screen_splash_screen_delay)
	{
		level = 1;
	}

	if (level)
	{
		engine_asm_manager_clear_VRAM();
		engine_content_manager_load();

		*screen_type = SCREEN_TYPE_TITLE;
	}
}

#endif//_SPLASH_SCREEN_H_