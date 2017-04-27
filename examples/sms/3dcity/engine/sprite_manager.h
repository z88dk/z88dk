#ifndef _SPRITE_MANAGER_H_
#define _SPRITE_MANAGER_H_

#define TARGET 		8
#define BULLETS 	16
#define EXPLODES	64

#define ENEMIES  	40
#define ENEMY8  	40
#define ENEMY16 	44
#define ENEMY32		48

#define SPRITES		64

void engine_sprite_manager_load();
void engine_sprite_manager_draw_target(unsigned char x, unsigned char y);
void engine_sprite_manager_draw_bullet(unsigned char i, unsigned char x, unsigned char y, unsigned char n);
void engine_sprite_manager_draw_enemies(unsigned char i, unsigned char x, unsigned char y, unsigned char n);
void engine_sprite_manager_draw_explode(unsigned char i, unsigned char x, unsigned char y, unsigned char n);
void engine_sprite_manager_clear();

#endif//_SPRITE_MANAGER_H_
