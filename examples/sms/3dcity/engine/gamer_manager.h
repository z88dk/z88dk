#ifndef _GAMER_MANAGER_H_
#define _GAMER_MANAGER_H_

#define	GAMER_BOUNDS_LFT	0
#define	GAMER_BOUNDS_TOP	28
#define	GAMER_BOUNDS_RGT	240
#define	GAMER_BOUNDS_BOT	176
#define MAX_BULLET_FRAMES	6
#define ORG_BULLET_INDEX	52
#define	OFFSET_LARGE		4
#define	OFFSET_SMALL		2
#define UNSELECTED			-1

void engine_gamer_manager_init();
void engine_gamer_manager_load();
void engine_gamer_manager_update_bullets();
void engine_gamer_manager_update_target(int joypad1);
void engine_gamer_manager_trigger_bullet();
void engine_gamer_manager_draw_target();

#endif//_GAMER_MANAGER_H_
