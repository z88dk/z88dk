#include "main.h"

// SDSC Header

const unsigned char author[]="StevePro Studios";
const unsigned char name[]="3D City";
const unsigned char description[]="3D City SMS Competition 2016";

// Global variables.
unsigned char global_pause;
unsigned char hacker_death, hacker_level, hacker_enemy, hacker_music, hacker_sound, hacker_tiles, hacker_stars;
int enum_curr_screen_type, enum_next_screen_type;

void global_pause_handler();
void custom_initialize();
void custom_load_content();
void custom_screen_manager_load(int screen_type);
void custom_screen_manager_update(int *screen_type, int curr_joypad1, int prev_joypad1);

void main()
{
	int curr_joypad1, prev_joypad1;
	set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN);

	global_pause = 0;
	add_pause_int(global_pause_handler);
	
	// data, index, count
	load_palette(pal1,  0, 16);
	load_palette(pal2, 16, 16);

	custom_initialize();
	custom_load_content();


	enum_curr_screen_type = 0;//screen_type_none;
	enum_next_screen_type = 1;//screen_type_splash;
	for (;;)
	{
		if (global_pause)
		{
			continue;
		}

		engine_music_manager_play_module();
		if (enum_curr_screen_type != enum_next_screen_type)
		{
			enum_curr_screen_type = enum_next_screen_type;
			custom_screen_manager_load(enum_curr_screen_type);
		}
		
		curr_joypad1 = read_joypad1();
		custom_screen_manager_update(&enum_next_screen_type, curr_joypad1, prev_joypad1);

		prev_joypad1 = curr_joypad1;
		wait_vblank_noint();
	}
}

void global_pause_handler()
{
	if (global_pause)
	{
		engine_font_manager_draw_text(LOCALE_BLANK, GLOBAL_LFT_SIDE, GLOBAL_MID_LINE + 1);
		if (hacker_music && (4 /*screen_type_ready*/ == enum_curr_screen_type || 5 /*screen_type_play*/ == enum_curr_screen_type))
		{
			engine_music_manager_start_module();
		}
		if (hacker_sound && (6 /*screen_type_over*/ == enum_curr_screen_type))
		{
			set_sound_volume(3, 0x0F);
		}
	}
	else
	{
		if (1 /*screen_type_splash*/ != enum_curr_screen_type)
		{
			engine_font_manager_draw_text(LOCALE_PAUSE, GLOBAL_LFT_SIDE, GLOBAL_MID_LINE + 1);
		}
		if (hacker_music && (4 /*screen_type_ready*/ == enum_curr_screen_type || 5 /*screen_type_play*/ == enum_curr_screen_type))
		{
			engine_music_manager_pause_module();
		}
		if (hacker_sound && (6 /*screen_type_over*/ == enum_curr_screen_type))
		{
			set_sound_volume(3, 0);
		}
	}

	global_pause = !global_pause;
}

void custom_initialize()
{
	unsigned char number_enemy = 3;

	engine_hack_manager_init();
	engine_hack_manager_invert();
	
	// Hack 1, 2, or 3 enemies.
	if (1 == hacker_enemy)	{ number_enemy = 1; }
	if (2 == hacker_enemy)	{ number_enemy = 2; }
	hacker_enemy = number_enemy;

	// Initialize other managers.
	engine_score_manager_init();
	engine_enemy_manager_init();
	engine_gamer_manager_init();
	engine_tile_manager_init();
	
	// Initialize screens.
	screen_bases_screen_init();
	screen_splash_screen_init();
	screen_title_screen_init();
	screen_ready_screen_init();
	screen_over_screen_init();
}
void custom_load_content()
{
	engine_font_manager_load();
	engine_sprite_manager_load();
}
void custom_screen_manager_load(int screen_type)
{
	screen_bases_screen_init();
	switch (screen_type)
	{
		case 1://screen_type_splash:
			screen_splash_screen_load();
			break;
		case 2://screen_type_title:
			screen_title_screen_load();
			break;
		case 3://screen_type_level:
			screen_level_screen_load();
			break;
		case 4://screen_type_ready:
			screen_ready_screen_load();
			break;
		case 5://screen_type_play:
			screen_play_screen_load();
			break;
		case 6://screen_type_over:
			screen_over_screen_load();
			break;
	}
}
void custom_screen_manager_update(int *screen_type, int curr_joypad1, int prev_joypad1)
{

	switch (*screen_type)
	{
		case 1://screen_type_splash:
			screen_splash_screen_update(screen_type, curr_joypad1, prev_joypad1);
			break;
		case 2://screen_type_title:
			screen_title_screen_update(screen_type, curr_joypad1, prev_joypad1);
			break;
		case 3://screen_type_level:
			screen_level_screen_update(screen_type, curr_joypad1, prev_joypad1);
			break;
		case 4://screen_type_ready:
			screen_ready_screen_update(screen_type, curr_joypad1, prev_joypad1);
			break;
		case 5://screen_type_play:
			screen_play_screen_update(screen_type, curr_joypad1, prev_joypad1);
			break;
		case 6://screen_type_over:
			screen_over_screen_update(screen_type, curr_joypad1, prev_joypad1);
			break;
	}
}
