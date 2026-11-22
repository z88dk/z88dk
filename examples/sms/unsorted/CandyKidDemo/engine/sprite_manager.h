#ifndef _SPRITE_MANAGER_H_
#define _SPRITE_MANAGER_H_

void engine_sprite_manager_draw(unsigned char x, unsigned char y, unsigned char tile)
{
	SMS_addSprite(x+0, y+0, tile+0);
	SMS_addSprite(x+8, y+0, tile+1);
	SMS_addSprite(x+0, y+8, tile+8);
	SMS_addSprite(x+8, y+8, tile+9);
}

#endif//_SPRITE_MANAGER_H_