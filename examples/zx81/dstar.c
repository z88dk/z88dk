/*
 *  Ported to the ZX81 with a character redefinition board 
 *  by Stefano Bodrato, many ways to redefine characters are 
 *  available, if you can't see the graphics try by pressing the 
 *  number keys to change the I register setting or check if you 
 *  have some switch on your expansion to move.
 * 
 *
 *  Build options:
 * 
 *  Various redefinable characters board
 *  (does something similar exist on the ZX80 or the LAMBDA ?)
 *    zcc +zx81 -create-app dstar.c
 *
 * 	Dk'Tronics without RAM expansion
 *    zcc +zx81 -create-app -DDKTRONICS dstar.c
 *
 * 	LAMBDA 8300 / POWER 3000
 *    zcc +lambda -create-app -DTEXT dstar.c
 *
 * 	Standard Sinclair mode
 *    zcc +zx81 -create-app -DTEXT dstar.c
 *    zcc +zx80 -create-app -DTEXT dstar.c
 * 
 * 	CHROMA81 expansion
 *    zcc +zx81 -create-app -DCHROMA81 dstar.c
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
 *      Switch: M
 *
 *      Switch changes between the dark bubble and the solid box.
 *
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
#include <string.h>

#include <sound.h>


#include "dstar.h"

void main()
{
#ifdef __ZX80__
	gen_tv_field_init(0);
#endif

#ifndef LAMBDA
#ifdef DKTRONICS
	#asm
	ld	a,$2a
	ld	i,a
	#endasm
#else
#ifndef TEXT
	/* Load user defined graphics onto ZX81 set */
	/* Quicksilva position */
	memcpy(0x8400, sprites, 136);
	/* ROM position */
	memcpy(0x1e00, sprites, 136);
	/* Others */
	memcpy(0x2000, sprites, 136);
	memcpy(0x8e00, sprites, 136);
	memcpy(0x9e00, sprites, 136);
	memcpy(0x2e00, sprites, 136);
	/* dk'tronics (quick board test: PEEK 11905 must give 32)*/
	memcpy(0x3000, sprites, 136);
	memcpy(0x3200, sprites, 136);
	#ifdef CHROMA81
		#asm
		ld	a,$20
		ld	i,a
		#endasm
	#else
		#asm
		ld	a,$30
		ld	i,a
		#endasm
	#endif
#endif
#endif
#endif

	/* Interesting way to find the display file address ! */
	/* (we're working in text mode, with redefinded font) */
	display=d_file+1;

#ifdef LAMBDA
	#asm
	ld   a,5	; Cyan border
	call 06E7h
	#endasm
#endif

#ifdef CHROMA81
	display_attr=d_file+1+32768;
	#asm
	ld bc,7FEFh
	ld a,32+16+8+5  ; 8="attribute file" mode, (border 7)
	out (c),a
;	ld	a,$84
;	ld	i,a
	#endasm
#endif

	DrawBoard();
	
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

	switch(fgetc_cons())
	{
#ifndef DKTRONICS
#ifndef __ZX80__
		case '0':
			#asm
			ld	a,$1e
			ld	i,a
			#endasm
			break;
		case '1':
			#asm
			ld	a,$2e
			ld	i,a
			#endasm
			break;
		case '2':
			#asm
			ld	a,$84
			ld	i,a
			#endasm
			break;
		case '3':
			#asm
			ld	a,$8e
			ld	i,a
			#endasm
			break;
		case '4':
			#asm
			ld	a,$9e
			ld	i,a
			#endasm
			break;
		case '5':
			#asm
			ld	a,$30
			ld	i,a
			#endasm
			break;
		case '6':
			#asm
			ld	a,$32
			ld	i,a
			#endasm
			break;
		case '7':
			#asm
			ld	a,$20
			ld	i,a
			#endasm
			break;
#endif
#endif
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
		  //while (getk() == K_SWITCH) {}
		#ifdef __ZX80__
			// make the display 'hop' to notify that we're switching
			gen_tv_field();
		#endif
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
		  break;
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

	/* clear the screen */
	//printf("%c",12);

	for (y=0 ; y!=12 ; y++)
	{
		for (x=0 ; x!=16 ; x++)
		{
			// putsprite(spr_or,(x*spritesize),(y*spritesize),sprites + (spritemem * (*ptr++)));			
			if (y>=9)
				// clear lower portion of screen
				putpic (x,y,0);
			else
				putpic (x,y,(*ptr++));
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
#ifdef __ZX80__
	gen_tv_field();
#endif
	for(i=1 ; i!=144 ; i++)
	{
		if(*ptr++ == BUBB) return(TRUE);   /* Are there any bubbles? */
#ifdef __ZX80__
		if ((i%9)==8)
			gen_tv_field();
#endif
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

#ifdef __ZX80__
		gen_tv_field();
#endif

	while(1) /* loop */
	{
		locn = *(ptr) + Board;
		if(TestNextPosIsStop(*(locn+temp2))) return; /* till edge */

		y = (*(ptr) / 16);		x = (*(ptr) - (y * 16));

/*
		if(*(locn+temp2)==BUBB)
		{
			//putsprite(spr_xor,x+(plusx*spritesize),y+(plusy*spritesize),sprites + (spritemem * BUBB));			
			putpic (x+plusx,y+plusy,BUBB);

			#ifdef SOUND
			bit_fx2 (5);
			#endif
		}
*/
		*(locn+temp2) = *locn;
		*locn = 0;

#ifdef __ZX80__
		gen_tv_field();
#endif
 		/* remove old */
		//putsprite(spr_xor,x,y,sprites + (spritemem * temp));		
		putpic (x,y,0);
		
		/* put new */
		//putsprite(spr_xor,x+(plusx*spritesize),y+(plusy*spritesize),sprites + (spritemem * temp));		
		putpic (x+plusx,y+plusy,temp);

		#ifdef SOUND
		//bit_fx2 (6);
		bit_fx4 (2);
		#endif

		(*ptr) += temp2;
#ifdef __ZX80__
		gen_tv_field();
#endif
	}
}

void putpic(int x, int y, int picture) {
	//putsprite(spr_or,(x*spritesize),(y*spritesize),sprites + (spritemem * (*ptr++)));			
#ifdef DKTRONICS
	#define HAVEPICS
	switch(picture)
	{
/* .. previous choice of pictures, perhaps too 'heavy'
	case WALL:
		display[y*66+x*2]=144;
		display[y*66+x*2+1]=144;
		display[y*66+33+x*2]=144;
		display[y*66+33+x*2+1]=144;
		break;
	case BUBB:
		display[y*66+x*2]=59;
		display[y*66+x*2+1]=58;
		display[y*66+33+x*2]=57;
		display[y*66+33+x*2+1]=56;
		break;
	case BALL:
		display[y*66+x*2]=8;
		display[y*66+x*2+1]=2;
		display[y*66+33+x*2]=6;
		display[y*66+33+x*2+1]=4;
		break;
	case BOX:
		display[y*66+x*2]=43;
		display[y*66+x*2+1]=44;
		display[y*66+33+x*2]=40;
		display[y*66+33+x*2+1]=42;
		break;
*/
	case WALL:
		display[y*66+x*2]=43;
		display[y*66+x*2+1]=44;
		display[y*66+33+x*2]=40;
		display[y*66+33+x*2+1]=42;
		break;
	case BUBB:
		display[y*66+x*2]=59;
		display[y*66+x*2+1]=0;
		display[y*66+33+x*2]=0;
		display[y*66+33+x*2+1]=0;
		break;
	case BALL:
		display[y*66+x*2]=59;
		display[y*66+x*2+1]=58;
		display[y*66+33+x*2]=57;
		display[y*66+33+x*2+1]=56;
		break;
	case BOX:
		display[y*66+x*2]=8;
		display[y*66+x*2+1]=2;
		display[y*66+33+x*2]=6;
		display[y*66+33+x*2+1]=4;
		break;
	case 0:
		display[y*66+x*2]=0;
		display[y*66+x*2+1]=0;
		display[y*66+33+x*2]=0;
		display[y*66+33+x*2+1]=0;
		break;
	}
#endif
#ifdef TEXT
	#define HAVEPICS
#ifdef __ZX80__
	switch(picture)
	{
	case WALL:
		display[y*66+x*2]=61;
		display[y*66+x*2+1]=61;
		display[y*66+33+x*2]=61;
		display[y*66+33+x*2+1]=61;
		break;
	case BUBB:
		display[y*66+x*2]=7;
		display[y*66+x*2+1]=0;
		display[y*66+33+x*2]=0;
		display[y*66+33+x*2+1]=4;
		break;
	case BALL:
		display[y*66+x*2]=132;
		display[y*66+x*2+1]=136;
		display[y*66+33+x*2]=134;
		display[y*66+33+x*2+1]=135;
		break;
	case BOX:
		display[y*66+x*2]=9;
		display[y*66+x*2+1]=137;
		display[y*66+33+x*2]=137;
		display[y*66+33+x*2+1]=9;
		break;
	case 0:
		display[y*66+x*2]=0;
		display[y*66+x*2+1]=0;
		display[y*66+33+x*2]=0;
		display[y*66+33+x*2+1]=0;
		break;
	}
#else
#ifdef LAMBDA
	switch(picture)
	{
	case WALL:
		display[y*66+x*2]=140;
		display[y*66+x*2+1]=140;
		display[y*66+33+x*2]=140;
		display[y*66+33+x*2+1]=140;
		break;
	case BUBB:
		display[y*66+x*2]=137;
		display[y*66+x*2+1]=138;		// 4
		display[y*66+33+x*2]=10;		// 2
		display[y*66+33+x*2+1]=9;	// 1
		break;
	case BALL:
		display[y*66+x*2]=6;
		display[y*66+x*2+1]=130;
		display[y*66+33+x*2]=132;
		display[y*66+33+x*2+1]=7;
		break;
	case BOX:
		display[y*66+x*2]=136;
		display[y*66+x*2+1]=136;
		display[y*66+33+x*2]=136;
		display[y*66+33+x*2+1]=136;
		break;
	case 0:
		display[y*66+x*2]=0;
		display[y*66+x*2+1]=0;
		display[y*66+33+x*2]=0;
		display[y*66+33+x*2+1]=0;
		break;
	}
#else
	switch(picture)
	{
	case WALL:
		display[y*66+x*2]=61;
		display[y*66+x*2+1]=61;
		display[y*66+33+x*2]=61;
		display[y*66+33+x*2+1]=61;
		break;
	case BUBB:
		display[y*66+x*2]=135;
		display[y*66+x*2+1]=0;		// 4
		display[y*66+33+x*2]=0;		// 2
		display[y*66+33+x*2+1]=1;	// 1
		break;
	case BALL:
		display[y*66+x*2]=6;
		display[y*66+x*2+1]=130;
		display[y*66+33+x*2]=132;
		display[y*66+33+x*2+1]=7;
		break;
	case BOX:
		display[y*66+x*2]=8;		// 7
		display[y*66+x*2+1]=136;	// 132
		display[y*66+33+x*2]=136;	// 130
		display[y*66+33+x*2+1]=8;	//129
		break;
	case 0:
		display[y*66+x*2]=0;
		display[y*66+x*2+1]=0;
		display[y*66+33+x*2]=0;
		display[y*66+33+x*2+1]=0;
		break;
	}
#endif
#endif
#endif

#ifndef HAVEPICS
	if (picture == 0) {
		display[y*66+x*2]=0;
		display[y*66+x*2+1]=0;
		display[y*66+33+x*2]=0;
		display[y*66+33+x*2+1]=0;
	} else {
		display[y*66+x*2]=4*picture-3;
		display[y*66+x*2+1]=4*picture-1;
		display[y*66+33+x*2]=4*picture-2;
		display[y*66+33+x*2+1]=4*picture;
	}
#endif

#if defined(CHROMA81) || defined(LAMBDA)
	if (y>8) {
		display_attr[y*66+x*2]=208;
		display_attr[y*66+x*2+1]=208;
		display_attr[y*66+33+x*2]=208;
		display_attr[y*66+33+x*2+1]=208;
	} else {
		display_attr[y*66+x*2]=color[picture];
		display_attr[y*66+x*2+1]=color[picture];
		display_attr[y*66+33+x*2]=color[picture];
		display_attr[y*66+33+x*2+1]=color[picture];
	}
#endif

}

