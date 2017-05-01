#ifndef _TILE_MANAGER_H_
#define _TILE_MANAGER_H_

#define BEG_TOPHALF		80
#define BEG_MIDDLE1		176
#define BEG_MIDDLE2		158
#define BEG_BOTTOM1		144
#define BEG_BOTTOM2		148
#define BEG_BOTTOM3		152
#define BEG_SPLASH		256

#define MID_DELAY1		100
#define MID_DELAY2		50

#define NUM_TOPHALF		58
#define NUM_MIDDLE1		15
#define NUM_MIDDLE2		18
#define NUM_BOTTOM		4
#define NUM_SPLASH		115

void engine_tile_manager_init();
//void engine_tile_manager_load(unsigned char level);
void engine_tile_manager_load(unsigned char level);
void engine_tile_manager_update_middle();
void engine_tile_manager_update_bottom();
void engine_tile_manager_draw();

#endif//_TILE_MANAGER_H_
