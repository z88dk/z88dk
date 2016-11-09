/*
 *  D E A T H   S T A R  -  Microbee version
 * 
 * How to build:
 * zcc +cpm -lmicrobee -create-app -DSOUND -DGRAPHICS -O3 -odstar dstar.c
 *
 * Crap text only variant:
 * zcc +cpm -lmicrobee -create-app -DSOUND -O3 -odstar dstar.c
 * 
 * 
 * *****
 * 
 *  Ported to the Ti82/83/83+ (rest will follow) by Henk Poley
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
int i;

/* Load user defined graphics (reversed) onto character set */	

#ifdef GRAPHICS
	
	for (i=0; i<128*16; i++)
		udg[i]=sprites[i]^0xff;
	#asm
	;ld a,$80
	;out ($1c),a
	
;	jr vdini	
	
;.vdutab		; 64*16
;	defb	107,64,81,55,18,9,16,17,$48,$0F,$2F,$0F,0,0,0,0  
	
;.vdutab		; 40x24
;	defb	$35,40,$2D,$24,$1b,$05,$19,$1a,$48,$0a,$2a,$0a,$20,0,0,0

;.vdutab		; 80x24
;	defb	$6b,80,$58,$37,$1b,$05,$18,$1a,$48,$0a,$2a,$0a,$20,0,0,0

.vdutab		; 80x24 / 80x25 - Peter Broughton
;	defb	$6b,$50,$5b,$37,$1b,$05,$19,$1a,$48,$0a,$2a,$0a,$20,0,0,0
;	defb	$6b,$50,$59,$37,$1b,$05,$19,$1b,$48,$0a,$2a,$0a,$20,0,0,0


;.vdini
	

;	LD	HL,vdutab
;	LD  C,0
;	LD	B,16
;.vdloop
;	LD	A,C
;	OUT	($0C),A
;	LD	A,(HL)
;	OUT	($0D),A
;	INC	HL
;	INC C
;	DJNZ	vdloop

;	LD	HL,vdutab+16
;	LD	B,16
;.vdloop
;	LD	A,B
;	DEC	A
;	OUT	($0C),A
;	LD	A,(HL)
;	OUT	($0D),A
;	DEC	HL
;	DJNZ	vdloop
	
	#endasm

#endif

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
#ifdef GRAPHICS
		#asm
		xor a
		out ($1c),a
		#endasm
#endif
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

	/* clear the screen */
	//printf("%c",12);

	for (y=0 ; y!=9 ; y++)
	{
		for (x=0 ; x!=16 ; x++)
		{
			// putsprite(spr_or,(x*spritesize),(y*spritesize),sprites + (spritemem * (*ptr++)));			
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
/*
		y = (*(ptr) / 16);
		x = (*(ptr) - (y * 16)) * spritesize;
		y *= spritesize;
*/		y = (*(ptr) / 16);		x = (*(ptr) - (y * 16));
		if(*(locn+temp2)==BUBB)
		{
			//putsprite(spr_xor,x+(plusx*spritesize),y+(plusy*spritesize),sprites + (spritemem * BUBB));			
			putpic (x+plusx,y+plusy,BUBB);

			#ifdef SOUND
			bit_fx2 (5);
			#endif
		}

		*(locn+temp2) = *locn;
		*locn = 0;

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
	}
}

// Sorcerer Exidy text resolution is 64x25
void putpic(int x, int y, int picture) {
#ifdef GRAPHICS
	switch (picture) {

	case 0:
		display[y*160+x*5]=128;
		display[y*160+x*5+1]=128;
		display[y*160+x*5+2]=128;
		display[y*160+x*5+3]=128;
		display[y*160+x*5+4]=128;
		display[y*160+80+x*5]=128;
		display[y*160+80+x*5+1]=128;
		display[y*160+80+x*5+2]=128;
		display[y*160+80+x*5+3]=128;
		display[y*160+80+x*5+4]=128;
		break;
		
	// brick
	case 1:
		display[y*160+x*5]=129;
		display[y*160+x*5+1]=130;
		display[y*160+x*5+2]=131;
		display[y*160+x*5+3]=132;
		display[y*160+x*5+4]=133;
		display[y*160+80+x*5]=134;
		display[y*160+80+x*5+1]=135;
		display[y*160+80+x*5+2]=136;
		display[y*160+80+x*5+3]=137;
		display[y*160+80+x*5+4]=138;
		break;
		
	// bubble
	case 2:
		display[y*160+x*5]=139;
		display[y*160+x*5+1]=140;
		display[y*160+x*5+2]=141;
		display[y*160+x*5+3]=142;
		display[y*160+x*5+4]=143;
		display[y*160+80+x*5]=144;
		display[y*160+80+x*5+1]=145;
		display[y*160+80+x*5+2]=146;
		display[y*160+80+x*5+3]=147;
		display[y*160+80+x*5+4]=148;
		break;
		
	// ball
	case 3:
		display[y*160+x*5]=149;
		display[y*160+x*5+1]=150;
		display[y*160+x*5+2]=151;
		display[y*160+x*5+3]=152;
		display[y*160+x*5+4]=153;
		display[y*160+80+x*5]=154;
		display[y*160+80+x*5+1]=155;
		display[y*160+80+x*5+2]=156;
		display[y*160+80+x*5+3]=157;
		display[y*160+80+x*5+4]=158;
		break;
		
	// blocker
	case 4:
		display[y*160+x*5]=159;
		display[y*160+x*5+1]=160;
		display[y*160+x*5+2]=161;
		display[y*160+x*5+3]=162;
		display[y*160+x*5+4]=163;
		display[y*160+80+x*5]=164;
		display[y*160+80+x*5+1]=165;
		display[y*160+80+x*5+2]=166;
		display[y*160+80+x*5+3]=167;
		display[y*160+80+x*5+4]=168;
		break;
	}

#else
	switch (picture) {

	case 0:
		display[y*160+x*5]=' ';
		display[y*160+x*5+1]=' ';
		display[y*160+x*5+2]=' ';
		display[y*160+x*5+3]=' ';
		display[y*160+x*5+4]=' ';
		display[y*160+80+x*5]=' ';
		display[y*160+80+x*5+1]=' ';
		display[y*160+80+x*5+2]=' ';
		display[y*160+80+x*5+3]=' ';
		display[y*160+80+x*5+4]=' ';
		break;
		
	// brick
	case 1:
		display[y*160+x*5]=131;
		display[y*160+x*5+1]=131;
		display[y*160+x*5+2]=131;
		display[y*160+x*5+3]=131;
		display[y*160+x*5+4]=131;
		display[y*160+80+x*5]=131;
		display[y*160+80+x*5+1]=131;
		display[y*160+80+x*5+2]=131;
		display[y*160+80+x*5+3]=131;
		display[y*160+80+x*5+4]=131;
		break;
		
	// bubble
	case 2:
		display[y*160+x*5]=' ';
		display[y*160+x*5+1]='_';
		display[y*160+x*5+2]='-';
		display[y*160+x*5+3]='_';
		display[y*160+x*5+4]=' ';
		display[y*160+80+x*5]=' ';
		display[y*160+80+x*5+1]=' ';
		display[y*160+80+x*5+2]=126;
		display[y*160+80+x*5+3]=' ';
		display[y*160+80+x*5+4]=' ';
		break;
		
	// ball
	case 3:
		display[y*160+x*5]=' ';
		display[y*160+x*5+1]=127;
		display[y*160+x*5+2]=127;
		display[y*160+x*5+3]=127;
		display[y*160+x*5+4]=' ';
		display[y*160+80+x*5]=' ';
		display[y*160+80+x*5+1]=127;
		display[y*160+80+x*5+2]=127;
		display[y*160+80+x*5+3]=127;
		display[y*160+80+x*5+4]=' ';
		break;
		
	// blocker
	case 4:
		display[y*160+x*5]=10;
		display[y*160+x*5+1]=10;
		display[y*160+x*5+2]=10;
		display[y*160+x*5+3]=10;
		display[y*160+x*5+4]=10;
		display[y*160+80+x*5]=10;
		display[y*160+80+x*5+1]=10;
		display[y*160+80+x*5+2]=10;
		display[y*160+80+x*5+3]=10;
		display[y*160+80+x*5+4]=10;
		break;

	}
#endif
}

