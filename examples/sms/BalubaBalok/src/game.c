#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arch/sms/SMSlib.h>
#include <arch/sms/PSGlib.h>
#include "bank1.h"


// Datos de partida
signed char gameplayers;
unsigned int gamescore;
unsigned char gamestage;

// Frames en stage
unsigned int stageframe;

// Datos del player
unsigned char playerx,playery;
unsigned char playersprite;
signed char playerside;
unsigned char playerstate;
signed char playergravity;
unsigned char playerjumped;
unsigned char playerdiecounter;
unsigned char playerendcounter;
unsigned char maptilemap_bin[1536];

#define EXTRALIFE 1000

#define PLAYERSTAY 1
#define PLAYERFALLING 2
#define PLAYERDIE 3
#define PLAYEREND 4

#define ENEMYSTAY 1
#define ENEMYFALLING 2

unsigned char numenemies;
unsigned char enemystate[]={0,0,0,0};
unsigned char enemyposx[]={0,0,0,0};
unsigned char enemyposy[]={0,0,0,0};
signed char enemyside[]={0,0,0,0};
signed char enemygravity[]={0,0,0,0};
unsigned char maxenemies;


// Flechas
unsigned char numarrows;
unsigned char arrowposx[]={0,0,0,0,0,0,0,0};
unsigned char arrowposy[]={0,0,0,0,0,0,0,0};
unsigned char arrowside[]={0,0,0,0,0,0,0,0};
unsigned char arrowlife[]={0,0,0,0,0,0,0,0};

// Bombas
unsigned char numbombs;
unsigned char bombposx[]={0,0,0,0};
unsigned char bombposy[]={0,0,0,0};
unsigned char bomblife[]={0,0,0,0};

// Explosiones
unsigned char numexplosions;
unsigned char explosionposx[]={0,0,0,0,0,0,0,0,0,0,0,0};
unsigned char explosionposy[]={0,0,0,0,0,0,0,0,0,0,0,0};
unsigned char explosionsprite[]={0,0,0,0,0,0,0,0,0,0,0,0};

// El numero de cajas
unsigned char numboxes;

// Controla los timings de la puerta
signed int doorcounter;
signed int doorspeed;

// Si hay que salir de la pantalla de juego
unsigned gameexit;

// Origen de salida de enemigos o el player en la pantalla de juegos
unsigned char originx,originy;

#define PLAYERBASE 0
#define ARROWBASE 32
#define BOMBBASE 34
#define EXPLOSIONBASE 36
#define ENEMYBASE 60

const unsigned char palette_bin[] = {0x00,0x3F,0x10,0x3C,0x08,0x0F,0x2F,0x03,0x17,0x2A,0x00,0x00,0x00,0x00,0x00,0x00};

// Inicia la consola
void init_console()
{
	// La consola
	SMS_init();
	
	// We need this
	SMS_getKeysStatus();
}

// Limpia la pantalla
void clearscreen()
{
	unsigned int a;

	// Los sprites
	SMS_initSprites(); 
	SMS_finalizeSprites(); 
	SMS_copySpritestoSAT(); 
	
	// Fill background
	SMS_setNextTileatXY (0,0);
	for(a=0;a<(32*24);a++)
		SMS_setTile (0);
	
	// El background
	SMS_setBackdropColor(0);
}

// Carga la fuente
void load_font()
{
	SMS_loadPSGaidencompressedTiles(font_psgcompr,224-64);
}

// Update del scroll
void updateScroll(signed int sx,signed int sy)
{
	SMS_setBGScrollX(sx);
	SMS_setBGScrollY(sy);
}

void init_stage()
{
	// Iniciamos las frames
	stageframe=0;

	// Clear screen
	clearscreen();

	// Fill all tiles
	SMS_VRAMmemset (0,0,32*256);
	
	// The font
	load_font();

	// El valor del scroll
	updateScroll(0,0);

	// Default palettes
	SMS_loadBGPalette(palette_bin);
	SMS_loadSpritePalette(palette_bin);

	// Enable VDP
	SMS_displayOn();
}

void exit_stage () 
{
	// Stop sound
	PSGStop ();
	PSGSFXStop ();
	
	// Disable VDP
	SMS_displayOff ();	
}

// Carga los graficos
void load_graphics_to_vram(unsigned char *psgcompr,unsigned char *tilemap, unsigned int size)
{
	SMS_loadPSGaidencompressedTiles(psgcompr,0);
	SMS_loadTileMap(0,0,tilemap,size);
}

// Dibujamos un texto
void writetext(unsigned char *text,unsigned char x, unsigned char y)
{
	int a;

	// Cambiamos el caracter de las letras
	SMS_setNextTileatXY (x,y);
	a=0;
	while(text[a]!=0)
		if((text[a]>=32)&&(text[a]<96))
			SMS_setTile (text[a++]+121);
}

// Dibujamos un texto
void writenumber(unsigned int i,unsigned int d,unsigned char x, unsigned char y)
{
	// Añadimos a x
	x+=d;
	
	// Ponemos todos los dígitos
    while(d--)
	{ 
		SMS_setNextTileatXY (x--,y);
		SMS_setTile((i%10)+48+121);
        i = i/10;
    }
}

// Etiqueta de score
void updatelabelscore()
{
	writenumber(gamescore,5,14,0);
	writetext("0",20,0);
}

// Etiqueta de players
void updatelabelplayers()
{
	writenumber(gameplayers,1,4,0);
}

// Etiqueta de stage
void updatelabelstage()
{
	writenumber(gamestage,2,29,0);
}

// Limpia una tile
void settile(unsigned int a, unsigned char t)
{
	SMS_setNextTileatLoc(a);
	SMS_setTile(t);
	maptilemap_bin[(a<<1)]=t;
}

// Limpia una tile
void settilexy(unsigned char x, unsigned char y, unsigned char t)
{
	settile(x+(y<<5),t);
}

// Limpia una tile
void settilexyb(unsigned char x, unsigned char y, unsigned char t)
{
	settilexy(x>>3,y>>3,t);
}

// Obtiene una tile
unsigned char gettilexy(unsigned char x, unsigned char y)
{
	return maptilemap_bin[(x+(y<<5))<<1];
}

// Obtiene una tile
unsigned char gettilexyb(unsigned char x, unsigned char y)
{
	return maptilemap_bin[((x>>3)+((y>>3)<<5))<<1];
}
	
// Pone el player
void setplayer()
{
	// Set player
	playerx=(originx*8)+3;
	playery=(originy*8)+7;

	// Datos de inicio del player
	playersprite=PLAYERBASE;
	playerside=1;
	playerstate=PLAYERSTAY;
	playergravity=0;
}

// Pone un enemigo
void setenemy()
{
	// Set enemy	
	if(numenemies<maxenemies)
	{
		enemyposy[numenemies]=(originy<<3)+7;
		enemyposx[numenemies]=originx<<3;
		enemystate[numenemies]=ENEMYSTAY;
		if(stageframe%2)
			enemyside[numenemies]=1;
		else
			enemyside[numenemies]=-1;
		enemygravity[numenemies]=0;
		numenemies++;
	}
}

// Pone un box
void setbox()
{
	numboxes++;
}

void replacetiles()
{
	numboxes=0;
		
	for(int a=2*32;a<24*32;a++)
	{
		int b=a<<1;
		if((maptilemap_bin[b])==20)
		{
			originy=(a>>5);
			originx=1+(a%32);
			setplayer();
		}
		if((maptilemap_bin[b])==28)
			setbox();
	}
}

// Update stage and frames
void update_stage()
{
	// Increase frames
	stageframe++;

	// Wait for vblank
	SMS_waitForVBlank();
	
	// Copy sprites
	SMS_copySpritestoSAT();
}

// Update sound
void update_psg()
{
	// Update sounds
	PSGFrame();
	PSGSFXFrame();
}

// Comprueba si esta dentro de un bloque
unsigned char insideblock(unsigned char x,unsigned char y)
{
	unsigned char c;
	c=gettilexyb(x,y);
	if(c<4)return 1; else return 0;
}

// Devuelve una animacion
unsigned char getanimation(char base,char length)
{
	return base+(((stageframe>>3)%length)<<2);
}

unsigned char canmoveleft(unsigned char x, unsigned char y)
{
	if(x%8!=0)return 1;
	if(insideblock(x-1,y))return 0;
	if(insideblock(x-1,y-8))return 0;
	return 1;
}

unsigned char canmoveright(unsigned char x,unsigned char y)
{
	if(x%8!=0)return 1;
	if(insideblock(x+8,y))return 0;
	if(insideblock(x+8,y-8))return 0;	
	return 1;
}

unsigned char canmoveup(unsigned char x, unsigned char y, signed char b)
{
	if(((y-8+b)%8)==((y-8)%8))return 1;
	if(insideblock(x,y-8+b))return 0;
	if(insideblock(x+7,y-8+b))return 0;
	return 1;
}

unsigned char canmovedown(unsigned char x, unsigned char y, signed char b)
{
	if(((y+b)%8)==(y%8))return 1;
	if(insideblock(x,y+b))return 0;
	if(insideblock(x+7,y+b))return 0;
	return 1;
}

// Movimiento horizontal del player
void doplayerhorizontalmovement(unsigned int ks)
{
	if(ks & PORT_A_KEY_LEFT)
	{
		// El lado
		playerside=-1;
		
		// El sprite
		if (playerstate==PLAYERSTAY)
			playersprite=getanimation(PLAYERBASE+12,2);		
		else
			playersprite=PLAYERBASE+20;
		
		// Movement
		if(canmoveleft(playerx,playery))
			playerx--;
	}
	else if(ks & PORT_A_KEY_RIGHT)
	{
		// El lado
		playerside=1;
		
		// El sprite
		if (playerstate==PLAYERSTAY)
			playersprite=getanimation(PLAYERBASE,2);
		else
			playersprite=PLAYERBASE+8;

		// Movement
		if(canmoveright(playerx,playery))
			playerx++;
	}
	else 
	{
		if(playerstate==PLAYERSTAY)
		{
			if(playerside==-1)playersprite=PLAYERBASE+12;else playersprite=PLAYERBASE;
		}
		else
		{
			if(playerside==-1)playersprite=PLAYERBASE+20;else playersprite=PLAYERBASE+8;
		}
	}
}

// Movimiento horizontal del enemigo
void doenemyhorizontalmovement(unsigned char a)
{
	if(enemyside[a]==-1)
	{
		// Movement
		if(canmoveleft(enemyposx[a],enemyposy[a]))
			enemyposx[a]--;
		else
		{
			if(canmoveleft(enemyposx[a],enemyposy[a]-8))
			{
				enemystate[a]=ENEMYFALLING;
				enemygravity[a]=-8;
			}
			else
			{
				if(canmoveleft(enemyposx[a],enemyposy[a]-16))
				{
					enemystate[a]=ENEMYFALLING;
					enemygravity[a]=-12;
				}
				else
				{
					if(canmoveleft(enemyposx[a],enemyposy[a]-24))
					{
						enemystate[a]=ENEMYFALLING;
						enemygravity[a]=-16;
					}
					else enemyside[a]=1;
				}
			}
		}
	}
	else
	{
		// Movement
		if(canmoveright(enemyposx[a],enemyposy[a]))
			enemyposx[a]++;
		else
		{
			if(canmoveright(enemyposx[a],enemyposy[a]-8))
			{
				enemystate[a]=ENEMYFALLING;
				enemygravity[a]=-8;
			}
			else
			{
				if(canmoveright(enemyposx[a],enemyposy[a]-16))
				{
					enemystate[a]=ENEMYFALLING;
					enemygravity[a]=-12;
				}
				else
				{
					if(canmoveright(enemyposx[a],enemyposy[a]-24))
					{
						enemystate[a]=ENEMYFALLING;
						enemygravity[a]=-16;
					}
					else enemyside[a]=-1;
				}
			}
		}		
	}
}

// Fix player y, y le añade una fila (1) o no (0)
unsigned char fixy(unsigned char y)
{
	y>>=3;
	y<<=3;
	y+=7;
	return y;
}

// Actualiza una box si es necesario (y si hay box)
void upgradebox(unsigned char a, unsigned char b)
{
	unsigned char c=gettilexy(a,b);
	if(c==6)
	{
		settilexy(a,b,8);
		settilexy(a+1,b,9);
	}
	else if(c==4)
	{
		settilexy(a,b,6);
		settilexy(a+1,b,7);
	}
}

// Crea una bomba
void setbomb(unsigned char a, unsigned char b)
{
	// A la lista de contadores
	if(numbombs<4)
	{
		// Cambiamos la bomba
		settilexy(a,b,26);
		settilexy(a+1,b,27);
		
		bombposx[numbombs]=a;
		bombposy[numbombs]=b;
		bomblife[numbombs]=64;
		numbombs++;
	}		
	else
	{
		// La borramos, ay que no pudo ser
		settilexy(a,b,23);
		settilexy(a+1,b,23);
	}
}

// Crea una explosion
void setexplosion(unsigned char a, unsigned char b)
{
	// A la lista de contadores
	if(numexplosions<12)
	{
		explosionposx[numexplosions]=a;
		explosionposy[numexplosions]=b;
		explosionsprite[numexplosions]=0;
		numexplosions++;
	}		
}

// Remove arrow
void removearrow(signed char a)
{
	// Remove list of sprites
	if(a<numarrows-1)
	{
		for(char b=a;b<numarrows-1;b++)
		{
			arrowposx[b]=arrowposx[b+1];
			arrowposy[b]=arrowposy[b+1];
			arrowside[b]=arrowside[b+1];
			arrowlife[b]=arrowlife[b+1];
		}
	}
	// Bajamos el numero de arrows
	numarrows--;
}

// Añadimos puntos
unsigned char addtoscore(unsigned int p)
{
	unsigned int a,b;
	
	// Sumamos los puntos y vemos si hay vida extra
	a=gamescore/EXTRALIFE;
	gamescore+=p;
	b=gamescore/EXTRALIFE;
	
	// La etiqueta
	updatelabelscore();
	
	// Vida extra
	if(b>a)
	{
		gameplayers++;
		updatelabelplayers();
		PSGSFXPlay (sfx_life_psg,3);
		return 1;
	}
	return 0;
}

// Remove enemy
void removeenemy(signed char a)
{
	// Explosion
	setexplosion(enemyposx[a],enemyposy[a]-16);
	
	// Remove list of sprites
	if(a<numenemies-1)
	{
		for(char b=a;b<numenemies-1;b++)
		{
			enemyposx[b]=enemyposx[b+1];
			enemyposy[b]=enemyposy[b+1];
			enemystate[b]=enemystate[b+1];
			enemyside[b]=enemyside[b+1];
			enemygravity[b]=enemygravity[b+1];
		}
	}
	// Bajamos el numero de enemies
	numenemies--;
	
	// Actualizamos los puntos
	addtoscore(5);
	
	// El contador de creacion de enemigos
	doorcounter=doorspeed;
}

// Remove bomb
void removebomb(signed char a)
{
	unsigned char x,y;

	x=(bombposx[a]<<3);
	y=8+(bombposy[a]<<3);
	
	// Chequea colisiones con enemigos
	if(numenemies>0)
	{
		for(signed char b=numenemies-1;b>=0;b--)
		{
			if(enemyposx[b]<x+16)
				if(enemyposx[b]>x-8)
					if(enemyposy[b]>y-16)
						if(enemyposy[b]<y+12)
							removeenemy(b);
		}
	}
	
	// Limpiamos el sprite de la bomba
	settilexy(bombposx[a],bombposy[a],23);
	settilexy(bombposx[a]+1,bombposy[a],23);
	
	// Creamos la explosion
	setexplosion(bombposx[a]<<3,(bombposy[a]-1)<<3);

	// Explosion
	PSGSFXPlay (sfx_explosion_psg,3);
	
	// Remove list of sprites
	if(a<numbombs-1)
	{
		for(char b=a;b<numbombs-1;b++)
		{
			bombposx[b]=bombposx[b+1];
			bombposy[b]=bombposy[b+1];
			bomblife[b]=bomblife[b+1];
		}
	}
	// Bajamos el numero de bombs
	numbombs--;
}

// Remove explosion
void removeexplosion(signed char a)
{
	// Remove list of sprites
	if(a<numexplosions-1)
	{
		for(char b=a;b<numexplosions-1;b++)
		{
			explosionposx[b]=explosionposx[b+1];
			explosionposy[b]=explosionposy[b+1];
			explosionsprite[b]=explosionsprite[b+1];
		}
	}
	// Bajamos el numero de explosions
	numexplosions--;
}

// Mueve una bomba
void dobombmovement(unsigned int a)
{
	// Uno menos de vida
	bomblife[a]--;
	
	// Si es preciso borrarlo
	if(bomblife[a]==0)
		removebomb(a);
}

// Las bombas
void dobombsmovement()
{
	if(numbombs>0)
		for(signed char a=numbombs-1;a>=0;a--)
			dobombmovement(a);
}

// Mueve una flecha
void doarrowmovement(unsigned int a)
{
	// Para simplificar calculos
	unsigned char x=arrowposx[a];
	unsigned char y=arrowposy[a];
	
	// Actualizamos la posicion
	if(arrowside[a]==1)x+=2; else x-=2;
	arrowposx[a]=x;
	
	// Uno menos de vida
	arrowlife[a]--;
	
	// Chequea colisiones con enemigos
	if(numenemies>0)
	{
		for(signed char b=numenemies-1;b>=0;b--)
		{
			if(x>enemyposx[b])
				if(x<enemyposx[b]+8)
					if(y<enemyposy[b])
						if(y>enemyposy[b]-11)
							removeenemy(b);
		}
	}
	
	// Si es preciso borrarlo
	if((x<4)||(x>=252)||(arrowlife[a]==0))
		removearrow(a);
}

// Las arrows
void doarrowsmovement()
{
	if(numarrows>0)
		for(signed char a=numarrows-1;a>=0;a--)
			doarrowmovement(a);
}

// Crea una flecha
void setarrow(unsigned char a, unsigned char b, signed char s)
{
	if(numarrows<8)
	{
		arrowposx[numarrows]=a<<3;
		arrowposy[numarrows]=b<<3;
		arrowside[numarrows]=s;
		arrowlife[numarrows]=16;
		numarrows++;
	}		
}

// Las flechas laterales
void dofire(unsigned char a,unsigned char b)
{
	// Quitamos la base de flechas
	settilexy(a,b,23);
	settilexy(a+1,b,23);

	// Explosion
	PSGSFXPlay (sfx_explosion_psg,3);
	
	// Montamos las flechas
	setarrow(a,b,-1);
	setarrow(a+1,b,1);
}

// Actualiza una box si es necesario (y si hay box)
void checkjumpcrash(unsigned char a,unsigned char b)
{
	unsigned char c;
	
	// Si le estamos dando por culo a una de abajo
	if(b<2)b=22;
	
	// Veamos
	c=gettilexy(a,b);
	if(c==28)
		upgradebox(a,b-1);
	else if(c==29)
		upgradebox(a-1,b-1);
	else if(c==24)
		setbomb(a,b);
	else if(c==25)
		setbomb(a-1,b);
	else if(c==30)
		dofire(a,b);
	else if(c==31)
		dofire(a-1,b);
}

// Chequea si el player salta
void doplayercheckjumpbutton(unsigned int ks)
{
	
	if(ks&PORT_A_KEY_1)
	{
		if(playerjumped==0)
		{
			playerstate=PLAYERFALLING;
			playergravity=-16;
			playerjumped=1;
			checkjumpcrash((playerx+4)>>3,(playery-4)>>3);
			
			if(!PSGSFXGetStatus())
				PSGSFXPlay (sfx_jump_psg,3);
		}
	}
	else playerjumped=0;
}

// Chequea el movimiento vertical
void doplayerverticalmovement()
{
	signed char b=(playergravity>>3);
	
	// Subiendo
	if(playergravity<0)
	{
		if(canmoveup(playerx,playery,b))
			playery+=b;
		else
		{
			playergravity=8;
			checkjumpcrash((playerx+4)>>3,(playery-24)>>3);
		}
	}
	
	// Bajando
	if(playergravity>0)
	{
		if(canmovedown(playerx,playery,b))
			playery+=b;
		else
		{
			playery=fixy(playery);
			playerstate=PLAYERSTAY;
		}
	}
	// Ahhhh la gravedad
	if(playergravity<16)playergravity+=1;
}

// Chequea el movimiento vertical
void doenemyverticalmovement(unsigned char a)
{
	signed char b;
	
	// Gravedad simplificada
	b=enemygravity[a];
	b>>=3;
	
	// Subiendo
	if(b<0)
	{
		if(canmoveup(enemyposx[a],enemyposy[a],b))
			enemyposy[a]+=b;
		else
		{
			enemygravity[a]=8;
		}
	}
	// Bajando
	else if(b>0)
	{
		if(canmovedown(enemyposx[a],enemyposy[a],b))
			enemyposy[a]+=b;
		else
		{
			enemyposy[a]=fixy(enemyposy[a]);
			enemystate[a]=ENEMYSTAY;
			// Solo corregimos de vez en cuando
			if(stageframe%2)
			{
				if(playerx<enemyposx[a])enemyside[a]=-1;
				if(playerx>enemyposx[a])enemyside[a]=1;
			}
		}
	}
	else
	{
		if(enemyside[a]==-1)
		{
			if(canmoveleft(enemyposx[a],enemyposy[a]))enemyposx[a]--;
		}
		else
		{
			if(canmoveright(enemyposx[a],enemyposy[a]))enemyposx[a]++;
		}
	}
	
	// Ahhhh la gravedad
	if(enemygravity[a]<16)enemygravity[a]+=1;
}

// Remueve un box
void removebox(unsigned char x, unsigned char y)
{
	unsigned char a;
	
	// Cogemos la tile existente
	unsigned char c=gettilexy(x,y-1);
	
	// Quitamos la caja
	settilexy(x,y-1,23);
	settilexy(x+1,y-1,23);

	// Vamos a ver si ponemos algo
	if(c==4)
	{
		settilexy(x,y,23);
		settilexy(x+1,y,23);
	}
	else if(c==6)
	{
		settilexy(x,y,24);
		settilexy(x+1,y,25);
	}
	else if(c==8)
	{
		settilexy(x,y,30);
		settilexy(x+1,y,31);
	}
	
	// Actualizamos los puntos
	a=addtoscore(10);
	
	// Bajamos el numero de boxes
	numboxes--;

	// Se sale si es preciso
	if(numboxes==0)
	{
		playerstate=PLAYEREND;
		playerendcounter=200;
		PSGStop();
		PSGPlayNoRepeat (finish_psg);
	}
	else
	{
		// Sonido de coger
		if(!a)
			PSGSFXPlay(sfx_get_psg,3);
	}
}

// Chequea colisiones con boxes
void doplayercheckboxes()
{
	unsigned char c;
	c=gettilexyb(playerx+4,playery-6);
	if(c==28)
		removebox(((playerx+4)>>3),(playery-6)>>3);
	else if(c==29)
		removebox(((playerx+4)>>3)-1,(playery-6)>>3);
}

// Movimiento del player
void doplayermovement()
{
	unsigned int ks;

	// Collisiones
	if(playerstate!=PLAYERDIE)
		if(numenemies>0)
			for(char a=0;a<numenemies;a++)
				if(playerx<enemyposx[a]+8)
					if(playerx>enemyposx[a]-8)
						if(playery<enemyposy[a]+8)
							if(playery>enemyposy[a]-8)
							{
								playerstate=PLAYERDIE;
								playerdiecounter=0;
								PSGStop();
								PSGSFXPlay (sfx_die_psg,3);
							}

	// Boxes
	doplayercheckboxes();
	
	// Check for key
	ks=SMS_getKeysStatus(); 

	// Falling
	if(playerstate==PLAYERFALLING)
	{
		doplayerhorizontalmovement(ks);
		doplayerverticalmovement();
	}
	
	// Stay
	if(playerstate==PLAYERSTAY)
	{
		doplayerhorizontalmovement(ks);
		if(canmovedown(playerx,playery,1))
		{
			playerstate=PLAYERFALLING;
			playergravity=8;
			playery++;
		}
		else doplayercheckjumpbutton(ks);
	}
	
	// Die
	if(playerstate==PLAYERDIE)
	{
		if(playerdiecounter==0)
			setexplosion(playerx,playery-16);
		if(playerdiecounter==8)
			setexplosion(playerx+4,playery-12);
		if(playerdiecounter==16)
			setexplosion(playerx-4,playery-20);
		if(playerdiecounter==24)
			setexplosion(playerx,playery-16);
		if(playerdiecounter==32)
			setexplosion(playerx+4,playery-20);
		if(playerdiecounter==40)
			setexplosion(playerx-4,playery-12);
		if(playerdiecounter==48)
			setexplosion(playerx,playery-16);
		if(playerdiecounter==56)
			setexplosion(playerx+4,playery-12);
		if(playerdiecounter==64)
			setexplosion(playerx-4,playery-20);
		if(playerdiecounter==72)
			setexplosion(playerx,playery-16);
			
		playerdiecounter++;
		if(playerdiecounter>200)
		{
			gameexit=1;
			gameplayers--;
		}
	}
}
		
// Carga un tilemap
void loadtilemap(unsigned char *tiles,unsigned char *tilemap,unsigned int tilemapsize)
{
	load_graphics_to_vram(tiles,tilemap,tilemapsize);
	memcpy(maptilemap_bin,tilemap,1536);
}

// Dibuja un sprite
void addTwinSprite(unsigned char x, unsigned char y, unsigned char p)
{
	SMS_addSprite(x,y,p);
	SMS_addSprite(x,y+8,p+2);
}

// Update sprites
void updatespriting()
{
	unsigned char b,c,d;
	
	// Iniciamos los sprites
	SMS_initSprites(); 

	// Explosiones... notese que ha habido que separar la funcion para que no pete
	if(numexplosions>0)
	{
		for(int a=0;a<numexplosions;a++)
		{
			b=explosionsprite[a];
			b>>=2;
			b<<=2;
			b+=EXPLOSIONBASE;
			addTwinSprite(explosionposx[a],explosionposy[a],b);
			addTwinSprite(explosionposx[a]+8,explosionposy[a],b+1);
		}
	}

	// El player
	if(playerstate!=PLAYERDIE)
	{
		addTwinSprite(playerx-2,playery-12,playersprite);
		addTwinSprite(playerx+6,playery-12,playersprite+1);
	}
	
	// Enemigos... notese que ha habido que separar la funcion para que no pete
	b=stageframe%numenemies;
	if(numenemies>0)
	{
		for(int a=0;a<numenemies;a++)
		{
			c=(b+a)%numenemies;
			if(enemyside[c]==-1)
				addTwinSprite(enemyposx[c],enemyposy[c]-15,ENEMYBASE);
			else
				addTwinSprite(enemyposx[c],enemyposy[c]-15,ENEMYBASE+4);
		}
	}

	// Arrows
	if(numarrows>0)
		for(int a=0;a<numarrows;a++)
			SMS_addSprite(arrowposx[a],arrowposy[a],arrowside[a]==1?ARROWBASE:ARROWBASE+1);

	// Bombx
	if(numbombs>0)
		for(int a=0;a<numbombs;a++)
		{
			b=bombposx[a];
			b<<=3;
			b+=8;
			c=bombposy[a];
			c<<=3;
			d=((stageframe/4)%2)+BOMBBASE;
			SMS_addSprite(b,c,d);
		}
		
	// Finish
	SMS_finalizeSprites(); 
}

void checkenemyjumpleft(unsigned char a)
{
	unsigned char c,x,y;
	unsigned int b;
	
	c=enemyposx[a];
	if(c%8==0)
	{
		x=((enemyposx[a])>>3)-1;
		y=((enemyposy[a])>>3)-2;
		b=((y<<5)+x)<<1;
		if(maptilemap_bin[b]==2)
		{
			enemystate[a]=ENEMYFALLING;
			enemyside[a]=-1;
			enemygravity[a]=-16;
		}
	}
}

void checkenemyjumpright(unsigned char a)
{
	unsigned char c,x,y;
	unsigned int b;
	
	c=enemyposx[a];
	if(c%8==0)
	{
		x=((enemyposx[a])>>3)+1;
		y=((enemyposy[a])>>3)-2;
		b=((y<<5)+x)<<1;
		if(maptilemap_bin[b]==0)
		{
			enemystate[a]=ENEMYFALLING;
			enemyside[a]=1;
			enemygravity[a]=-16;
		}
	}
}

// Update de un enemigo
void doenemymovement(signed char a)
{
	if(enemystate[a]==ENEMYFALLING)
	{
		doenemyverticalmovement(a);
	}
	else
	{
		if(playery<enemyposy[a])
		{
			if(enemyside[a]==1)
				checkenemyjumpright(a);

			if(enemyside[a]==-1)
				checkenemyjumpleft(a);
		}
		
		// Caida...
		if(enemystate[a]==ENEMYSTAY)
		{
			if(canmovedown(enemyposx[a],enemyposy[a],1))
			{
				enemystate[a]=ENEMYFALLING;
				enemygravity[a]=8;
				enemyposy[a]++;
			}
			else
				doenemyhorizontalmovement(a);
		}
	}
}

// Update de los enemigos
void doenemiesmovement()
{
	if(numenemies>0)
		for(signed char a=numenemies-1;a>=0;a--)
			if((stageframe+a)%((gamestage>>3)+2))
				doenemymovement(a);
}

// Update de un enemigo
void doexplosionmovement(signed char a)
{
	unsigned char s;
	s=explosionsprite[a];
	s++;
	if(s>=24)
		removeexplosion(a);
	else
		explosionsprite[a]=s;
}

// Update de los enemigos
void doexplosionsmovement()
{
	if(numexplosions>0)
		for(signed char a=numexplosions-1;a>=0;a--)
			doexplosionmovement(a);
}

// Movimiento de la puerta
void dodoormovement()
{
	if(doorcounter==0)
	{
		// Ponemos el enemigo
		setenemy();
		
		// Reseteamos el contador
		doorcounter=doorspeed;
	}
	else doorcounter--;

}

// Pantalla de juego
void initplayscreen()
{
	init_stage();

	// Lo volvemos a apagar
	SMS_displayOff();
		
	// Sprites
	SMS_loadPSGaidencompressedTiles(sprites_psgcompr, PLAYERBASE+256); 

	// Tilemap
	if(gamestage%6==0)
	loadtilemap(tiles_psgcompr,stage4tilemap_bin,stage4tilemap_bin_size);
	if(gamestage%6==1)
	loadtilemap(tiles_psgcompr,stage1tilemap_bin,stage1tilemap_bin_size);
	if(gamestage%6==2)
	loadtilemap(tiles_psgcompr,stage5tilemap_bin,stage5tilemap_bin_size);
	if(gamestage%6==3)
	loadtilemap(tiles_psgcompr,stage6tilemap_bin,stage6tilemap_bin_size);
	if(gamestage%6==4)
	loadtilemap(tiles_psgcompr,stage2tilemap_bin,stage2tilemap_bin_size);
	if(gamestage%6==5)
	loadtilemap(tiles_psgcompr,stage3tilemap_bin,stage3tilemap_bin_size);

	// Score, players, etc.
	writetext("REST     SCORE          STAGE   ",0,0);
           
	// Labels
	updatelabelplayers();
	updatelabelscore();
	updatelabelstage();

	// Put things on screen
	replacetiles();
	
	// Lo volvemos a encender
	SMS_displayOn();

	// Para no salirse
	gameexit=0;

	// Iniciamos los datos que necesitamos
	numarrows=0;
	numenemies=0;
	numbombs=0;
	numexplosions=0;

	// Max enemies
	maxenemies=4;
	if(gamestage<12)maxenemies=3;
	if(gamestage<4)maxenemies=2;
	
	// La velocidad a la que se crean los enemigos
	doorspeed=150-gamestage*7;
	if(doorspeed<20)doorspeed=20;
	
	// El contador de creacion de enemigos... la primera vez le damos cancha
	doorcounter=120;

	// Musica
	PSGPlay (ost_psg);
	
	// Bucle
	while(1)
	{
		if(playerstate!=PLAYEREND)
		{
			// Si hay que salir
			if (gameexit==1)
			{
				exit_stage();
				return;
			}
			
			// Movimiento del player
			doplayermovement();
			
			// Door
			dodoormovement();
			
			// Enemies
			doenemiesmovement();
			
			// Arrows
			doarrowsmovement();
			
			// Bombs
			dobombsmovement();

			// Explosions
			doexplosionsmovement();
		}
		else
		{
			// El counter
			playerendcounter--;
			
			// El sprite
			playersprite=24+(((playerendcounter>>4)%2)<<2);
			
			if(playerendcounter==0)
			{
				gamestage++;
				exit_stage();
				return;
			}
		}
			
		// Update stage
		update_stage();

		// Hay que mantener esto simple
		if(maxenemies<4)
			updatespriting();
		else
			if(stageframe%2)
				updatespriting();

		// Update psg
		update_psg();
	}
}

// Pantalla de game over
void initgameoverscreen()
{
	// Init stage
	init_stage();
	
	// Un cartelillo
	writetext("GAME  OVER",11,12);
	
	// Musica
	PSGPlayNoRepeat (gameover_psg);
	
	// Bucle
	while(1)
	{
		// Vemos si salimos
		if(stageframe>200)
		{
			// Goto mikscreen
			exit_stage();
			return;
		}
		else
		{
			// Update stage and psg
			update_stage();
			update_psg();
		}
	}
}

// Pantalla de stage
void initstagescreen()
{
	// Init stage
	init_stage();
	
	// Un cartelillo
	writetext("STAGE",11,12);
	writenumber(gamestage,2,17,12);

	// Bucle
	while(1)
	{
		// Vemos si salimos
		if(stageframe>72)
		{
			// Goto playscreen
			exit_stage();
			return;
		}
		else
		{
			// Update stage and psg
			update_stage();
			update_psg();
		}
	}
}

// Labores de seleccion de stage
char doselectstage(unsigned int ks)
{
	// Select stage
	writetext("  SELECT STAGE   ",8,14);
	writenumber(gamestage,2,14,16);

	// Play
	if(ks & PORT_A_KEY_2)
		return 1;
	
	// Key left
	if(ks & PORT_A_KEY_LEFT)
		if(gamestage>1)gamestage--;
	
	// Key right
	if(ks & PORT_A_KEY_RIGHT)
		if(gamestage<64)gamestage++;
	
	// Nope!
	return 0;
}

char dopressinit(unsigned int ks)
{
	// Put the press start text
	if(((stageframe%60)/30)<1)
		writetext("PRESS JUMP BUTTON",8,14);
	else
		writetext("                 ",8,14);
			
	// Jump to next screen?
	if(ks & PORT_A_KEY_1)
	{
		// Datos de juego
		gamescore=0;
		gameplayers=3;
		gamestage=1;
		return 1;
	}
	
	// Nope!
	return 0;
}

// Pantalla de logo
void initlogoscreen()
{
	unsigned int ks;
	unsigned char phase;

	// Init stage
	init_stage();
	
	// Cargamos los graficos a la pantalla
	load_graphics_to_vram(gamelogo_psgcompr,gamelogotilemap_bin,gamelogotilemap_bin_size);	
	
	// Letreros fijos
	writetext("A GAME DEVELOPED BY MIKE",4,19);
	writetext("FOR THE LD RETRO CHALLENGE",3,20);
	writetext("JANUARY 2017 MIKGAMES",5,21);
	writetext("CONTACT AT ERUIZ00@GMAIL.COM",2,22);
	
	// The phase
	phase=0;

	// Bucle
	while(1)
	{
		// Check for key
		ks=SMS_getKeysStatus(); 
		
		if(phase==0)
		{
			// Pres jump
			phase=dopressinit(ks);
		}
		if(phase==1)
		{
			// Select stage
			if (doselectstage(ks))
			{
				exit_stage();
				return;
			}
		}			
		// Update stage and psg
		update_stage();
		update_psg();
	}
}

// Pantalla de mik
void initmikscreen()
{
	
	unsigned int scry;
	
	// Init stage
	init_stage();
	
	// El valor del scroll
	scry=16;
	updateScroll(0,scry);
	
	// Cargamos los graficos a la pantalla
	load_graphics_to_vram(mikgames_psgcompr,mikgamestilemap_bin,mikgamestilemap_bin_size);

	// Bucle
	while(1)
	{
		// Increase frames
		if(stageframe>100)
		{
			exit_stage();
			return;
		}
		else
		{
			// Update stage and psg
			update_stage();
			update_psg();
			
			// El scroll del logo
			if (scry<136)scry+=4;
			updateScroll(0,scry);
		}
	}
}

// Inicio del juego
void main()
{
	// Iniciamos la consola
	init_console();

	// Forever bucle
	while(1)
	{
		// Empezamos la presentacion
		initmikscreen();
	
		// El logo screen
		initlogoscreen();

		// El logo screen
		while(gameplayers>=0)
		{
			initstagescreen();
			initplayscreen();
		}

		// El gameover
		initgameoverscreen();
	}
}
