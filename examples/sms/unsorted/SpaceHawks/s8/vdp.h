#ifndef VDP_H_
#define VDP_H_

#include "types.h"

#define FIRST_SPRITE_TILE	256 //if useFirstHalf = false

#ifdef TARGET_GG
//160x144 (20x18)
#define TILE_X(x)					((x)+6) //
#define TILE_Y(y)					((y)+3)
#define SPRITE_X(x)					((x)+6*8) //
#define SPRITE_Y(y)					((y)+3*8)

#define VDP_loadBGPalette(pal) 							GG_loadBGPalette(pal)
#define	VDP_setBGPaletteColor(entry, pal, index)		GG_setBGPaletteColor(entry, ((u16 *)pal)[index])
#define VDP_loadSpritePalette(pal)						GG_loadSpritePalette(pal)
#define	VDP_setSpritePaletteColor(entry, pal, index)	GG_setSpritePaletteColor(entry, ((u16 *)pal)[index])

#else //TARGET_SMS
//240x

#define TILE_X(x)					(x)
#define TILE_Y(y)					(y)
#define SPRITE_X(x)					(x)
#define SPRITE_Y(y)					(y)

#define VDP_loadBGPalette(pal) 							SMS_loadBGPalette(pal)
#define	VDP_setBGPaletteColor(entry, pal, index)		SMS_setBGPaletteColor(entry, pal[index])
#define VDP_loadSpritePalette(pal)						SMS_loadSpritePalette(pal)
#define	VDP_setSpritePaletteColor(entry, pal, index)	SMS_setSpritePaletteColor(entry, pal[index])

#endif


void VDP_printText(char *text, unsigned char x, unsigned char y, unsigned int baseTile);
void VDP_clearBG();

#endif /* VDP_H_ */
