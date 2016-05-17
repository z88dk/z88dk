/*
 *      dstar.c
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
 *
 */



/* Call up the required header files */

#include <stdio.h>
#include <stdlib.h>
#include <graphics.h>

/* dstar.h contains the levels and "sprite" data */

#include "dstar.h"



#define NO 0
#define MAXLEVEL 25
#define STARTLEV  0     /* Start level -1 */

/* Block numbers.. */

#define WALL 1  
#define BUBB 2
#define BALL 3
#define BOX 4

/* Key definitions, change these to define your keys! */

#define K_UP 'Q'
#define K_DOWN 'A'
#define K_LEFT 'O'
#define K_RIGHT 'P'
#define K_SWITCH 32
#define K_EXIT  'G'
#define K_CLEAR 'H'


/* Declare some variables to start off with! */


char balloffset;        /* Ball position */
char boxoffset;         /* Box position */
char ballorbox;         /* 1 if box, 0 if ball */
char level;             /* Take a guess! */

char board[144];        /* Level internal map thing */
char tiscr[1024];       /* Our very own TI86 screen! */


/* Some character arrays to handle window functions */

char windtitle[]= {
            1,'7','#','3',32+7,32+1,32+34,32+7,131,   
            1,'2','C','3',1,'4','+','T','U','R',1,'2','J','C',
            1,'3','@',32,32, /*reset to (0,0)*/
            'D','S','t','a','r',' ','z','8','8',
            1,'3','@',32,32 ,1,'2','A',32+34,0   
        };

char baswindres[]= {
                1,'2','H','1',0x0C,0
               };

char windclr[]= {
                1,'2','C','3',
                1,'3','@',32,32,1,'2','+','B',0
                };

/* Used for the map, keep it global so we can close it easily! */

struct window graphics;

/* prototype to stop barfing */

void redrawscreen(void);

main()
{
        redrawscreen();         /* Define the windows */
        playgame();     /* Play the game */
        myexit();       /* Clean up after ourselves */

}

myexit()
{
        closegfx(graphics);     /* Close the Map window */
        puts(baswindres);
        exit(0);                /* Get outta here! */
}


playgame()
{
        setupgame();            /* Set level to 1, get level etc */
/* Loop while checkfinish() says we haven't finished! */

        while ( checkfinish() ) {
                gamekeys();     /* Scan keys */
        }
}


/* Set some variables up at the start.. */

setupgame()
{
        ballorbox=NO;
        level=STARTLEV;
        setuplevel();
}


gamekeys()
{
        char *charptr;

/* Set up a pointer to the variable we want to change (either for
 * box or for ball
 */
        if (ballorbox) charptr=&boxoffset;
        else charptr=&balloffset;

        switch( getk() ) {      /* Use OZ to get the key */
                case K_DOWN:
                        down(charptr);
                        break;
                case K_UP:
                        up(charptr);
                        break;
                case K_RIGHT:
                        right(charptr);
                        break;
                case K_LEFT:
                        left(charptr);
                        break;
                case K_SWITCH:
                        ballorbox^=1;   /* Toggle ball/box */
                        break;
                case K_EXIT:
                        myexit();
                case K_CLEAR:
                        setuplevel();
        }
}


/* Movement functions - all of these are pretty well similar so I
 * will only comment the first one - it's fairly obvious what is
 * happening though
 */

left(char *ptr)
{
        char *locn;

        while(1) {
                locn=*(ptr)+board;
                if (standardmiddle(*(locn-1)) ) return;
                *(locn-1)=*locn;
                *locn=0;
                (*ptr)--;       /* ptr is the location of blob */
                drawboard();    /* Draw screen */
        }
}


right(char *ptr)
{
        char *locn;

        while(1) {
                locn=*(ptr)+board;
                if (standardmiddle(*(locn+1)) ) return;
                *(locn+1)=*locn;
                *locn=0;
                (*ptr)++;
                drawboard();
        }
}

down(char *ptr)
{
        char *locn;

        while(1) {
                locn=*(ptr)+board;
                if (standardmiddle(*(locn+16)) ) return;
                *(locn+16)=*locn;
                *locn=0;
                (*ptr)+=16;
                drawboard();
        }
}

up(char *ptr)
{
        char *locn;

        while(1) {
                locn=*(ptr)+board;
                if ( standardmiddle(*(locn-16)) ) return;
                *(locn-16)=*locn;
                *locn=0;
                (*ptr)-=16;
                drawboard();
        }
}


/* Check to see if we're running into anything, if box is set then
 * if we hit anything we want to stop, if we're ball then if we
 * hit anything except for bubble we wanna stop
 */

standardmiddle(char nextpos)
{
        if (ballorbox)
                return (nextpos);       /* For box */
        else
                if (nextpos==BUBB || nextpos==NO) return(0);
        return(1);
}



/* Check to see if a level is finished
 * There are 144 squares in each level, note the use of != instead of
 * </<= - this is quicker to execute on the Z80!
 */

checkfinish()
{
        char *ptr;
        int i;
        ptr=board;
        for (i=1; i!=144; i++) {
                if (*ptr++ == BUBB) return(1);
        }
        if ( ++level==MAXLEVEL ) return(0);     /* Done all the levels!! */
        setuplevel();
        return(1);
}

/* Setup a level..the level is stored compressed, taking up 38 bytes a
 * time.
 *      byte 0 - position of ball
 *      byte 1 - position of box
 *      2-37   - level data
 *
 * Level data is stored as two bits per square, so we have to shift our
 * picked up byte round to get it
 */

setuplevel()
{
        int y,x;
        char *ptr,*ptr2;
        ptr2=board;
        ptr=levels+(level*38);
/* ptr points to start of level now */
/* First two bytes are the ball and the boxes position */
        balloffset=*ptr++;
        boxoffset=*ptr++;

/* Now, decompress level into board */
        for (y=0; y!=9; y++) {
                for (x=0; x !=4; x++) {
                        *ptr2++=((*ptr)>>6)&3;
                        *ptr2++=((*ptr)>>4)&3;
                        *ptr2++=((*ptr)>>2)&3;
                        *ptr2++=(*ptr)&3;
                        ptr++;
                }
        }
/* Now, plot the ball and box into the internal map */
        ptr2=board;
        *(ptr2+balloffset)=BALL;
        *(ptr2+boxoffset)=BOX;
        drawboard();
}



/* Define the text window and the graphics window
 * If can't open graphics window then exit gracefully
 */

void redrawscreen(void)
{
        struct window text;
/*
 * Clear the whole screen
 */
        puts(baswindres);
/* Define and open a text window with title and other embellishments
 * strings are at top for clearing, position etc
 */
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
        if (window(graphics)) {
                puts("Sorry, Can't Open Map");
                sleep(5);
                exit(0);
        }
/* Sucessfully opened, now dump some info in the text window! */
        puts("       DStar Z88 - C Demo");
        fputs("Original TI game By A Von Dollen",stdout);
        puts("  Converted to Z88 By D Morris");
        puts("    Keys: Q,A,O,P,SPACE,H,G");
}

/* Draw the board, mostly written in C, even though we did take a bit
 * of a performance hit when it was converted over from asm
 */

drawboard()
{
        int x,y;
        char *ptr;

/* We let OZ in here, because we only go back to the loop once our
 * thing has hit something
 */
        getk();

        ptr=board;

        for (y=0;y!=9;y++) {
                for (x=0;x!=16;x++) {
                        puttiblock((*ptr++),x,y);
                }
        }
        doozcopyasm();
}


/* Dump a sprite onto the TI screen we've built
 * The TI screen is 16 characters wide by 8 deep i.e. half the size
 * of the Z88's map screen. It's stored line by line (sensible!)
 *
 * We enter with y being y/7 and x being x/8 (if we think in pixels)
 * So for each y we have to step down by 112.
 * The increment between rows is 16.
 */
 


puttiblock(char spr,int x, int y)
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
        for (i=0; i!=7;i++) {
                *ptr=*(ptr2++);
                ptr+=16;
        }
}

/* Ooops, forgive me this one bit of assembler in the entire program!
 * This just copies the TI screen onto the OZ map.
 *
 * It really is easier to keep this routine in here, change it into
 * C if you like..
 */


doozcopyasm()
{
#asm

        EXTERN	swapgfxbk

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
        push    hl
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
/* Every function always has a ret at the end! So don't need one of
 * our own!!
 */
#endasm
}


/* THE END! */
