/*
 *      dstar.c
 *
 *		DStar Z88 - C Demo
 *		Original TI game By A Von Dollen
 *		Converted to Z88 By D Morris
 *		Keys: Q,A,O,P,SPACE,H,G
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
 *      This is the first game ever produced with the Small C compiler -
 *      it was written as a statement saying that it is possible to
 *      write something easily, quickly and efficiently using the
 *      compiler. Hopefully it will be an encouragement for others to
 *      do likewise!
 *
 *      For your interest I've also included the original Z88 converted
 *      assembler from which I worked - it's quite crude but it just
 *      about functions, the C is much more refined!
 *
 *      Enough twaddle, enjoy the game and study the source!
 *
 *      d. <djm@jb.man.ac.uk> 1/12/98
 *
 *      This is the BASIC version of the program, compile with:
 *
 *      zcc -lgfx dstar.c
 */

#include <stdio.h>
#include <games.h>
#include <stdlib.h>
#include <graphics.h>
#include "dstar.h"

void main()
{
	OpenWindow(); /* Open a window (if needed) */

	Level = (STARTLEV-1);
	SetupLevel(); /* Display the first level */

	/* Loop keyhandler till you finished the game */
	while (CheckNotFinished())
	  Gamekeys();

	MyExit();     /* Close the window (if needed) */
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
		  break;
		case K_EXIT:
		  MyExit();
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


/*------------------------------------------------------------------------*/
/*------------------End-of-generic-routines-------------------------------*/
/*------------------------------------------------------------------------*/


#if defined __TI82__ || defined __TI83__ || defined __TI8X__ || defined __TI85__ || defined __TI86__
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
			putsprite(spr_or,(x*6),(y*6),sprites + (8 * (*ptr++)));
		}
	}
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
		x = (*(ptr) - (y * 16)) * 6;
		y *= 6;

		if(*(locn+temp2)==BUBB)
			putsprite(spr_xor,x+(plusx*6),y+(plusy*6),sprites + (8 * BUBB));

		*(locn+temp2) = *locn;
		*locn = 0;

 		/* remove old */
		putsprite(spr_xor,x,y,sprites + (8 * temp));
		/* put new */
		putsprite(spr_xor,x+(plusx*6),y+(plusy*6),sprites + (8 * temp));

		(*ptr) += temp2;
	}
}
#endif


#ifdef __Z88__
/* Define the text window and the graphics window
 * If can't open graphics window then exit gracefully
 */
void OpenWindow(void)
{
	struct window text;
	/* Clear the whole screen */
	puts(baswindres);

	/* Define and open a text window with title and other embellishments
	 * strings are at top for clearing, position etc */
	text->number='3';
	text->x=32+7;
	text->y=32+1;
	text->width=32+34;
	text->depth=32+7;
	text->type=131;
	text->graph=0;
	window(text);
	fputs(windtitle,stdout);
	text->x=32+8;
	text->y=32+3;
	text->width=32+32;
	text->depth=32+5;
	text->type=128;
	window(text);
	fputs(windclr,stdout);
	/* Now, try to open a map window.. */
	graphics->graph=1;
	graphics->width=128;
	graphics->number='4';
	if (window(graphics))
	{
		puts("Sorry, Can't Open Map");
		sleep(5);
		exit(0);
	}
	/* Sucessfully opened, now dump some info in the text window! */
	puts( "       DStar Z88 - C Demo"              );
	fputs("Original TI game By A Von Dollen",stdout);
	puts( "  Converted to Z88 By D Morris"         );
	puts( "    Keys: Q,A,O,P,SPACE,H,G"            );
}


/* Dump a sprite onto the TI screen we've built
 * The TI screen is 16 characters wide by 8 deep i.e. half the size
 * of the Z88's map screen. It's stored line by line (sensible!)
 *
 * We enter with y being y/7 and x being x/8 (if we think in pixels)
 * So for each y we have to step down by 112.
 * The increment between rows is 16.
 */
void puttiblock(char spr,int x, int y)
{
	char *ptr2,*ptr;
	int i;

/* We use this method instead of y*=112 because the compiler has special
 * cases for multiplying by ints less than 16 (except for 11 and 13
 * (Hmmm, I wonder why?!?!)
 */
	y=(y*14)*8;
/* So, get where we want to dump our sprite into ptr */
	ptr=tiscr+y+x;
/* Calculate where the sprite is */
	spr*=8;
	ptr2=sprites+spr;
/* And dump it in there */
	for (i=0; i!=7;i++)
	{
		*ptr=*(ptr2++);
		ptr+=16;
	}
}


void MyExit(void)
{
	closegfx(graphics);     /* Close the Map window */
	puts(baswindres);
	exit(0);                /* Get outta here! */
}


/* Ooops, forgive me this one bit of assembler in the entire program!
 * This just copies the TI screen onto the OZ map.
 *
 * It really is easier to keep this routine in here, change it into
 * C if you like..
 */
void CopyToScreen(void)
{
#asm
	EXTERN  swapgfxbk

	call    swapgfxbk
	call    ozscrcpy
	jp      swapgfxbk

.ozscrcpy
	ld      de,(base_graphics)
	ld      hl,_tiscr
	ld      c,8
.ozscrcpy1
	push    hl
	ld      b,16
.ozscrcpy3
	push    bc
	push      hl
	ld      bc,16
	ld      a,8
.ozscrcpy2
	ex      af,af
	ld      a,(hl)
	ld      (de),a
	inc     de
	add     hl,bc
	ex      af,af
	dec     a
	jr      nz,ozscrcpy2
	pop     hl
	inc     hl
	pop     bc
	djnz    ozscrcpy3
	pop     hl
	push    bc
	ld      bc,16*8
	add     hl,bc
	pop     bc
	dec     c
	jr      nz,ozscrcpy1
	;ret
#endasm
}
#endif


#if __SPECTRUM__
/* Define the text window and the graphics window
 * If can't open graphics window then exit gracefully
 */
void OpenWindow(void)
{
#asm
	ld      hl,16384
	ld      de,16385
	ld      bc,6143
	ld      (hl),0
	ldir
	ld      (hl),56
	ld      bc,767
	ldir
	ld      a,7
	out     (254),a
	ld      a,56
	ld      (23624),a
	ld      a,8
	ld      (23568),a
#endasm
	puts_cons("\x01\x20\x16\x21\x20     DStar Z88 - C Demo");
	puts_cons("Original game By A Von Dollen");
	puts_cons(" Converted to ZX By D Morris");
	puts_cons("  Keys:  Q,A,O,P,SPACE,H,G");
}


/* Ooops, forgive me this one bit of assembler in the entire program!
 * This just copies the TI screen onto the map.
 *
 * It really is easier to keep this routine in here, change it into
 * C if you like..
 */
void CopyToScreen(void)
{
#asm
	ld      de,18432+8
	ld      hl,_tiscr
	ld      c,8*8-1
.zxscrcpy1
	push    de
	ld      b,16
.zxscrcpy2
	ld      a,(hl)
	ld      (de),a
	inc     de
	inc     hl
	djnz    zxscrcpy2
	pop     de
	call    drow
	dec     c
	jr      nz,zxscrcpy1
	ret

.drow
	inc     d
	ld      a,7
	and     d
	ret     nz
	ld      a,e
	add     a,32
	ld      e,a
	ret     c
	ld      a,d
	sub     8
	ld      d,a
	;ret
#endasm
}
#endif
