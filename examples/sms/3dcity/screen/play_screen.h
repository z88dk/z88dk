#ifndef _PLAY_SCREEN_H_
#define _PLAY_SCREEN_H_

#define MAX_MISS_NUM		4
#define TARGET_BOUND		8
#define TARGET_WIDTH		32

void screen_play_screen_load();
void screen_play_bullet_collide();
void screen_play_screen_update(int *screen_type, int curr_joypad1, int prev_joypad1);

#endif//_PLAY_SCREEN_H_
