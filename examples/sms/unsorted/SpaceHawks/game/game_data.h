#ifndef GAME_DATA_H
#define GAME_DATA_H

//loaded on sprites tiles bank
#define TILE_SHIP			(FIRST_SPRITE_TILE)
#define TILE_SHIP_COUNT		(4*2)

#define TILE_MINE			(TILE_SHIP+TILE_SHIP_COUNT)
#define TILE_MINE_COUNT		1

#define	TILE_ENEMY_SPRITE	(TILE_MINE + TILE_MINE_COUNT)
#define	TILE_ENEMY_SPRITE_COUNT	(3) //*MAX_ENEMIES) would be awesome, but every sprite will share the same time 

#define TILE_ENEMY_BOMB		(TILE_ENEMY_SPRITE +  TILE_ENEMY_SPRITE_COUNT)
#define	TILE_ENEMY_BOMB_COUNT	1

#define TILE_BULLET			(TILE_ENEMY_BOMB + TILE_ENEMY_BOMB_COUNT)
#define TILE_BULLET_COUNT	1

#define TILE_BONUS			(TILE_BULLET + TILE_BULLET_COUNT)
#define TILE_BONUS_COUNT	3


//a sprite to this fixPoint.y is handled as disabled
#define GARAGE_Y	FIX16(200) //don't go over 208, it will end the SAT!

//y position of ship, to optimize collision
#ifdef TARGET_GG
#define SHIP_Y	FIX16(SPRITE_Y((18-2)*8))
#else
#define SHIP_Y	FIX16(20*8)
#endif


typedef struct {
	fix16 x;
	fix16 y;
}fixPoint;

#endif /* GAME_DATA_H */
