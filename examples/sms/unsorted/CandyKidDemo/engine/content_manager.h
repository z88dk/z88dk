#ifndef _CONTENT_MANAGER_H_
#define _CONTENT_MANAGER_H_

#define TREE_TILES		8
#define FONT_TILES		16
#define SPLASH_TILES	144

void engine_content_manager_splash()
{
	// Splash tiles.
	SMS_loadPSGaidencompressedTiles(splash__tiles__psgcompr, SPLASH_TILES);
	SMS_loadSTMcompressedTileMap(0, 0, splash__tilemap__stmcompr);
	SMS_loadBGPalette(splash__palette__bin);
}

void engine_content_manager_load()
{
	// Tree tiles.
	SMS_loadPSGaidencompressedTiles(tree__tiles__psgcompr, TREE_TILES);
	SMS_loadBGPalette(tree__palette__bin);

	// Font tiles.
	SMS_loadPSGaidencompressedTiles(font__tiles__psgcompr, FONT_TILES);
	SMS_loadBGPalette(font__palette__bin);

	// Sprite tiles.
	SMS_loadPSGaidencompressedTiles(sprites__tiles__psgcompr, SPRITE_TILES);
	SMS_loadSpritePalette(sprites__palette__bin);
}

#endif//_CONTENT_MANAGER_H_