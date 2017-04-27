#ifndef GAME_TEXT_H
#define GAME_TEXT_H

#include "../s8/types.h"

/*
#define COLOR_BLUE		0x30
#define COLOR_YELLOW	0x0F
#define COLOR_VIOLET	0x22
#define COLOR_RED		0x03
#define COLOR_BLUE_L	0x3A
#define COLOR_PINK		0x2B
#define COLOR_GREEN		0x0C
#define COLOR_GREEN_L	0x2E
#define COLOR_WHITE		0x3F
*/

void TEXT_drawTextDouble(const char *str, u16 x, u16 y);
void TEXT_drawTextDoubleExt(const char *str, u16 x, u16 y, u16 mask);
void TEXT_drawNumber(u8 number, u16 x, u16 y);
u16 TEXT_loadFontDouble( u16 tile ) __z88dk_fastcall;


#endif /* GAME_TEXT_H */
