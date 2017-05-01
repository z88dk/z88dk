#ifndef _ENEMY_MANAGER_H_
#define _ENEMY_MANAGER_H_

#define MAX_ENEMY_FRAMES	7
#define ORG_ENEMY_INDEX		4
#define MAX_BOMBS_FRAMES	4
#define MIN_ENEMY_DELAY		50
#define BEG_ENEMY_DELAY		100
#define FAST_BLINK_DELAY	10
#define SLOW_BLINK_DELAY	20
#define	BOMBS_DELAYS_ACE	10
#define	ENEMY_BOUNDS_RGT	224

void engine_enemy_manager_init();
void engine_enemy_manager_load();
void engine_enemy_manager_update_enemies();
void engine_enemy_manager_trigger_explosion(unsigned char index);

#endif//_ENEMY_MANAGER_H_
