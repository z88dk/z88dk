#include "main.h"

// Global variables.
bool global_pause;
unsigned char hacker_debug, hacker_splash;
unsigned char hacker_steps, hacker_delay, hacker_hands, hacker_music, hacker_sound, hacker_paths;
unsigned char enum_curr_screen_type, enum_next_screen_type;

void custom_initialize();
void custom_load_content();
void custom_screen_manager_load(unsigned char screen_type);
void custom_screen_manager_update(unsigned char *screen_type, const unsigned int curr_joypad1, const unsigned int prev_joypad1);

void main (void)
{
	// Must be static to persist values!
	static unsigned int curr_joypad1 = 0;
	static unsigned int prev_joypad1 = 0;

	unsigned char psgFXGetStatus = 0;
	global_pause = false;

	SMS_setSpritePaletteColor(0, RGB(0,0,0));

	SMS_setSpriteMode(SPRITEMODE_NORMAL);
	SMS_useFirstHalfTilesforSprites(true);

	engine_asm_manager_clear_VRAM();

	custom_initialize();
	custom_load_content();

	SMS_displayOn();

	enum_curr_screen_type = SCREEN_TYPE_NONE;
	enum_next_screen_type = SCREEN_TYPE_SPLASH;
	for (;;)
	{
		if (SMS_queryPauseRequested())
		{
			SMS_resetPauseRequest();
			global_pause = !global_pause;
			if (global_pause)
			{
				engine_font_manager_draw_text(LOCALE_PAUSED, 8, 12);
				PSGSilenceChannels();
			}
			else
			{
				engine_font_manager_draw_text(LOCALE_TITLE2, 8, 12);
				PSGRestoreVolumes();
			}
		}

		if (global_pause)
		{
			continue;
		}

		if (enum_curr_screen_type != enum_next_screen_type)
		{
			enum_curr_screen_type = enum_next_screen_type;
			custom_screen_manager_load(enum_curr_screen_type);
		}

		SMS_initSprites();

		curr_joypad1 = SMS_getKeysStatus();
		custom_screen_manager_update(&enum_next_screen_type, curr_joypad1, prev_joypad1);

		SMS_finalizeSprites();
		SMS_waitForVBlank();
		SMS_copySpritestoSAT();

		PSGFrame();
		PSGSFXFrame();

		prev_joypad1 = curr_joypad1;
	}
}

void custom_initialize()
{
	engine_hack_manager_init();
	engine_hack_manager_invert();

	// Hacker gamer steps.
	if (hacker_steps >= GAMER_MAX_STEPS)
	{
		hacker_steps = GAMER_MAX_STEPS;
	}
	else if (hacker_steps >= 4)
	{
		hacker_steps = 4;
	}
	else if (hacker_steps >= 2)
	{
		hacker_steps = 2;
	}
	else if (0 == hacker_steps)
	{
		hacker_steps = GAMER_STD_STEPS;
	}

	// Hacker enemy delay.
	if (0 == hacker_delay)
	{
		hacker_delay = ENEMY_STD_DELAY;
	}
	if (hacker_delay < ENEMY_MIN_DELAY)
	{
		hacker_delay = ENEMY_MIN_DELAY;
	}

	// Hacker paths.
	if (0 != hacker_paths)
	{
		if (hacker_paths > GAMER_MAX_PATHS)
		{
			hacker_paths = GAMER_MAX_PATHS;
		}
	}

	engine_gamer_manager_init();
	engine_enemy_manager_init();
	engine_path_manager_init();
}
void custom_load_content()
{
	if (hacker_splash)
	{
		engine_content_manager_splash();
	}

	engine_gamer_manager_load();
	engine_enemy_manager_load();
}
void custom_screen_manager_load(unsigned char screen_type)
{
	switch (screen_type)
	{
	case SCREEN_TYPE_SPLASH:
		screen_splash_screen_load();
		break;
	case SCREEN_TYPE_TITLE:
		screen_title_screen_load();
		break;
	case SCREEN_TYPE_READY:
		screen_ready_screen_load();
		break;
	case SCREEN_TYPE_PLAY:
		screen_play_screen_load();
		break;
	}
}
void custom_screen_manager_update(unsigned char *screen_type, const unsigned int curr_joypad1, const unsigned int prev_joypad1)
{
	switch (*screen_type)
	{
	case SCREEN_TYPE_SPLASH:
		screen_splash_screen_update(screen_type, curr_joypad1, prev_joypad1);
		break;
	case SCREEN_TYPE_TITLE:
		screen_title_screen_update(screen_type, curr_joypad1, prev_joypad1);
		break;
	case SCREEN_TYPE_READY:
		screen_ready_screen_update(screen_type, curr_joypad1, prev_joypad1);
		break;
	case SCREEN_TYPE_PLAY:
		screen_play_screen_update(screen_type, curr_joypad1, prev_joypad1);
		break;
	}

	if (hacker_debug)
	{
		engine_font_manager_draw_data(curr_joypad1, 31, 12);
		engine_font_manager_draw_data(prev_joypad1, 31, 13);
	}
}

// Z88DK SPECIFIES HEADER INFO VIA PRAGMAS

extern const unsigned char ckd_author[] = "StevePro Studios";
extern const unsigned char ckd_name[] = "Candy Kid Demo";
extern const unsigned char ckd_description[] = "Simple Sega Master System demo to run on real hardware!";

// SMS_EMBED_SEGA_ROM_HEADER(9999, 0);
// SMS_EMBED_SDSC_HEADER(1, 0, 2017, 3, 17, "StevePro Studios", "Candy Kid Demo", "Simple Sega Master System demo to run on real hardware!");
