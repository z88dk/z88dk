#include <arch/sms/SMSlib.h>
#include <string.h>

#include "game_text.h"
#include "game_player.h" //for player IDs
#include "../resource.h"


static u16 fontTile = 0;

void TEXT_drawTextDouble(const char *str, u16 x, u16 y)
{
	TEXT_drawTextDoubleExt(str, x, y, 0);
}

void TEXT_drawTextDoubleExt(const char *str, u16 x, u16 y, u16 mask)
{
	char *currentChar;
	SMS_setNextTileatXY(x,y);
	currentChar = (char *) str;
	while(*currentChar != 0)
	{
#ifdef TARGET_GG
		SMS_setTile( mask | (fontTile + (*currentChar -32)) );
#else
		SMS_setTile( mask | (fontTile + 0 + (*currentChar -32)*2) );
		SMS_setTile( mask | (fontTile + 1 + (*currentChar -32)*2) );
#endif

		currentChar++;
	}
}
void TEXT_drawNumber(u8 number, u16 x, u16 y)
{
	u8 idxTile = (16+number);	

	SMS_setNextTileatXY(x, y);
#ifdef TARGET_GG
	SMS_setTile(idxTile);
#else
	idxTile*=2;
	SMS_setTile(idxTile);
	SMS_setTile(idxTile+1);
#endif


}

u16 TEXT_loadFontDouble( u16 tile ) __z88dk_fastcall
{
	fontTile = tile;

	//TODO : use packed version to win some rom bytes
	SMS_loadTiles(amstrad_font_bin, fontTile, amstrad_font_bin_size);

	return (fontTile + amstrad_font_bin_size/32);
}
