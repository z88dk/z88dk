/*
 *  D E A T H   S T A R  -  PacMan hardware version
 * 
 * 
 * * * * * * *
 *
 *      dstar.c
 *
 *		DStar Z88 - C Demo
 *		Original TI game By A Von Dollen
 *		Converted to Z88 By D Morris
 *		Game control:  Stick1, Stick2, Coin2(restart)
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

	SetupLevel(); /* Display the first level */

	/* Loop keyhandler till you finished the game */
	while (CheckNotFinished())
	  Gamekeys();
}


void Gamekeys(void)
{

	if (joystick(2) & MOVE_FIRE) {
		SetupLevel();
	}
	
	/* Move Ball */
	PieceIsBall = FALSE;
	if (joystick(1) & MOVE_DOWN)
		MovePiece(&BallOffset,0,+1);
	  
	if (joystick(1) & MOVE_UP)
		MovePiece(&BallOffset,0,-1);
	
	if (joystick(1) & MOVE_RIGHT)
		MovePiece(&BallOffset,+1,0);
	
	if (joystick(1) & MOVE_LEFT)
		MovePiece(&BallOffset,-1,0);

	/* Move Blocker */
	PieceIsBall = TRUE;
	if (joystick(2) & MOVE_DOWN)
		MovePiece(&BoxOffset,0,+1);
	
	if (joystick(2) & MOVE_UP)
		MovePiece(&BoxOffset,0,-1);
	
	if (joystick(2) & MOVE_RIGHT)
		MovePiece(&BoxOffset,+1,0);

	if (joystick(2) & MOVE_LEFT)
		MovePiece(&BoxOffset,-1,0);


	/*
	switch(getk())
	{
		case K_NEXTLEV:    // Okay this IS cheating...
		  if(++Level==MAXLEVEL)
		  { --Level; break; }
		  SetupLevel();
		  break;
		case K_PREVLEV:
		  if(--Level==-1)
		  { ++Level; break; }
		  // fall thru
	} */
	
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
	/* printf("%c",12); */

	for (y=0 ; y!=9 ; y++)
	{
		for (x=0 ; x!=16 ; x++)
		{
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
	int x,y,p;

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
			
			putpic (x+plusx,y+plusy,BUBB);

			#ifdef SOUND
			bit_fx2 (5);
			#endif
		}

		*(locn+temp2) = *locn;
		*locn = 0;

 		/* remove old */
		putpic (x,y,0);
		
		/* put new */
		putpic (x+plusx,y+plusy,temp);
		
		/* for (p=0; p<800; p++); */
		csleep(5);

		#ifdef SOUND
		bit_fx4 (2);
		#endif

		(*ptr) += temp2;
	}
}

/* PacMan 'text' resolution is 29x32 */
void putpic(int x, int y, int picture) {			
	if (picture == 0) {
		display[VRAM_ADDRESS(x,y)]=0x40;
	}
	if (picture == WALL) {
		display[VRAM_ADDRESS(x,y)]=0x58;
		attr[VRAM_ADDRESS(x,y)]=1;
	}
	if (picture == BUBB) {
		display[VRAM_ADDRESS(x,y)]=0x12;
		attr[VRAM_ADDRESS(x,y)]=24;
	}
	if (picture == BALL) {
		display[VRAM_ADDRESS(x,y)]=0x14;
		attr[VRAM_ADDRESS(x,y)]=9;
	}
	if (picture == BOX) {
		display[VRAM_ADDRESS(x,y)]=0x4F;
		attr[VRAM_ADDRESS(x,y)]=9;
	}

}

