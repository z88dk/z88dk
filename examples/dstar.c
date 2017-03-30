/*
 * Ported to the Ti82/83/83+ (rest will follow) by Henk Poley
 * Extended with different sprite sizes and sound by Stefano Bodrato
 *
 * * * * * * *
 *
 *      dstar.c
 *
 *		DStar Z88 - C Demo
 *		Original TI game By A Von Dollen
 *		Converted to Z88 By D Morris
 *		Keys: Q,A,O,P,SPACE,H,G
 *
 * * * * * * *
 *
 *      dstarz88 is a conversion of a TI86 game I found with
 *      source on www.ticalc.org.
 *
 *      The original program was written by Andrew Von Dollen who
 *      in turn based it on a HP game by Joe W.
 *
 *      The aim of the game is to collect all the clear bubbles by
 *      running over them. You control either the dark bubble or
 *      the solid box. The dark bubble is used to collect the clear
 *      bubbles, and the solid box is used as a sort of movable wall.
 *
 *      Both objects carry on moving until they hit something else
 *      (except for the dark bubble in the case of clear bubbles).
 *
 * * * * * * *
 *
 *      The keys are defined in #define statements, and default thus:
 *
 *      Up:     Q
 *      Down:   A
 *      Left:   O
 *      Right:  P
 *      Quit:   G
 *      Retry:  H
 *      Switch: [SPACE]
 *
 *      Switch changes between the dark bubble and the solid box.
 *
 *
 *      On the TI Calculators the keyboard mapping is:
 *
 *      up,down,left,right - move ball/box
 *      [Enter]            - toggle ball/box
 *      7                  - Quit
 *      9                  - Restart level
 *      +,-                - CHEAT....
 *
 * * * * * * *
 *
 *      This is the first game ever produced with the Small C compiler -
 *      it was written as a statement saying that it is possible to
 *      write something easily, quickly and efficiently using the
 *      compiler. Hopefully it will be an encouragement for others to
 *      do likewise!
 *
 * * * * * * *
 *
 *      Compile examples :
 *
 *      To get a TI82 version of the game (optionally you could add sound):
 *      zcc +ti82 -create-app dstar.c
 *   
 *      To get a TI85 version of the game (optionally you could add sound):
 *      zcc +ti85 -Dspritesize=7 -create-app dstar.c
 *   
 *      To get a Spectrum 16K version of the game:
 *      zcc +zx -Dspritesize=16 -DSOUND -create-app -zorg=24300 dstar.c
 *
 *      To get a TS2068 HRG version of the game:
 *      zcc +ts2068 -startup=2 -Dspritesize=21 -DSOUND -create-app dstar.c
 *   
 *      To get a VZ200 version:
 *      zcc +vz -Dspritesize=7 -DSOUND -odztar.vz dstar.c
 *
 *      TIKI1-100
 *      add the following two lines on top of this file:
 *         #pragma output nogfxglobals
 *         char foo [28000]
 *      zcc +cpm -ltiki100 -o dstar.com -Dspritesize=28 dstar.c
 *
 *      MSXDOS:
 *      zcc +msx -Dspritesize=16 -DSOUND -startup=2 dstar.c
 *
 *      MSX:
 *      zcc +msx -Dspritesize=16 -DSOUND -create-app dstar.c
 *
 *      Robotron KC:
 *      zcc +z9001 -Dspritesize=20 -DSOUND -lgfx9001krt -create-app dstar.c
 *      zcc +kc -Dspritesize=20 -create-app dstar.c
 *
 *      Commodore 128:
 *      zcc +c128 -lgfx128hr -create-app -lm -Dspritesize=21 dstar.c
 *
 *      ZX81, various HRG flavours (see also the specific target version):
 *      zcc +zx81 -O3 -clib=mt  -create-app -Dspritesize=15 dstar.c
 *      zcc +zx81 -O3 -clib=g007  -create-app -Dspritesize=16 dstar.c 
 *      zcc +zx81 -O3 -clib=arx -subtype=arx  -create-app -Dspritesize=16 dstar.c
 *      zcc +zx81 -O3 -clib=wrx -subtype=wrx  -create-app -Dspritesize=16 dstar.c
 *
 *      To get an 80 pixel graphics version of the game (Mattel Aquarius, TRS80, etc):
 *      zcc +aquarius -Dspritesize=5 -create-app dstar.c
 *
 *      Even smaller version of the game:
 *      zcc +gal -Dspritesize=4 -create-app dstar.c
 *   
 *      (in the above examples the sprite size can be set to 4,5,6,7,8 or 16 
 *      and sound can optionally be added with some target)
 *
 * * * * * * *
 *
 *      Enough twaddle, enjoy the game and study the source!
 *
 *      d. <djm@jb.man.ac.uk> 1/12/98
 *
 * * * * * * *
 */

#include <stdio.h>
#include <games.h>
#include <stdlib.h>
#include <graphics.h>

#ifdef SOUND
#include <sound.h>
#endif



/* #define spritesize 4   -->  minimalistic, 64x36 pixels  */
/* #define spritesize 5   -->  very low resolutions, 80x45 pixels  */
/* #define spritesize 6   -->  TI mode, 96x54  */
/* #define spritesize 7   -->  TI85/86, VZ200  */
/* #define spritesize 8   -->  128x72 pixels   */
/* #define spritesize 16  -->  Big screen mode 256x144  */
/* #define spritesize 20  -->  Wide screen mode 320x160 */
/* #define spritesize 21  -->  Wide screen mode 512x192 */
/* #define spritesize 28  -->  Extra wide screen mode 1024x256 */

#ifndef spritesize
#define spritesize 6
#endif

/* Single sprite memory usage, including bytes for its size */
#if (spritesize == 15)|(spritesize == 16))
  #define spritemem 34
#endif
#if (spritesize == 20)
  #define spritemem 62
  #define xsize 20
#endif
#if (spritesize == 21)
  #define spritemem 90
  #define xsize 32
#endif
#if (spritesize == 28)
  #define spritemem 226
  #define xsize 64
#endif
#ifndef spritemem
  #define spritemem (spritesize+2)
#endif


#include "dstar.h"
 
void main()
{
	Level = (STARTLEV-1);
	SetupLevel(); /* Display the first level */

	/* Loop keyhandler till you finished the game */
	while (CheckNotFinished())
	  Gamekeys();
}


void Gamekeys(void)
{
	char *charptr;

    /* Set up a pointer to the variable we want to change
     * (either the box or the ball) */
	charptr = PieceIsBall ? &BoxOffset : &BallOffset;

	switch(getk())
	{
		case K_DOWN:
		  MovePiece(charptr,0,+1);
		  break;
		case K_UP:
		  MovePiece(charptr,0,-1);
		  break;
		case K_RIGHT:
		  MovePiece(charptr,+1,0);
		  break;
		case K_LEFT:
		  MovePiece(charptr,-1,0);
		  break;
		case K_SWITCH:
		  PieceIsBall^=1;   /* Toggle ball/box */
		  #ifdef SOUND
		    bit_fx4 (5);
		  #endif
		  while (getk() == K_SWITCH) {}
		  break;
		case K_EXIT:
		  exit(0);
		case K_NEXTLEV:    /* Okay this IS cheating... */
		  if(++Level==MAXLEVEL)
		  { --Level; break; }
		  SetupLevel();
		  break;
		case K_PREVLEV:
		  if(--Level==-1)
		  { ++Level; break; }
		  /* fall thrue */
		case K_CLEAR:
		  #ifdef SOUND
		    bit_fx4 (3);
		  #endif
		  SetupLevel();
	}
}


/* The level is stored 'compressed', taking up 38 bytes a time.
 *      byte 0 - position of ball
 *      byte 1 - position of box
 *      2-37   - Level data
 *
 * Level data is stored as two bits per block, so we have to shift our
 * picked up byte round to get it.
 */
void SetupLevel(void)
{
	int x;
	char *ptr,*ptr2;

	/* Fresh level, so start with the ball */
	PieceIsBall = FALSE;

	ptr2 = Board;                 /* We copy to the Board */
	ptr  = levels + (Level * 38); /*  from the Level data */

    /* First two bytes are the ball and the box position */
	BallOffset = *ptr++;
	BoxOffset  = *ptr++;

    /* Decompress Level into the Board */
	for (x=0; x!=36; x++)
	{
		*ptr2++=((*ptr)>>6)&3;
		*ptr2++=((*ptr)>>4)&3;
		*ptr2++=((*ptr)>>2)&3;
		*ptr2++=( *ptr)    &3;
		ptr++;
	}

    /* Put the ball and box into their Board position */
	*(Board+BallOffset) = BALL;
	*(Board+BoxOffset)  = BOX;

	DrawBoard(); /* Display the clean Board */

#ifdef SOUND
	bit_fx4 (1);
#endif
}


void DrawBoard(void)
{
	int x,y;
	char *ptr;

	ptr = Board;

	clg(); /* clear the screen */

	for (y=0 ; y!=9 ; y++)
	{
		for (x=0 ; x!=16 ; x++)
		{
#if (spritesize > 20)
			putsprite(spr_or,(x*xsize),(y*spritesize),sprites + (spritemem * (*ptr++)));
#else
			putsprite(spr_or,(x*spritesize),(y*spritesize),sprites + (spritemem * (*ptr++)));
#endif
		}
	}
}



/* Check if a Level is (not) finished:
 * There are 144 squares in each Level
 *
 * Note the use of != instead of < or <=
 *  - this is faster to execute on the Z80!
 */
char CheckNotFinished(void)
{
	char *ptr;
	int i;

	ptr = Board;
	for(i=1 ; i!=144 ; i++)
	{
		if(*ptr++ == BUBB) return(TRUE);   /* Are there any bubbles? */
	}
	if(++Level == MAXLEVEL) return(FALSE); /* All levels done?       */

	SetupLevel();                          /* If not => Next Level!  */
	return(TRUE);                          /* And keep scanning keys */
}


/* Check to see if we're running into anything:
 *  - The box stops for everything (exept empty space [= 0])
 *  - The ball stops for everything exept a bubble
 */
char TestNextPosIsStop(char nextpos)
{
	if(!PieceIsBall)
	  if (nextpos==BUBB) return(FALSE);
	return(nextpos);
}


void MovePiece(char *ptr, char plusx, char plusy)
{
	char *locn;
	char temp,temp2;
	int x,y;

	temp  = PieceIsBall + 3;
	temp2 = (plusx + (plusy * 16));

	while(1) /* loop */
	{

		locn = *(ptr) + Board;
		if(TestNextPosIsStop(*(locn+temp2))) return; /* till edge */

		y = (*(ptr) / 16);
#if (spritesize >= 21)
		x = (*(ptr) - (y * 16)) * xsize;
#else
		x = (*(ptr) - (y * 16)) * spritesize;
#endif
		y *= spritesize;
		
		if(*(locn+temp2)==BUBB)
		{
#if (spritesize >= 21)
			putsprite(spr_xor,x+(plusx*xsize),y+(plusy*spritesize),sprites + (spritemem * BUBB));
#else
			putsprite(spr_xor,x+(plusx*spritesize),y+(plusy*spritesize),sprites + (spritemem * BUBB));
#endif

			#ifdef SOUND
			bit_fx2 (5);
			#endif
		}
		
		*(locn+temp2) = *locn;
		*locn = 0;

 		/* remove old */
		putsprite(spr_xor,x,y,sprites + (spritemem * temp));
		/* put new */
#if (spritesize >= 21)
		putsprite(spr_xor,x+(plusx*xsize),y+(plusy*spritesize),sprites + (spritemem * temp));
#else
		putsprite(spr_xor,x+(plusx*spritesize),y+(plusy*spritesize),sprites + (spritemem * temp));
#endif
		
		#ifdef SOUND
		bit_fx2 (2);
		#endif

		(*ptr) += temp2;
	}
}
