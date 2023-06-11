#include <arch/sms/SMSlib.h>
#include "../s8/types.h"
#include "../s8/vdp.h"
#include "../s8/metasprite.h"
#include "game_enemies.h"
#include "game_mines.h"
#include "game_player.h"
#include "game_bullet.h"
#include "game_data.h"
#include "game_setup.h"
#include "game_sound.h"
#include "../resource.h"

//loaded on BG tiles bank
#define TILE_BG_ENEMY			(0+96*2) //skip font


//original game use 100ms frame, with a spawn every N frame (N = level+1)
//so spawn on SMS should be every 5*N frames (since 5*1/50 = 100ms)
#define SPAWN_DELAY		5 //(3*50)	//3 seconds approx.
#define SCROLL_DELAY	2

#define COL0_X	8
#define ROW0_TILEY	4

#define SLOT_TO_X(slotID) 	(COL0_X + (slotID % NB_COL)*4)
#define SLOT_TO_Y(slotID)	(ROW0_TILEY + (slotID / NB_COL)*2)

//used to test what the best method use : precision vs performance
#define ROUND_FIXED_POS		fix16ToInt //fix16ToRoundedInt

#define SPEED_X		FIX16(1.5)
#define SPEED_Y		FIX16(.7)

#define BOMB_SPEED  FIX16(1.7)

#define AMPLITUDE_INIT	2
#define AMPLITUDE_MAX	16

#define isFlying(e)			( e->position.y != GARAGE_Y )

#define RANDOM_SIZE		(16*8 + 12)


const u8 flyingRandom[RANDOM_SIZE] = { 0x0E , 0x38 , 0x23 , 0x8C , 0x46 , 0x9A , 0x3F , 0x70 , 0x0E , 0xA1 , 0x15 , 0x3F , 0x9A , 0x54 , 0x5B , 0x70,
0x07 , 0x7E , 0x3F , 0x69 , 0x54 , 0x46 , 0x31 , 0x69 , 0x62 , 0x93 , 0x23 , 0x1C , 0x8C , 0x5B , 0x8C , 0x8C,
0x77 , 0x69 , 0x0E , 0x7E , 0x85 , 0xA1 , 0x15 , 0x3F , 0x1C , 0x54 , 0x7E , 0x62 , 0x93 , 0x3F , 0x62 , 0x46,
0x15 , 0x00 , 0x7E , 0x00 , 0x2A , 0x15 , 0x7E , 0x00 , 0x8C , 0x23 , 0x69 , 0x15 , 0x46 , 0x9A , 0x46 , 0x93,
0x3F , 0x4D , 0x93 , 0x70 , 0x00 , 0x31 , 0x54 , 0x7E , 0x3F , 0x15 , 0x0E , 0x31 , 0x9A , 0x1C , 0x07 , 0xA1,
0x93 , 0x0E , 0x07 , 0x70 , 0x15 , 0x9A , 0xA1 , 0x46 , 0x8C , 0x2A , 0x70 , 0xA1 , 0x7E , 0x31 , 0x15 , 0x54,
0xA1 , 0x54 , 0x5B , 0x3F , 0x69 , 0x38 , 0x15 , 0x9A , 0x69 , 0x23 , 0x62 , 0x54 , 0x85 , 0x4D , 0x07 , 0x70,
0x62 , 0x0E , 0xA1 , 0x4D , 0x62 , 0x23 , 0x7E , 0x8C , 0x38 , 0x31 , 0x23 , 0x07 , 0x54 , 0x9A , 0x5B , 0x69,
0xA1 , 0x77 , 0x4D , 0x1C , 0x77 , 0x9A , 0x69 , 0x9A , 0x15 , 0x4D , 0x69 , 0x77};	
		


typedef struct {
	u8 toLeft;
	u8 amplitude;
	u8 slotID;
	u16 ampCounter;
	fixPoint position;
} enemy; 


static enemy enemies[MAX_ENEMIES];
static fixPoint bombs[MAX_BOMBS];


static u8 spawnCounter, spawnDelay;
static u8 flyCounter; //fly animation counter

static u8 leftColumn, rightColumn;

static s16 scrollValue;
static s8 scrollInc;
static u8 scrollCounter;

static const unsigned char *enemySheet;

static void loadFrame(u8 frame) __z88dk_fastcall
{
	SMS_loadTiles(enemySheet + (frame*(alien1_bin_size / 2)), TILE_BG_ENEMY, (alien1_bin_size / 2) );
}

static void loadSpriteFrame(u8 frame) __z88dk_fastcall
{
	SMS_loadTiles(enemySheet + (frame*(alien1_bin_size / 2)), TILE_ENEMY_SPRITE, (alien1_bin_size / 2) );
}


//TODO replace by a const array : faster and less ROM space used
static const unsigned char *getEnemySheet( u8 levelId ) __z88dk_fastcall
{
	switch( levelId )
	{
		case 1:
			return (const unsigned char *) alien2_bin;
			break;
		case 2:
			return (const unsigned char *) alien3_bin;
			break;
		case 3:
			return (const unsigned char *) alien4_bin;
			break;
		case 4:
			return (const unsigned char *) alien5_bin;
			break;
		case 5:
			return (const unsigned char *) alien6_bin;
			break;
		case 6:
			return (const unsigned char *) alien7_bin;
			break;
		case 7:
			return (const unsigned char *) alien8_bin;
			break;

		default:
			break;
	}

	return (const unsigned char *) &alien1_bin;
}

//TODO replace by a const array : faster and less ROM space used
const unsigned char *getBombSheet( u8 id ) __z88dk_fastcall
{
	switch( id )
	{
		case 1:
			return (const unsigned char *) alien2_bomb_bin;
			break;
		case 2:
			return (const unsigned char *) alien3_bomb_bin;
			break;
		case 3:
			return (const unsigned char *) alien4_bomb_bin;
			break;
		case 4:
			return (const unsigned char *) alien5_bomb_bin;
			break;
		case 5:
			return (const unsigned char *) alien6_bomb_bin;
			break;
		case 6:
			return (const unsigned char *) alien7_bomb_bin;
			break;
		case 7:
			return (const unsigned char *) alien8_bomb_bin;
			break;

		default:
			break;
	}

	return (const unsigned char *) alien1_bomb_bin;
}



static enemy *getEnemySlot()
{
	u8 i = 0;	
	enemy *e = &enemies[0];
	
	//this one generate the smallest z80 asm, w/o pop push so faster
	do{	
		if ( e->position.y == GARAGE_Y )	return e;
		e++;
	}while( ++i < MAX_ENEMIES );
	
	return NULL;
/*	
  	u8 i = 0;	
	enemy *e = &enemies[0];
	
	for (i = 0; i < MAX_ENEMIES; i++)
	{
		//e = &enemies[i];
		if ( !isFlying(e) )	return e;
		
		e++;
	}

	return NULL;*/
}

static void killEnemy(enemy *e) __z88dk_fastcall
{
	e->position.y = GARAGE_Y;
}



static fixPoint *getBombSlot()
{
	u8 i = 0;	
	fixPoint *bomb = &bombs[0];
	
	//this one generate the smallest z80 asm, w/o pop push so faster
	do{	
		if ( bomb->y == GARAGE_Y )	return bomb;
		bomb++;
	}while( ++i < MAX_BOMBS );
	
	return NULL;

/*	u8 i;
	fixPoint *bomb;
	for (i = 0; i < MAX_BOMBS; i++)
	{
		bomb = &bombs[i];
		if ( bomb->y != GARAGE_Y)	continue;

		return bomb;
	}

	return NULL;*/
}

static void killBomb(fixPoint *bomb) __z88dk_fastcall
{
	bomb->y = GARAGE_Y;
}

static void launchBomb(u8 col, u8 row)
{
	fixPoint *bomb = getBombSlot();
	if (bomb == NULL)
	{
#ifdef DEBUG
		KDebug_Alert("no bomb slot");
#endif
		return;
	}
	//x = real col X + enemy.width/2 - bomb.width/2
	bomb->x = intToFix16( (8*COL0_X + scrollValue + 8*col*4) + 24/2 - 8/2); //center of col
	bomb->y = intToFix16( 8*ROW0_TILEY + 8*row*2); 
}

//define the max/min scroll value according free enemies col, right and left
static void computeBounds( )
{
	u8 i,j;

	//this init is not needed, unless
	leftColumn = 0xFF;
	rightColumn = NB_COL-1;


	//TODO there is probably to better to comput left and right on the same double for-loop
	for (i=0; i< NB_COL; i++)
	{
		for (j=0; j < NB_ROW; j++)
		{
			if ( currentPlayer->slots[ i + j*NB_COL] != SLOT_EMPTY )
			{
				leftColumn = i;
				goto next; //I'm really really sorry for that but I don't know a better waty to exit a double for-loop :( 
			}
		}
	}

	//full slots empty
	return;

next:
	{
		for (i=0; i< NB_COL; i++)
		{
			for (j=0; j < NB_ROW; j++)
			{
				if ( currentPlayer->slots[ NB_COL - i -1 + j*NB_COL] != SLOT_EMPTY )
				{
					rightColumn = NB_COL-i-1;
					return;
				}
			}
		}
	}
}

static void drawEnemy( u8 x, u8 y)
{	
	SMS_setNextTileatXY(x, y);
	SMS_setTile(TILE_BG_ENEMY);
	SMS_setTile(TILE_BG_ENEMY+1);
	SMS_setTile(TILE_BG_ENEMY+2);
}
static void hideEnemy( u8 x, u8 y)
{	
	SMS_setNextTileatXY(x, y);
	SMS_setTile(0);
	SMS_setTile(0);
	SMS_setTile(0);
}

//draw an alien on BG
static void addSlot( u8 slotID ) __z88dk_fastcall
{
	if (currentPlayer->slots[slotID] == SLOT_READY)
		drawEnemy( SLOT_TO_X(slotID), SLOT_TO_Y(slotID) );
}

//tag a slot as with-enemy (on start or after end of attacks, when alien gets back to its slot)
static void resetSlot( u8 slotID ) __z88dk_fastcall
{
	if (currentPlayer->slots[slotID] == SLOT_BUSY)
		currentPlayer->slots[slotID] = SLOT_READY;

	addSlot(slotID);
}

//hide BG alien while Sprite alien attack
static void spawnSlot( u8 slotID ) __z88dk_fastcall
{
	currentPlayer->slots[slotID] = SLOT_BUSY;
	hideEnemy( SLOT_TO_X(slotID), SLOT_TO_Y(slotID) );
}

//slot definitly clear (after an alien get killed)
static void freeSlot( u8 slotID ) __z88dk_fastcall
{
	currentPlayer->slots[slotID] = SLOT_EMPTY;
	hideEnemy( SLOT_TO_X(slotID), SLOT_TO_Y(slotID) );
	
	//if slot was on scroll scroll limit, redefine it
	if ( ((slotID % NB_COL) == leftColumn) || ((slotID % NB_COL) == rightColumn) )
		computeBounds();
	//
}

//launch an alien attack
static void spawn()
{
	enemy *newEnemy;
	u8 randomEnemy = flyingRandom[spawnIndex++] / 7;
	if (spawnIndex >= RANDOM_SIZE)	spawnIndex = 0;
	
	if ( currentPlayer->slots[ randomEnemy ] != SLOT_READY)
	{
		//not in original game so I removed it
		////force a new spawn quickly
		////spawnCounter = 10;
		return;
	}
	
	newEnemy = getEnemySlot();
	if (newEnemy == NULL)
	{
		//no enemy slot
		return;
	}


	//remove from board
	spawnSlot(randomEnemy);
	newEnemy->slotID = randomEnemy;

	//position on screen from board position
	newEnemy->position.x = intToFix16( ((8*SLOT_TO_X(randomEnemy)) + scrollValue ) );
	newEnemy->position.y = intToFix16( 8*SLOT_TO_Y(randomEnemy) );

	newEnemy->amplitude  = AMPLITUDE_INIT;
	newEnemy->ampCounter = AMPLITUDE_INIT*8;
	newEnemy->toLeft = false;
	//newEnemy->velocity.x = SPEED_X;
	//newEnemy->velocity.y = SPEED_Y;
}

void enemies_init( )
{
	//nothing ?
}

void enemies_update( u8 moveAllowed )
{
	u8 i;
	fixPoint *bomb;
	u8 x, y;
	u8 scratchByte;

	// update flying
	{
		enemy *e = &enemies[0];
		i = 0;
		do//for (i = 0; i < MAX_ENEMIES; i++)
		{
			//e = &enemies[i];
			if ( !isFlying(e) )	goto nextEnemy; //continue;		
			
			if (moveAllowed)
			{
				e->position.x += ((e->toLeft)?-SPEED_X:SPEED_X);
				if ( --e->ampCounter == 0)
				{
					e->toLeft = !e->toLeft;

					//reset amplitude
					if (e->amplitude < AMPLITUDE_MAX)	e->amplitude++;
					e->ampCounter = e->amplitude*8;
				}

				//go past bottom, jump back to its slot
				e->position.y += SPEED_Y;
				if ( e->position.y > FIX16(24*8) )
				{
					resetSlot(e->slotID);
					killEnemy(e);
				}
			}
			
			x = ROUND_FIXED_POS(e->position.x) & 0xFF;
			y = ROUND_FIXED_POS(e->position.y) & 0xFF;

			SMS_addSprite(x, y, TILE_ENEMY_SPRITE);			
			SMS_addSprite(x+8, y, TILE_ENEMY_SPRITE+1);			
			SMS_addSprite(x+16, y, TILE_ENEMY_SPRITE+2);
			
	nextEnemy:
			e++;
		}while( ++i < MAX_ENEMIES );

	}

	// update bomb
	{
		bomb = &bombs[0];
		i = 0;
	//for (i = 0; i < MAX_BOMBS; i++)
		do{
			
			if ( bomb->y == GARAGE_Y )	goto nextBomb;

			if (moveAllowed)
			{
				bomb->y += BOMB_SPEED;
				
				if ( bomb->y > FIX16(24*8) )
				{
					killBomb(bomb);
				}
			}
			
			x = ROUND_FIXED_POS(bomb->x) & 0xFF;
			y = ROUND_FIXED_POS(bomb->y) & 0xFF;
			SMS_addSprite(x, y, TILE_ENEMY_BOMB);
nextBomb:
			bomb++;
		}while( ++i < MAX_BOMBS );
	}

	if (!moveAllowed)	return;
	
	//update fly sound
	flyCounter++;
	if (flyCounter == 20)
	{
		sound_playSFX(SOUND_GAME_1);
	}
	else if (flyCounter == 40)
	{
		sound_playSFX(SOUND_GAME_2);
	}	


	// spawn flyer
	if (--spawnCounter == 0)
	{
		spawnCounter = spawnDelay;
		spawn();
	}

	// update scrolling
	if (leftColumn != 0xFF)
	{
		if (--scrollCounter == 0)
		{
			scrollCounter = SCROLL_DELAY;
			scrollValue+= scrollInc;
			if (scrollInc < 0)
			{
				if (scrollValue <= -(leftColumn*4 + COL0_X -3) * 8 )
				{
					scrollInc *= -1;
				}
			}
			else
			{
				if ( scrollValue >= ((32- (rightColumn*4) - COL0_X -3 -3 ) * 8 ) )
				{
					scrollInc *= -1;
				}
			}
		}
	}
}


void enemies_updateV( )
{
	SMS_setBGScrollX(scrollValue);
	
	//update fly anim of squad
	if (flyCounter == 10)
	{
		loadSpriteFrame(1);
	}
	else if (flyCounter == 20)
	{
		loadFrame(1);
		loadSpriteFrame(0);
	}
	else if (flyCounter == 30)
	{
		loadSpriteFrame(1);
	}
	else if (flyCounter == 40)
	{
		loadFrame(0);
		loadSpriteFrame(0);

		flyCounter = 0;
	}
}

void enemies_reset( )
{
	u8 i;
	enemy *e;
	
	spawnDelay = SPAWN_DELAY*(8-gameSetup.difficulty); // - (gameSetup.difficulty<<2);
	spawnCounter = spawnDelay;
	
	flyCounter = 0;
	
	leftColumn = 0;
	rightColumn = NB_COL-1;
	
	scrollInc = -1;
	scrollCounter = SCROLL_DELAY;
	scrollValue = 0;
	
	enemySheet = getEnemySheet(currentPlayer->level);
	loadFrame(0);
	loadSpriteFrame(0);

	for (i = 0; i < MAX_ENEMIES; i++)
	{
		e = &enemies[i];
		killEnemy(e);
	}	

	//be sure getBombSheet never returns null or wrong value
	SMS_loadTiles(getBombSheet(currentPlayer->level), TILE_ENEMY_BOMB, alien1_bomb_bin_size);
	
	for (i = 0; i < MAX_BOMBS; i++)
	{
		fixPoint *bomb = &bombs[i];
		killBomb(bomb);
	}
	
	

	//no bomb reset ?

	for (i = 0; i < NB_ROW*NB_COL; i++)
 	{
		addSlot(i);
	}
	
	computeBounds();
}


void enemies_kill( )
{
	u8 i;
	for (i = 0; i < NB_ROW*NB_COL; i++)
	{
		resetSlot(i);
	}
	
		
	SMS_setBGScrollX(0);
	scrollValue = 0;
}


bool enemies_areDead()
{
	fixPoint bomb;
	u8 i;
	
	if (leftColumn != 0xFF)	return false;

	for (i = 0; i < MAX_BOMBS; i++)
	{
		if ( bombs[i].y != GARAGE_Y )	return false;
	}
	
	return true;
}


bool enemies_bombVSBullet( )
{
	u8 i;
	fix16 bulletX,bulletY, diff;
	bulletX = bulletPosition.x;
	bulletY = fix16Sub(bulletPosition.y, FIX16(8));
		
	for (i = 0; i < MAX_BOMBS; i++)
	{
		fixPoint *bomb = &bombs[i];
		
		//inactive
		if ( bomb->y == GARAGE_Y )	continue;
		
		//hint:SDCC optimizes better if you make the 2 compare y
		//then the 2 compare X (it keeps the value in memory rathen than
		// loading it everytime)

		//below or garage
		//if ( bulletY > fix16Add(bomb->y, FIX16(8))  )	continue;
		// similar to (bulletY-FIX(8) > bomb-y) so
		if ( bulletY >= bomb->y  )	continue;
		
		  
		//behind
		//if it occurs, we miss the hit so correct it !
		//if ( bulletY < fix16Sub(bomb->y, FIX16(8))  )	continue;
		
		diff = fix16Sub(bomb->x,bulletX);
 		//right
		//if ( bulletX > fix16Add(bomb->x, FIX16(8))  )	continue;
		if ( diff <= FIX16(-8)) 	continue;
		//left
		//if ( bulletX < fix16Sub(bomb->x, FIX16(8))  )	continue;
		if ( diff >= FIX16(8) )	continue;

		//you can't kill a bomb, fool !
		return true;
	}	
	
	return false;
}


bool enemies_flyingVSBullet( )
{
	u8 i;
	fix16 bulletX,bulletY;
	fix16 diff;
	
	bulletX = bulletPosition.x;
	bulletY = bulletPosition.y;
		
	//check if bullet reached a flying enemy
	for (i = 0; i < MAX_ENEMIES; i++)
	{
		enemy *e = &enemies[i];
		
		//inactive
		if ( isFlying(e) == false )	continue;
		
				
		//hint:SDCC optimizes better if you make the 2 compare y
		//then the 2 compare X (it keeps the value in memory rathen than
		// loading it everytime)


		diff = fix16Sub(bulletY, e->position.y);
		//most common cases first ;)
		//below or garage
		//if ( bulletY > fix16Add(e->position.y, FIX16(8))  )	continue;
		if ( diff >= FIX16(8) ) continue;
		
		//behind
		//if ( bulletY < fix16Sub(e->position.y, FIX16(8))  )	continue;
		if ( diff <= FIX16(-8) )	continue;
		
		
		diff = fix16Sub(bulletX, e->position.x);		
		//right
		//if ( bulletX > fix16Add(e->position.x, FIX16(3*8))  )	continue;
		if ( diff >= FIX16(24))	continue; //flying width
		
		//left
		//if ( bulletX < fix16Sub(e->position.x, FIX16(8))  )	continue;
		if ( diff <= FIX16(-8))	continue;	//bomb width
		
		
		//if we reach this point, we hitted a flying enemy

		//kill it and make its slot free
		freeSlot( e->slotID );
		killEnemy(e);

		return true;
	}
	
	return false;
}

bool enemies_groupVSBullet( )
{
	u8 col, row;
	u8 slotID;
	fix16 bulletX,bulletY;
	
	bulletX = bulletPosition.x;
	bulletY = bulletPosition.y;

	//check if bullet reached a waiting enemy
	//remember, it's not sprite, it's on the background
	//problem : background is scrolling so we need compute 'real' enemy position from slot + scroll
	
	
	//outside enemy group
	//test order based on probability of occurring
	if ( bulletY > FIX16((ROW0_TILEY + NB_ROW*2 -1)*8 ) )	return false;
	if ( bulletY < FIX16((ROW0_TILEY*8) - 8) )			return false;
	
	//x to column ID in scrolled plan, based on center of bullet
	col = ( ROUND_FIXED_POS( fix16Add(bulletX,FIX16(4)) ) - scrollValue) /8;
	//col &= 0xF8;
	//col /= 8;
	if (col < COL0_X)	return false;
	//if (col >= (COL0_X + NB_COL*4))	return false;
	
	col -= COL0_X;
	col >>=2; // /= 4; // /4 because each slot is 3 tiles of enemy + 1 tile space

	if (col < leftColumn)	return false;
	if (col > rightColumn)	return false;


	//y to row ID
	row = ( ROUND_FIXED_POS(bulletY) )/8;
	row -= ROW0_TILEY;
	row >>=1; // /= 2; // 1 tile of enemy + 1 tile space
	
	slotID = col + row*NB_COL;
	if ( currentPlayer->slots[slotID] != SLOT_READY )	return false;
	
	//we hit a enemy....
	freeSlot(slotID);
	//...but,as a revenge, it launchs a bomb !
	launchBomb(col, row);
	
	//one enemy dead = increase spawn speed
	if (spawnDelay > 0) //shouldn't occurs but just in case I forgot !
		spawnDelay--;

	return true;	
}


bool enemies_flyingVSShip(/*fixPoint *shipPosition*/)
{
	u8 i;
	enemy *e;

	fix16 shipX, diff;
	shipX = shipPosition.x;
	
	
	for (i = 0; i < MAX_ENEMIES; i++)
	{
		e = &enemies[i];
		
		//inactive
		if ( isFlying(e) == false )	continue;
				
		//hint:SDCC optimizes better if you make the 2 compare y
		//then the 2 compare X (it keeps the value in memory rathen than
		// loading it everytime)

		// below or garage
		// faster to do it this way...
		if (e->position.y < fix16Sub(SHIP_Y, FIX16(8)) )	continue;
		//..than this way because we compare to constant, not dynamic var
		//if ( shipPosition->y > fix16Add(e->position.y, FIX16(8))  )	continue;
		//behind
		//same here : faster this way...
		if (e->position.y > fix16Add(SHIP_Y, FIX16(2*8)) )	continue;
		//..than this way
		//if ( shipPosition->y < fix16Sub(e->position.y, FIX16(2*8))  )	continue;


		diff = fix16Sub( shipX, e->position.x );
		//right
		if (diff >= FIX16(3*8))	continue; // > flying's width
		//left
		if (diff <= FIX16(-4*8))	continue; // < ship's width
	
		return true;
	}
	return false;
}
	
bool enemies_bombVSShip(/*fixPoint *shipPosition*/)
{
	u8 i;
	fixPoint *bomb;
	
	fix16 shipX, diff; 
	shipX = shipPosition.x;
	
	for (i = 0; i < MAX_BOMBS; i++)
	{
		bomb = &bombs[i];
		
		//inactive
//		if ( bomb->y == GARAGE_Y )	continue;
		
		//hint:SDCC optimizes better if you make the 2 compare y
		//then the 2 compare X (it keeps the value in memory rathen than
		// loading it everytime)

		//below or garage
		if (bomb->y < fix16Sub(SHIP_Y, FIX16(8)) )	continue;
		//behind
		if (bomb->y > fix16Add(SHIP_Y, FIX16(2*8)) )	continue;
	
		diff = fix16Sub(shipX, bomb->x);
		//right
		if ( diff >= FIX16(8)  )	continue;
		//left
		if ( diff <= FIX16(-4*8)  )	continue;
		
		return true;
	}	
		
	return false;
}
