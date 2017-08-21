/*

        Micro-Man, a multi platform game written for Z88DK
        By Stefano Bodrato, Summer 2007


        How to compile
        ==============
        
        SOUND is optional, the game board size can be set with the
        "COMPACT" global variable (values 1 to 4).

        Sprite size can be 6 or 8 (value of 10 is experimental).

        Examples follow...


        ZX Spectrum
        -----------
        zcc +zx -lndos -create-app -omicroman -DSOUND -DJOYSTICK_DIALOG microman.c


        ZX81 (high resolution mode)
        --------------------------------
        WRX, SMOOTH, FAST and very compact (16K):
        zcc +zx81 -subtype=wrx64 -clib=wrx64 -DSIZE=6 -DCOMPACT=3 -create-app -omicroman -DZX81LOMEM microman.c
        WRX, FAST and compact mode (16K):
        zcc +zx81 -subtype=wrx64 -clib=wrx64 -DSIZE=6 -DCOMPACT=2 -create-app -omicroman -DZX81LOMEM -O3 microman.c
		As above, ARX mode
        zcc +zx81 -subtype=arx64 -clib=arx64 -DSIZE=6 -DCOMPACT=2 -create-app -omicroman -DZX81LOMEM -O3 microman.c
		As above, Memotech HRG (you may like to uncomment also "mt_hrg_off")
		zcc +zx81 -clib=mt64 -DSIZE=6 -DCOMPACT=2 -create-app  -DZX81LOMEM microman.c
        Full board mode (SLOW):
        zcc +zx81 -subtype=wrx192 -clib=wrx192 -startup=3 -DSIZE=8 -create-app -omicroman microman.c


        Mattel aquarius
        ---------------
        zcc +aquarius -lndos -create-app -DSOUND -DSIZE=6 -DCOMPACT=3 -DJOYSTICK_DIALOG -omicroman microman.c


        $Id: microman.c,v 1.6 2015-01-22 11:13:35 stefano Exp $

*/


#include <graphics.h>
#include <games.h>
#include <stdio.h>
#include <sound.h>
#include <stdlib.h>

// Declare GFX bitmap location for the expanded ZX81
#ifndef ZX81LOMEM
#pragma output hrgpage = 36096
#endif

// Set this one to display a dialog form for the Joystick choices
//#define JOYSTICK_DIALOG 1

// Set it to '1' or '2' to reduce the game board, '3' to cut away "score" and "lives"
//#define COMPACT 2

//#define SOUND 1

#define MAXLIVES 3
#define GHOSTS   4

#ifndef SIZE
  #define SIZE 8
#endif


#ifndef COMPACT
  #define BOARD_ROWS 22
  #if SIZE==6
    #define MAXDOTS 185
  #else
    #define MAXDOTS 186
  #endif
#elif COMPACT==1
  #define BOARD_ROWS 18
  #if SIZE==6
    #define MAXDOTS 146
  #else
    #define MAXDOTS 147
  #endif
#elif (COMPACT==2 || COMPACT==3)
  #define BOARD_ROWS 16
  #if SIZE==6
    #define MAXDOTS 125
  #else
    #define MAXDOTS 126
  #endif
#elif COMPACT==4
  #define BOARD_ROWS 14
  #define MAXDOTS 104
#endif


// Sort of explosion (when man is caught)
char deadman[] = { 6, 6, 0x28 , 0xA0 , 0x0C , 0xC0 , 0x14 , 0x50  };


// Sprites for numbers (but the smallest mode)

char blank[] = {4,5,0xf0,0xf0,0xf0,0xf0,0xf0};

#if SIZE!=6
char numbers[] = { 
        4,5,
        0x70,0x90,0,0x90,0xE0,
        4,5,
        0x20,0x20,0,0x40,0x40,
        4,5,
        0x70,0x10,0x60,0x80,0xE0,
        4,5,
        0x70,0x10,0x60,0x10,0xE0,
        4,5,
        0x90,0x90,0x60,0x10,0x10,
        4,5,
        0x70,0x80,0x60,0x10,0xE0,
        4,5,
        0x70,0x80,0x60,0x90,0xE0,
        4,5,
        0x70,0x90,0,0x20,0x20,
        4,5,
        0x70,0x90,0x60,0x90,0xE0,
        4,5,
        0x70,0x90,0x60,0x10,0xE0
};
#endif

// "Game Over" message

char gameover[] = { 
  48, 5,
  0x71 , 0xC8 , 0xBC , 0x1C , 0x8B , 0xDE , 0x82 , 0x2D , 0xA0 , 0x22 , 0x8A,
  0x11 , 0x9B , 0xEA , 0xB0 , 0x22 , 0x53 , 0x1E , 0x8A , 0x28 , 0xA0 , 0x22,
  0x52 , 0x11 , 0x72 , 0x28 , 0xBC , 0x1C , 0x23 , 0xD1  };


/**************************************/
/**************************************/
/******  SIZE 6 Graph definitions *****/
#if SIZE==6

#define SIZE2 4
#define SIZE3 8
#define MPSIZE 6
#define MPMARGIN 0

#define DOTROW   4
#define BLANKROW 0
#define PILL  14

char numbers[] = {
        3, 5, 0xE0 , 0xA0 , 0xA0 , 0xA0 , 0xE0,
        3, 5, 0x40 , 0x40 , 0x40 , 0x40 , 0x40,
        3, 5, 0xE0 , 0x20 , 0xE0 , 0x80 , 0xE0,
        3, 5, 0xE0 , 0x20 , 0xE0 , 0x20 , 0xE0,
        3, 5, 0xA0 , 0xA0 , 0xE0 , 0x20 , 0x20,
        3, 5, 0xE0 , 0x80 , 0xE0 , 0x20 , 0xE0,
        3, 5, 0xE0 , 0x80 , 0xE0 , 0xA0 , 0xE0,
        3, 5, 0xE0 , 0x20 , 0x20 , 0x20 , 0x20,
        3, 5, 0xE0 , 0xA0 , 0xE0 , 0xA0 , 0xE0,
        3, 5, 0xE0 , 0xA0 , 0xE0 , 0x20 , 0xE0 };

char bar[] = { 
// 1 - Half-cross down
        4, 4, 0x00 , 0xFC , 0xFC , 0x30,
// 2 - Horiz. bar
        4, 4, 0x00 , 0xFC , 0xFC , 0x00,
// 3 - Half-cross up
        4, 4, 0x30 , 0xFC , 0xFC , 0x00,

// 4 - top termination
        4, 4, 0x30 , 0x30 , 0x30 , 0x00,
// 5 - vert. bar
        4, 4, 0x30 , 0x30 , 0x30 , 0x30,
// 6 - bottom termination
        4, 4, 0x00 , 0x30 , 0x30 , 0x30,

// 7 - cross
        4, 4, 0x30 , 0xFC , 0xFC , 0x30,

// 8 - left temination
        4, 4, 0x00 , 0x3C , 0x3C , 0x00,
// 9 - right termination
        4, 4, 0x00 , 0xF0 , 0xF0 , 0x00,
// A - Half-cross to right
        4, 4, 0x30 , 0x3C , 0x3C , 0x30,
// B - Half-cross to left
        4, 4, 0x30 , 0xF0 , 0xF0 , 0x30,
// C - top-left corner
        4, 4, 0x00 , 0x3C , 0x3C , 0x30,
// D - top-right corner
        4, 4, 0x00 , 0xF0 , 0xF0 , 0x30,
// E - bottom-left corner
        4, 4, 0x30 , 0x3C , 0x3C , 0x00,
// F - bottom-right corner
        4, 4, 0x30 , 0xF0 , 0xF0 , 0x00
};

char pill[] = { 6, 6, 0, 0x38, 0x38, 0x38, 0, 0};

char man_right[] = {
        6, 6, 0x30 , 0x48 , 0x84 , 0x9C , 0x48 , 0x30,
        6, 6, 0x30 , 0x48 , 0x8C , 0x90 , 0x48 , 0x30,
        6, 6, 0x30 , 0x48 , 0x98 , 0x90 , 0x48 , 0x30,
        6, 6, 0x30 , 0x48 , 0x90 , 0x90 , 0x48 , 0x30 };
char man_left[] =  {
        6, 6, 0x30 , 0x48 , 0x84 , 0xE4 , 0x48 , 0x30,
        6, 6, 0x30 , 0x48 , 0xC4 , 0x24 , 0x48 , 0x30,
        6, 6, 0x30 , 0x48 , 0x64 , 0x24 , 0x48 , 0x30,
        6, 6, 0x30 , 0x48 , 0x24 , 0x24 , 0x48 , 0x30 };
char man_up[] =    {
        6, 6, 0x30 , 0x58 , 0x94 , 0x84 , 0x48 , 0x30,
        6, 6, 0x20 , 0x68 , 0x94 , 0x84 , 0x48 , 0x30,
        6, 6, 0x00 , 0x68 , 0xB4 , 0x84 , 0x48 , 0x30,
        6, 6, 0x00 , 0x48 , 0xB4 , 0x84 , 0x48 , 0x30 };
char man_down[] =  { 
        6, 6, 0x30 , 0x48 , 0x84 , 0x94 , 0x58 , 0x30,
        6, 6, 0x30 , 0x48 , 0x84 , 0x94 , 0x68 , 0x20,
        6, 6, 0x30 , 0x48 , 0x84 , 0xB4 , 0x68 , 0x00,
        6, 6, 0x30 , 0x48 , 0x84 , 0xB4 , 0x48 , 0x00 };


#define G_RIGHT 0
#define G_LEFT 16
#define G_UPDOWN 32

// White Ghost

char wgh[] = {
  //right
  6, 6, 0x78 , 0x84 , 0xCC , 0x84 , 0xFC , 0x54,
  6, 6, 0x78 , 0x84 , 0xAC , 0x84 , 0xFC , 0xA8,
  //left
  6, 6, 0x78 , 0x84 , 0xD4 , 0x84 , 0xFC , 0xA8,
  6, 6, 0x78 , 0x84 , 0xD4 , 0x84 , 0xFC , 0x54,
  //up-down
  6, 6, 0x78 , 0x84 , 0xD4 , 0x84 , 0xFC , 0x54,
  6, 6, 0x78 , 0x84 , 0xAC , 0x84 , 0xFC , 0xA8  };
  
// Black Ghost
char bgh[] = {
  //right
  6, 6, 0x78 , 0xFC , 0xD4 , 0xFC , 0xFC , 0x54,
  6, 6, 0x78 , 0xFC , 0xD4 , 0xFC , 0xFC , 0xA8,
  //left
  6, 6, 0x78 , 0xFC , 0xAC , 0xFC , 0xFC , 0xA8,
  6, 6, 0x78 , 0xFC , 0xAC , 0xFC , 0xFC , 0x54,
  //up-down
  6, 6, 0x78 , 0xFC , 0xAC , 0xFC , 0xFC , 0x54,
  6, 6, 0x78 , 0xFC , 0xD4 , 0xFC , 0xFC , 0xA8  };

#endif
/****** end of SIZE 6 Graph definitions *****/
/********************************************/
/********************************************/


/**************************************/
/**************************************/
/******  SIZE 8 Graph definitions *****/
#if SIZE==8

#define SIZE2 6
#define SIZE3 10
#define MPSIZE 10
#define MPMARGIN 1

#define DOTROW   16
#define BLANKROW 0
#define PILL  56

char bar[] = { 
// 1 - Half-cross down
        6, 6, 0x00 , 0x00 , 0xFC , 0xFC , 0x30 , 0x30,
// 2 - Horiz. bar
        6, 6, 0x00 , 0x00 , 0xFC , 0xFC , 0x00 , 0x00,
// 3 - Half-cross up
        6, 6, 0x30 , 0x30 , 0xFC , 0xFC , 0x00 , 0x00,

// 4 - top termination
        6, 6, 0x30 , 0x30 , 0x30 , 0x30 , 0x00 , 0x00,
// 5 - vert. bar
        6, 6, 0x30 , 0x30 , 0x30 , 0x30 , 0x30 , 0x30,
// 6 - bottom termination
        6, 6, 0x00 , 0x00 , 0x30 , 0x30 , 0x30 , 0x30,

// 7 - cross
        6, 6, 0x30 , 0x30 , 0xFC , 0xFC , 0x30 , 0x30,

// 8 - left temination
        6, 6, 0x00 , 0x00 , 0x3C , 0x3C , 0x00 , 0x00,
// 9 - right termination
        6, 6, 0x00 , 0x00 , 0xF0 , 0xF0 , 0x00 , 0x00,
// A - Half-cross to right
        6, 6, 0x30 , 0x30 , 0x3C , 0x3C , 0x30 , 0x30,
// B - Half-cross to left
        6, 6, 0x30 , 0x30 , 0xF0 , 0xF0 , 0x30 , 0x30,
// C - top-left corner
        6, 6, 0x00 , 0x00 , 0x3C , 0x3C , 0x30 , 0x30,
// D - top-right corner
        6, 6, 0x00 , 0x00 , 0xF0 , 0xF0 , 0x30 , 0x30,
// E - bottom-left corner
        6, 6, 0x30 , 0x30 , 0x3C , 0x3C , 0x00 , 0x00,
// F - bottom-right corner
        6, 6, 0x30 , 0x30 , 0xF0 , 0xF0 , 0x00 , 0x00
};

char pill[] = { 8, 8, 0, 0, 0x38, 0x38, 0x38, 0, 0, 0 };

char man_right[] = { 8, 8, 0x3C , 0x42 , 0x89 , 0x81 , 0x8F , 0x81 , 0x42 , 0x3C,
                     8, 8, 0x3C , 0x42 , 0x89 , 0x82 , 0x8C , 0x83 , 0x42 , 0x3C,
                     8, 8, 0x3C , 0x42 , 0x92 , 0x84 , 0x88 , 0x84 , 0x42 , 0x3C,
                     8, 8, 0x3C , 0x42 , 0x94 , 0x88 , 0x88 , 0x84 , 0x42 , 0x3C  };
char man_left[] =  { 8, 8, 0x3C , 0x42 , 0x91 , 0x81 , 0xF1 , 0x81 , 0x42 , 0x3C,
                     8, 8, 0x3C , 0x42 , 0x91 , 0x41 , 0x31 , 0xC1 , 0x42 , 0x3C,
                     8, 8, 0x3C , 0x42 , 0x49 , 0x21 , 0x11 , 0x21 , 0x42 , 0x3C,
                     8, 8, 0x3C , 0x42 , 0x29 , 0x11 , 0x11 , 0x21 , 0x42 , 0x3C  };
char man_up[] =    { 8, 8, 0x3C , 0x4A , 0x89 , 0xA9 , 0x81 , 0x81 , 0x42 , 0x3C,
                     8, 8, 0x24 , 0x56 , 0x89 , 0xA9 , 0x81 , 0x81 , 0x42 , 0x3C,
                     8, 8, 0x00 , 0x62 , 0x95 , 0x89 , 0xA1 , 0x81 , 0x42 , 0x3C,
                     8, 8, 0x00 , 0x42 , 0xA5 , 0x99 , 0xA1 , 0x81 , 0x42 , 0x3C  };
char man_down[] =  { 8, 8, 0x3C , 0x42 , 0x81 , 0x81 , 0xA9 , 0x89 , 0x4A , 0x3C,
                     8, 8, 0x3C , 0x42 , 0x81 , 0x81 , 0xA9 , 0x89 , 0x56 , 0x24,
                     8, 8, 0x3C , 0x42 , 0x81 , 0xA1 , 0x89 , 0x95 , 0x62 , 0x00,
                     8, 8, 0x3C , 0x42 , 0x81 , 0xA1 , 0x99 , 0xA5 , 0x42 , 0x00  };

#define G_RIGHT 0
#define G_LEFT 20
#define G_UPDOWN 40

// White Ghost
char wgh[] = {
  //right
  8, 8, 0x3C , 0x42 , 0x95 , 0x81 , 0x81 , 0xA5 , 0xDB , 0x49,
  8, 8, 0x3C , 0x42 , 0x95 , 0x81 , 0x81 , 0xA5 , 0xDB , 0x92,
  //left
  8, 8, 0x3C , 0x42 , 0xA9 , 0x81 , 0x81 , 0xA5 , 0xDB , 0x92,
  8, 8, 0x3C , 0x42 , 0xA9 , 0x81 , 0x81 , 0xA5 , 0xDB , 0x49,
  //up-down
  8, 8, 0x3C , 0x42 , 0x81 , 0xA9 , 0x81 , 0xA5 , 0xDB , 0x92,
  8, 8, 0x3C , 0x42 , 0x95 , 0x81 , 0x81 , 0xA5 , 0xDB , 0x49  };
  
// Black Ghost
char bgh[] = {
  //right
  8, 8, 0x3C , 0x7E , 0xEB , 0xFF , 0xFF , 0xFF , 0xDB , 0x49,
  8, 8, 0x3C , 0x7E , 0xEB , 0xFF , 0xFF , 0xFF , 0xDB , 0x92,
  //left
  8, 8, 0x3C , 0x7E , 0xD7 , 0xFF , 0xFF , 0xFF , 0xDB , 0x92,
  8, 8, 0x3C , 0x7E , 0xD7 , 0xFF , 0xFF , 0xFF , 0xDB , 0x49,
  //up-down
  8, 8, 0x3C , 0x7E , 0xFF , 0xD7 , 0xFF , 0xFF , 0xDB , 0x92,
  8, 8, 0x3C , 0x7E , 0xEB , 0xFF , 0xFF , 0xFF , 0xDB , 0x49  };

#endif
/******  end of SIZE 8 Graph definitions *****/
/*********************************************/
/*********************************************/



/************************************************************/
/************************************************************/
/******   SIZE 10 (Sprites are 14) Graph definitions    *****/

#if SIZE==10

#define SIZE2 8
#define SIZE3 26
#define MPSIZE 14
#define MPMARGIN 1

#define DOTROW   64
#define BLANKROW 0
#define PILL  14


char man_right[] = { 
  12, 12, 
  0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x42 , 0x20 , 0x83 , 0x10 , 0x80 , 0x10 ,
  0x80 , 0x10 , 0x87 , 0xF0 , 0x40 , 0x20 , 0x40 , 0x20 , 0x30 , 0xC0 , 0x0F , 0x00 ,
  12, 12,
  0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x42 , 0x20 , 0x83 , 0x10 , 0x80 , 0x70 ,
  0x81 , 0x80 , 0x86 , 0x00 , 0x41 , 0xE0 , 0x40 , 0x20 , 0x30 , 0xC0 , 0x0F , 0x00 ,
  12, 12, 
  0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x44 , 0x20 , 0x86 , 0x40 , 0x81 , 0x80 ,
  0x82 , 0x00 , 0x84 , 0x00 , 0x43 , 0x80 , 0x40 , 0x60 , 0x30 , 0xC0 , 0x0F , 0x00 ,
  12, 12, 
  0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x60 , 0x48 , 0x80 , 0x8D , 0x00 , 0x82 , 0x00 ,
  0x84 , 0x00 , 0x84 , 0x00 , 0x42 , 0x00 , 0x41 , 0x00 , 0x30 , 0xC0 , 0x0F , 0x00  
  };

char man_left[] = { 
  12, 12, 
  0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x44 , 0x20 , 0x8C , 0x10 , 0x80 , 0x10 ,
  0x80 , 0x10 , 0xFE , 0x10 , 0x40 , 0x20 , 0x40 , 0x20 , 0x30 , 0xC0 , 0x0F , 0x00 ,
  12, 12, 
  0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x44 , 0x20 , 0x8C , 0x10 , 0xE0 , 0x10 ,
  0x18 , 0x10 , 0x06 , 0x10 , 0x78 , 0x20 , 0x40 , 0x20 , 0x30 , 0xC0 , 0x0F , 0x00 ,
  12, 12, 
  0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x42 , 0x20 , 0x26 , 0x10 , 0x18 , 0x10 ,
  0x04 , 0x10 , 0x02 , 0x10 , 0x1C , 0x20 , 0x60 , 0x20 , 0x30 , 0xC0 , 0x0F , 0x00 ,
  12, 12, 
  0x0F , 0x00 , 0x30 , 0xC0 , 0x60 , 0x20 , 0x11 , 0x20 , 0x0B , 0x10 , 0x04 , 0x10 ,
  0x02 , 0x10 , 0x02 , 0x10 , 0x04 , 0x20 , 0x08 , 0x20 , 0x30 , 0xC0 , 0x0F , 0x00  
  };

char man_up[] = { 
  12, 12, 
  0x0F , 0x00 , 0x31 , 0xC0 , 0x41 , 0x20 , 0x41 , 0x20 , 0x89 , 0x10 , 0x99 , 0x10 ,
  0x81 , 0x10 , 0x80 , 0x10 , 0x40 , 0x20 , 0x40 , 0x20 , 0x30 , 0xC0 , 0x0F , 0x00 ,
  12, 12, 
  0x0C , 0x00 , 0x34 , 0xC0 , 0x44 , 0xA0 , 0x42 , 0xA0 , 0x8A , 0x90 , 0x99 , 0x10 ,
  0x81 , 0x10 , 0x80 , 0x10 , 0x40 , 0x20 , 0x40 , 0x20 , 0x30 , 0xC0 , 0x0F , 0x00 ,
  12, 12, 
  0x00 , 0x00 , 0x30 , 0x40 , 0x48 , 0x60 , 0x44 , 0xA0 , 0x84 , 0x90 , 0x8A , 0x90 ,
  0x99 , 0x10 , 0x80 , 0x10 , 0x40 , 0x20 , 0x40 , 0x20 , 0x30 , 0xC0 , 0x0F , 0x00 ,
  12, 12,
  0x00 , 0x00 , 0x20 , 0x00 , 0x60 , 0x20 , 0x50 , 0x20 , 0x88 , 0x50 , 0x84 , 0x90 ,
  0x8B , 0x10 , 0x98 , 0x10 , 0x40 , 0x20 , 0x40 , 0x20 , 0x30 , 0xC0 , 0x0F , 0x00 
  };

char man_down[] = { 
  12, 12, 
  0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x40 , 0x20 , 0x80 , 0x10 , 0x88 , 0x10 ,
  0x89 , 0x90 , 0x89 , 0x10 , 0x48 , 0x20 , 0x48 , 0x20 , 0x38 , 0xC0 , 0x0F , 0x00 ,
  12, 12, 
  0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x40 , 0x20 , 0x80 , 0x10 , 0x88 , 0x10 ,
  0x89 , 0x90 , 0x95 , 0x10 , 0x54 , 0x20 , 0x52 , 0x20 , 0x32 , 0xC0 , 0x03 , 0x00 ,
  12, 12, 
  0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x40 , 0x20 , 0x80 , 0x10 , 0x89 , 0x90 ,
  0x95 , 0x10 , 0x92 , 0x10 , 0x52 , 0x20 , 0x61 , 0x20 , 0x20 , 0xC0 , 0x00 , 0x00 ,
  12, 12, 
  0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x40 , 0x20 , 0x81 , 0x90 , 0x8D , 0x10 ,
  0x92 , 0x10 , 0xA1 , 0x10 , 0x40 , 0xA0 , 0x40 , 0x60 , 0x00 , 0x40 , 0x00 , 0x00  };


char bar[] = { 
// 1 - Half-cross down
        8, 8, 0x00, 0x00 , 0x00 , 0xFF , 0xFF , 0x0c , 0x0c, 0x0c,
// 2 - Horiz. bar
        8, 8, 0x00, 0x00 , 0x00 , 0xFF , 0xFF , 0x00 , 0x00, 0x00,
// 3 - Half-cross up
        8, 8, 0x0c, 0x0c , 0x0c , 0xFF , 0xFF , 0x00 , 0x00, 0x00,

// 4 - top termination
        8, 8, 0x0c, 0x0c , 0x0c , 0x0c , 0x0c , 0x00 , 0x00, 0x00,
// 5 - vert. bar
        8, 8, 0x0c, 0x0c , 0x0c , 0x0c , 0x0c , 0x0c , 0x0c, 0x0c,
// 6 - bottom termination
        8, 8, 0x00, 0x00 , 0x00 , 0x0c , 0x0c , 0x0c , 0x0c, 0x0c,

// 7 - cross
        8, 8, 0x0c, 0x0c , 0x0c , 0xFF , 0xFF , 0x0c , 0x0c, 0x0c,

// 8 - left temination
        8, 8, 0x00, 0x00 , 0x00 , 0x0F , 0x0F , 0x00 , 0x00, 0x00,
// 9 - right termination
        8, 8, 0x00, 0x00 , 0x00 , 0xFC, 0xFC, 0x00 , 0x00, 0x00,
// A - Half-cross to right
        8, 8, 0x0c, 0x0c , 0x0c , 0x0F , 0x0F , 0x0c , 0x0c, 0x0c,
// B - Half-cross to left
        8, 8, 0x0c, 0x0c , 0x0c , 0xFC , 0xFC , 0x0c , 0x0c, 0x0c,
// C - top-left corner
        8, 8, 0x00, 0x00 , 0x00 , 0x0F , 0x0F , 0x0c , 0x0c, 0x0c,
// D - top-right corner
        8, 8, 0x00, 0x00 , 0x00 , 0xFC , 0xFC , 0x0C , 0x0C, 0x0C,
// E - bottom-left corner
        8, 8, 0x0C, 0x0C , 0x0C , 0x0F , 0x0F , 0x00 , 0x00, 0x00,
// F - bottom-right corner
        8, 8, 0x0C, 0x0C , 0x0C , 0xFC , 0xFC , 0x00 , 0x00, 0x00,
};

#define G_RIGHT 0
#define G_LEFT 26
#define G_UPDOWN 52

char wgh[] = { 
  //right
12, 12, 0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x40 , 0x20 , 0x88 , 0x90 , 0x99 , 0x90 , 0x80 , 0x10 , 0x80 , 0x10 , 0x80 , 0x10 , 0xB6 , 0xD0 , 0xDB , 0x60 , 0x92 , 0x40,
12, 12, 0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x40 , 0x20 , 0x88 , 0x90 , 0x99 , 0x90 , 0x80 , 0x10 , 0x80 , 0x10 , 0x80 , 0x10 , 0xED , 0xA0 , 0xB6 , 0xC0 , 0xA4 , 0x80,
  //left
12, 12, 0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x40 , 0x20 , 0x91 , 0x10 , 0x99 , 0x90 , 0x80 , 0x10 , 0x80 , 0x10 , 0x80 , 0x10 , 0xB6 , 0xD0 , 0x6D , 0xB0 , 0x24 , 0x90,
12, 12, 0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x40 , 0x20 , 0x91 , 0x10 , 0x99 , 0x90 , 0x80 , 0x10 , 0x80 , 0x10 , 0x80 , 0x10 , 0x5B , 0x70 , 0x36 , 0xD0 , 0x12 , 0x50,
  //up_down
12, 12, 0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x40 , 0x20 , 0x88 , 0x90 , 0x99 , 0x90 , 0x80 , 0x10 , 0x80 , 0x10 , 0x80 , 0x10 , 0xED , 0xB0 , 0xB6 , 0xD0 , 0x24 , 0x90,
12, 12, 0x0F , 0x00 , 0x30 , 0xC0 , 0x40 , 0x20 , 0x40 , 0x20 , 0x91 , 0x10 , 0x99 , 0x90 , 0x80 , 0x10 , 0x80 , 0x10 , 0x80 , 0x10 , 0xDB , 0x70 , 0xB6 , 0xD0 , 0x92 , 0x40  };


char bgh[] = { 
  //right
12, 12, 0x0F , 0x00 , 0x3F , 0xC0 , 0x7F , 0xE0 , 0x7F , 0xE0 , 0xF7 , 0x70 , 0xE6 , 0x70 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xDB , 0x60 , 0x92 , 0x40,
12, 12, 0x0F , 0x00 , 0x3F , 0xC0 , 0x7F , 0xE0 , 0x7F , 0xE0 , 0xF7 , 0x70 , 0xE6 , 0x70 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xFF , 0xE0 , 0xB6 , 0xC0 , 0xA4 , 0x80,
  //left
12, 12, 0x0F , 0x00 , 0x3F , 0xC0 , 0x7F , 0xE0 , 0x7F , 0xE0 , 0xEE , 0xF0 , 0xE6 , 0x70 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0x6D , 0xB0 , 0x24 , 0x90,
12, 12, 0x0F , 0x00 , 0x3F , 0xC0 , 0x7F , 0xE0 , 0x7F , 0xE0 , 0xEE , 0xF0 , 0xE6 , 0x70 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0x7F , 0xF0 , 0x36 , 0xD0 , 0x12 , 0x50,
  //up_down
12, 12, 0x0F , 0x00 , 0x3F , 0xC0 , 0x7F , 0xE0 , 0x7F , 0xE0 , 0xF7 , 0x70 , 0xE6 , 0x70 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xB6 , 0xD0 , 0x24 , 0x90,
12, 12, 0x0F , 0x00 , 0x3F , 0xC0 , 0x7F , 0xE0 , 0x7F , 0xE0 , 0xEE , 0xF0 , 0xE6 , 0x70 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xFF , 0xF0 , 0xB6 , 0xD0 , 0x92 , 0x40  };


char pill[] = { 8, 8, 0, 0, 0x38, 0x38, 0x38, 0, 0, 0 };

#endif

/******  end of SIZE 10 Graph definitions *****/
/**********************************************/
/**********************************************/


 /*************************
          GAME BOARD
  *************************/

unsigned char board[] = { 
  0xC2, 0x22, 0x22, 0x22, 0x21,
  0x50, 0x00, 0x00, 0x00, 0x05,
  0x50, 0xCD, 0x0C, 0x2D, 0x05,
  0x50, 0xEF, 0x0E, 0x2F, 0x04,
#if COMPACT>=2
  0x50, 0x00, 0x00, 0x00, 0x00, //
  0xE2, 0x2D, 0x0C, 0x22, 0x90, //
#else
  0x50, 0x00, 0x00, 0x00, 0x00,
  0x50, 0x89, 0x06, 0x08, 0x21,
  0x50, 0x00, 0x05, 0x00, 0x05, //
  0xE2, 0x2D, 0x0A, 0x29, 0x04, //
#endif
  0x00, 0x05, 0x05, 0x00, 0x00,

#if SIZE==6
  0x22, 0x2F, 0x04, 0x0C, 0x90, // door
#else
  0x22, 0x2F, 0x04, 0x0C, 0x20, // door
#endif

  0x00, 0x00, 0x00, 0x05, 0x00,
  0x22, 0x2D, 0x06, 0x0E, 0x22,
  0x00, 0x05, 0x05, 0x00, 0x00,
#if COMPACT==4
  0xC2, 0x2F, 0x04, 0x08, 0x22,
#else
  0xC2, 0x2F, 0x04, 0x08, 0x21,
  0x50, 0x00, 0x00, 0x00, 0x05,
 #ifdef COMPACT
  0x50, 0x89, 0x08, 0x29, 0x04,
 #else
  0x50, 0x8D, 0x08, 0x29, 0x04,
  0x50, 0x05, 0x00, 0x00, 0x00,
  0xA9, 0x04, 0x06, 0x08, 0x21,
  0x50, 0x00, 0x05, 0x00, 0x05,
  0x50, 0x82, 0x23, 0x29, 0x04,
 #endif
#endif
  0x50, 0x00, 0x00, 0x00, 0x00,
  0xE2, 0x22, 0x22, 0x22, 0x22
};


#define CENTER SIZE/2

#define VERTICAL   1
#define HORIZONTAL 0



 /******************************
         GLOBAL VARIABLES
  ******************************/

int ani_man, ani_gst, stick;
char *man;
int a,b,c,i,j;
int direction,cycle,cycle2,cycle3;
int x,y;
int dots;
int scared;
int score, lives;

#if COMPACT!=3
char scoretxt[7];
#endif

typedef struct {
  int  x;
  int  y;
  int  direction;
  int  eaten;
  char *pic;
} ghost;

ghost g[4];

char *basepic;



#if COMPACT!=3

 /*************************
         SHOW SCORE
  *************************/

// Print current score

void showscore ()
{
#if SIZE==6
    sprintf (scoretxt,"%05u",score);
    for (i=0; i<5; i++) {
      putsprite (spr_and, 1+SIZE2*19+i*4, SIZE3, blank);
      putsprite (spr_or, 1+SIZE2*19+i*4, SIZE3, &numbers[(scoretxt[i]-48)*7]);
    }
#else
    sprintf (scoretxt,"%06u",score);
    for (i=0; i<6; i++) {
      putsprite (spr_and, SIZE2*20+i*5, SIZE3, blank);
      putsprite (spr_or, SIZE2*20+i*5, SIZE3, &numbers[(scoretxt[i]-48)*7]);
    }
#endif
}


 /*************************
         SHOW LIVES
  *************************/
void showlives ()
{
  for (i=0; i<MAXLIVES; i++) {
    if (lives>i)
#if SIZE==6
      putsprite (spr_or, 1+SIZE2*19+i*SIZE, SIZE3*2, &man_right[SIZE3*2]);
    else
      putsprite (spr_and, 1+SIZE2*19+i*SIZE, SIZE3*2, &man_right[SIZE3*2]);
#elif SIZE==10
      putsprite (spr_or, SIZE2*20+i*15, 38, &man_right[SIZE3*2]);
    else
      putsprite (spr_and, SIZE2*20+i*15, 38, &man_right[SIZE3*2]);
#else
      putsprite (spr_or, SIZE2*20+i*SIZE3, SIZE3*2, &man_right[SIZE3*2]);
    else
      putsprite (spr_and, SIZE2*20+i*SIZE3, SIZE3*2, &man_right[SIZE3*2]);
#endif
  }
}
#endif


 /************************
          EAT DOT
  ************************/

void eatdot ()
{
  score += 10;
#if COMPACT!=3
  showscore();
#endif
#ifdef SOUND
  bit_beep(4,60);
#endif
  dots--;
}



 /*************************
          EAT PILL
  *************************/

void eatpill ()
{
#ifdef SOUND
  bit_fx(6);
#endif
  dots--;
  for (a=0; a<GHOSTS; a++) g[a].eaten=0;
  basepic=wgh;
  scared=180;
}



 /*******************************
    COLLISION (ONLY WALLS, ETC)
  *******************************/

int collision(int x, int y, int direction)
{
  switch (direction) {
  case MOVE_RIGHT:
    b = multipoint(VERTICAL, MPSIZE, x+MPSIZE-MPMARGIN, y-MPMARGIN);
    break;
  case MOVE_LEFT:
    b = multipoint(VERTICAL, MPSIZE, x-MPMARGIN-1, y-MPMARGIN);
    break;
  case MOVE_DOWN:
    b = multipoint(HORIZONTAL, MPSIZE, x-MPMARGIN, y+MPSIZE-MPMARGIN);
    break;
  case MOVE_UP:
    b = multipoint(HORIZONTAL, MPSIZE, x-MPMARGIN, y-MPMARGIN-1);
    break;
  }
  return (b == BLANKROW || b == DOTROW || b == PILL );
}


 /************************
         MOVE GHOST
  ************************/

void move_ghost()
{

 if ((rand()%5) == 1) cycle3++;

 i=0;
 while (i++ < 4) {
   cycle3++;

// exiting from door ?

#ifdef COMPACT
  if ( (g[a].y==(SIZE2*8-1)) && (g[a].x>=(SIZE2*8-1)) && (g[a].x<=(SIZE2*10-1)) )
#else
  if ( (g[a].y==(SIZE2*10-1)) && (g[a].x>=(SIZE2*8-1)) && (g[a].x<=(SIZE2*10-1)) )
#endif
    return;

// Has the man been seen by the ghost ?

  if (g[a].x == x) {
    if (abs (g[a].y - y) < (SIZE2 * 4)) {
      if ((g[a].y < y)&&(scared>0)&&(g[a].eaten==0))
      //if (g[a].y > y)
        g[a].direction=MOVE_UP;
      else
        g[a].direction=MOVE_DOWN;
      return;
    }
  }
  
  if (g[a].y == y) {
    if ((g[a].x - x) < (SIZE2 * 4)) {
      if ((g[a].x < x)&&(scared>0)&&(g[a].eaten==0))
        g[a].direction=MOVE_LEFT;
      else
        g[a].direction=MOVE_RIGHT;
      return;
    }
  }

// change ghost direction "randomly"
  b = (cycle2+cycle3)&3 ;
  //b = rand()&3;
  g[a].direction = 1<< b ;

// exit if ghost can go in that direction
  if (collision(g[a].x, g[a].y, g[a].direction));
    return;
 }
}




 /*************************
  *************************
            MAIN
  *************************
  *************************/

int main ()
{

 /****  JOYSTICK CHOICE  ****/

#ifdef JOYSTICK_DIALOG
  printf("%c",12);

  for (x=0 ; x!=GAME_DEVICES; x++)
      printf("%u - %s\n",x+1,joystick_type[x]);
        
  stick=0;
  while ((stick<1) || (stick>GAME_DEVICES))
      stick=getk()-48;
#else
  stick=1;
#endif


 /****  GAME INITIALIZATION  ****/

  score=0;
  lives=MAXLIVES;


 /****  DRAW BOARD  ****/
draw_board:

  clg();
#if COMPACT!=3
//  showscore();
#endif
  dots=MAXDOTS;

  for (j=0; j<BOARD_ROWS; j++) {
    c=0;
    for (i=0; i<10; i++) {
      a=board [5*j+i/2];
      if (i & 1) a = a&15;
      else a = a/16;
      if (a!=0) {
        b=0;
        if (--a > 6) b=SIZE*2*(a&1)-SIZE;
        
        c=&bar[SIZE*a];
        putsprite (spr_or, i*SIZE2, j*SIZE2, c);
        putsprite (spr_or, (18-i)*SIZE2, j*SIZE2, c+b);
      }
#if COMPACT>=2
      else if ( ((c!=0 && j!=8) || (c==0 && j==8 && i>1)) && !(j==7 && i==9) )
#else
      else if ( ((c!=0 && j!=10) || (c==0 && j==10 && i>1)) && !(j==9 && i==9) )
#endif
      {
#if SIZE==10
          plot (i*SIZE2+(SIZE2/2)-MPMARGIN+2, j*SIZE2+(SIZE2/2));
          plot ((18-i)*SIZE2+(SIZE2/2)-MPMARGIN+2, j*SIZE2+(SIZE2/2));
        if ( (j==2 || j==14) && (i == 1) ) {
          putsprite (spr_or, i*SIZE2+1, j*SIZE2, pill);
          putsprite (spr_or, (18-i)*SIZE2+1, j*SIZE2, pill);
#else
          plot (i*SIZE2+(SIZE2/2)-MPMARGIN+1, j*SIZE2+(SIZE2/2));
          plot ((18-i)*SIZE2+(SIZE2/2)-MPMARGIN+1, j*SIZE2+(SIZE2/2));
        if ( (j==2 || j==14) && (i == 1) ) {
          putsprite (spr_or, i*SIZE2, j*SIZE2, pill);
          putsprite (spr_or, (18-i)*SIZE2, j*SIZE2, pill);
#endif
        }
      }
    }
  }


 /****  MATCH INITIALIZATION  ****/

do_game:
  cycle=1; cycle2=0; cycle3=0;
  scared=0;
  man=man_right;

  for (a=0; a<GHOSTS; a++)  {

    g[a].x=(SIZE2*8)-1+a;

#if SIZE==10
  #if COMPACT>=2
    g[a].y=(SIZE2*8)-2;
  #else
    g[a].y=(SIZE2*10)-2;
  #endif
#else
  #if COMPACT>=2
    g[a].y=(SIZE2*8)-1;
  #else
    g[a].y=(SIZE2*10)-1;
  #endif
#endif
    g[a].direction=MOVE_RIGHT;
    g[a].pic=bgh;
    g[a].eaten=1;
  }

    x=(SIZE2*9)-1;

#if SIZE==10
  #if COMPACT>=2
    y=(SIZE2*10)-2;
  #else
    y=(SIZE2*12)-2;
  #endif
#else
  #if COMPACT>=2
    y=(SIZE2*10)-1;
  #else
    y=(SIZE2*12)-1;
  #endif
#endif

    direction=MOVE_RIGHT;
  
    basepic=bgh;

#if COMPACT!=3
    showlives();
#endif

    for (a=0; a<GHOSTS; a++)
      putsprite (spr_xor, g[a].x, g[a].y, &g[a].pic[SIZE3*((cycle2 + a) & 1)]);

    putsprite (spr_or, x, y, &man[SIZE3*cycle]);


/****  PLAY "MUSIC"  ****/

#ifdef SOUND
#ifndef LOUD

    // MUSIC
    bit_synth (50,200,200,40,40);
    bit_synth (25,160,160,50,50);
    bit_synth (9,160,160,162,162);
    bit_synth (50,200,200,33,33);
    bit_synth (100,200,200,40,40);
    bit_synth (50,160,160,50,50);

    bit_synth (50,177,177,37,37);
    bit_synth (25,150,150,44,44);
    bit_synth (9,150,150,152,152);
    bit_synth (50,160,160,33,33);
    bit_synth (100,177,177,37,37);

    bit_synth (50,150,150,44,44);


    bit_synth (20,160,160,50,50);
    bit_synth (20,160,160,44,44);
    bit_synth (20,200,200,40,40);

    bit_synth (20,150,150,44,44);
    bit_synth (20,150,150,40,40);
    bit_synth (25,160,160,33,33);

    bit_synth (20,150,150,40,40);
    bit_synth (25,160,160,33,33);
    bit_synth (20,200,200,50,50);

    bit_synth (25,160,160,33,33);
    bit_synth (20,200,200,50,50);

    bit_synth (70,160,160,29,29);
    bit_synth (255,100,100,25,25);

#else

    // LOUD MUSIC
    bit_synth (50,200,201,40,41);
    bit_synth (25,160,161,50,51);
    bit_synth (9,160,161,162,163);
    bit_synth (50,200,201,33,34);
    bit_synth (100,200,201,40,41);
    bit_synth (50,160,161,50,51);

    bit_synth (50,177,178,37,38);
    bit_synth (25,150,151,44,45);
    bit_synth (9,150,151,152,153);
    bit_synth (50,160,161,33,34);
    bit_synth (100,177,178,37,38);

    bit_synth (50,150,151,44,45);

    //bit_fx2(7);

    bit_synth (20,160,161,50,51);
    bit_synth (20,160,161,44,45);
    bit_synth (20,200,201,40,41);

    bit_synth (20,150,151,44,45);
    bit_synth (20,150,151,40,41);
    bit_synth (25,160,161,33,34);

    bit_synth (20,150,151,40,41);
    bit_synth (25,160,161,33,34);
    bit_synth (40,200,201,50,51);
    bit_synth (9,150,151,152,153);

    //bit_synth (70,160,161,29,28);
    bit_synth (180,200,201,50,51);

#endif
#endif
  

/****  BEGIN MATCH (1 LIFE LOOP)  ****/

  do {

    // Move MicroMan
    a=joystick(stick);
    
    b=1;
    
    if (collision(x,y,a))
      direction=a;
    
    putsprite (spr_and, x, y, &man[SIZE3*cycle]);

    a=0;
    
    b=collision(x,y,direction);
    
    switch (direction) {
    case MOVE_RIGHT:
        man=man_right;
        if (b) {
          b=multipoint(VERTICAL, MPSIZE, x+MPSIZE-MPMARGIN, y-MPMARGIN);
          if (b == DOTROW) {
            eatdot();
#if SIZE==10
            unplot(x+MPSIZE-MPMARGIN, y+(MPSIZE/2)-1);
#else
            unplot(x+MPSIZE-MPMARGIN, y+(SIZE/2));
#endif
          }
          if (b == PILL) {
            eatpill();
            putsprite (spr_xor, (x+SIZE2)/SIZE2*SIZE2, (y+SIZE2)/SIZE2*SIZE2, pill);
          }
          x++;
          a++;
        }
        break;
    case MOVE_LEFT:
        man=man_left;
        if (b) {
          b=multipoint(VERTICAL, MPSIZE, x-MPMARGIN, y-MPMARGIN);
          if (b == DOTROW) {
            eatdot();
#if SIZE==10
            unplot(x-MPMARGIN, y+(MPSIZE/2)-1);
#else
            unplot(x-MPMARGIN, y+(SIZE/2));
#endif
          }
          if (b == PILL) {
            eatpill();
#if SIZE==6
            putsprite (spr_xor, (x-1)/SIZE2*SIZE2, (y+SIZE2)/SIZE2*SIZE2, pill);
#else
            putsprite (spr_xor, x/SIZE2*SIZE2, (y+SIZE2)/SIZE2*SIZE2, pill);
#endif
          }
          x--;
          a++;
        }
        break;
    case MOVE_DOWN:
        man=man_down;
        if (b) {
          b=multipoint(HORIZONTAL, MPSIZE, x-MPMARGIN, y+MPSIZE-MPMARGIN);
          if (b == DOTROW) {
            eatdot();
#if SIZE==10
            unplot(x+(MPSIZE/2)-1, y+MPSIZE-MPMARGIN);
#else
            unplot(x+(SIZE/2), y+MPSIZE-MPMARGIN);
#endif

          }
          if (b == PILL) {
            eatpill();
#if SIZE==6
            putsprite (spr_xor, (x+SIZE2-1)/SIZE2*SIZE2, (y+SIZE2+1)/SIZE2*SIZE2, pill);
#else
            putsprite (spr_xor, (x+SIZE2)/SIZE2*SIZE2, (y+SIZE2)/SIZE2*SIZE2, pill);
#endif
          }
          y++;
          a++;
        }
        break;
    case MOVE_UP:
        man=man_up;
        if (b) {
          b=multipoint(HORIZONTAL, MPSIZE, x-MPMARGIN, y-MPMARGIN);
          if (b == DOTROW) {
            eatdot();
#if SIZE==10
            unplot(x+(MPSIZE/2)-1, y-MPMARGIN);
#else
            unplot(x+(SIZE/2), y-MPMARGIN);
#endif
          }
          if (b == PILL) {
            eatpill();
#if SIZE==6
            putsprite (spr_xor, (x+SIZE2-1)/SIZE2*SIZE2, y/SIZE2*SIZE2, pill);
#else
            putsprite (spr_xor, (x+SIZE2)/SIZE2*SIZE2, y/SIZE2*SIZE2, pill);
#endif
          }
          y--;
          a++;
        }
        break;
    }
    
    cycle=(x+y) & 3;
        
    // Tunnel for micro-man
    if (x==0) x=SIZE2*18;
      else if (x==(SIZE2*18)) x=0;
    
    putsprite (spr_or, x, y, &man[SIZE3*cycle]);

    
#ifdef SOUND
    // Man chewing sound
    if (a>0) bit_beep(10, cycle*8);
#endif

    // Move ghosts
    cycle2++;
    for (a=0; a<GHOSTS; a++)  {
      putsprite (spr_xor, g[a].x, g[a].y, &g[a].pic[SIZE3*((cycle2 + a - 1) & 1)]);

      b=collision(g[a].x, g[a].y, g[a].direction);

      switch (g[a].direction) {
      case MOVE_RIGHT:
        if (g[a].eaten > 0)
          g[a].pic=bgh;
        else
          g[a].pic=basepic;
        if (b) {
          g[a].x++;
#ifdef COMPACT
          if ( (g[a].y==(SIZE2*8-1)) && (g[a].x==(SIZE2*9-1)) )
#else
          if ( (g[a].y==(SIZE2*10-1)) && (g[a].x==(SIZE2*9-1)) )
#endif
          g[a].direction=MOVE_UP;
        }
        else
          move_ghost();
        break;
      case MOVE_LEFT:
        if (g[a].eaten > 0)
          g[a].pic=bgh+G_LEFT;
        else
          g[a].pic=basepic+G_LEFT;
        if (b)
          g[a].x--;
        else
          move_ghost();
        break;
      case MOVE_DOWN:
        if (g[a].eaten > 0)
          g[a].pic=bgh+G_UPDOWN;
        else
          g[a].pic=basepic+G_UPDOWN;
        if (b)
          g[a].y++;
        else
          move_ghost();
        break;
      case MOVE_UP:
        if (g[a].eaten > 0)
          g[a].pic=bgh+G_UPDOWN;
        else
          g[a].pic=basepic+G_UPDOWN;
#ifdef COMPACT
        if ( (g[a].y<=(SIZE2*8-1)) && (g[a].y>=(SIZE2*6)) && (g[a].x==(SIZE2*9-1)) )
#else
        if ( (g[a].y<=(SIZE2*10-1)) && (g[a].y>=(SIZE2*8)) && (g[a].x==(SIZE2*9-1)) )
#endif
        g[a].y--;
        else if (b)
          g[a].y--;
        else 
          move_ghost();
        break;
      cycle3++;
      }
      
      // Ghosts position handling for tunnel
      if (g[a].x==0) g[a].x=SIZE2*18;
        else if (g[a].x==(SIZE2*18)) g[a].x=0;

      // DETECTION OF COLLISION WITH GHOSTS

    #if SIZE == 6
      //if ( (abs((g[a].x+CENTER) - (x+CENTER)) <= (SIZE)) && (abs((g[a].y+CENTER) - (y+CENTER)) <= (SIZE)) )
      if ( (abs((g[a].x+CENTER) - (x+CENTER)) <= (SIZE)) && (abs((g[a].y+CENTER) - (y+CENTER)) <= (1)) ||
        (abs((g[a].x+CENTER) - (x+CENTER)) <= (1)) && (abs((g[a].y+CENTER) - (y+CENTER)) <= (SIZE)) )
    #else
      if ( ((abs((g[a].x+CENTER) - (x+CENTER)) <= (SIZE+MPMARGIN)) && (abs((g[a].y+CENTER) - (y+CENTER)) <= (2))) ||
        (abs((g[a].x+CENTER) - (x+CENTER)) <= (2)) && (abs((g[a].y+CENTER) - (y+CENTER)) <= (SIZE+MPMARGIN)) )
    #endif
        if ((scared>0)&&(g[a].eaten==0)) {
          // Ghost has been eaten
          g[a].eaten++;
          g[a].x=(SIZE2*8)-1+a;
          g[a].direction=MOVE_RIGHT;
    #if COMPACT>=2
          g[a].y=(SIZE2*8)-1;
    #else
          g[a].y=(SIZE2*10)-1;
    #endif
    #ifdef SOUND
          // gulp !
          bit_fx2(4);
    #endif
          score += 100;
          if (scared <70)
            score += 50;
          if (scared <10)
            score += 50;
#if COMPACT!=3
//          showscore();
#endif
        } else {
          // Man has been eaten !!
    #ifdef SOUND
          // gulp !
          bit_fx2(5);
    #endif
          // Flash a bit the current ghost
          putsprite (spr_xor, g[a].x, g[a].y, &g[a].pic[SIZE3*((cycle2 + a) & 1)]);
          putsprite (spr_and, x, y, &man[SIZE3*cycle]);
          putsprite (spr_xor, x+MPMARGIN, y+MPMARGIN, deadman);
    #ifdef SOUND
          // ka-boom !
          bit_fx2(7);
    #endif
          putsprite (spr_xor, x+MPMARGIN, y+MPMARGIN, deadman);
          putsprite (spr_xor, g[a].x, g[a].y, &g[a].pic[SIZE3*((cycle2 + a) & 1)]);
          lives--;
#if COMPACT!=3
          showlives();
#endif
          if (lives==0) {
            // Game Over, clear space for message
            for (i=-2; i<3; i++) {
              for (j=-1; j<2; j++) {
                putsprite (spr_and, (SIZE2*19-48)/2+i, SIZE3*4+j, gameover);
              }
            }
            // Print the "Game Over" message
            putsprite (spr_or, (SIZE2*19-48)/2, SIZE3*4, gameover);
    #ifdef SOUND
            for (i=-2; i<3; i++) {
              bit_fx(1);
              bit_fx2(2);
            }
    #endif
            // Now flash the "Game Over" message for a bit..
            for (a=0; a<3000; a++)
              if ((a % 128) == 0) putsprite (spr_xor, (SIZE2*19-48)/2, SIZE3*4, gameover);
            //mt_hrg_off();
            return(score);
          }
          // Pick current ghost number
          i=a;
          // Clear ghosts
          for (a=0; a<GHOSTS; a++)  {
            // Clean ghosts before the current one (already moved)
            if (a<i) putsprite (spr_xor, g[a].x, g[a].y, &g[a].pic[SIZE3*((cycle2 + a) & 1)]);
            // Clean ghosts after the current one
            if (a>i) putsprite (spr_xor, g[a].x, g[a].y, &g[a].pic[SIZE3*((cycle2 + a - 1) & 1)]);
          }
          // Clear man
          putsprite (spr_and, x, y, &man[SIZE3*cycle]);
          goto do_game;
        }

      putsprite (spr_xor, g[a].x, g[a].y, &g[a].pic[SIZE3*((cycle2 + a) & 1)]);
    } // end of ghosts loop
    
    // If a pill has been eaten, the ghosts' picture turns white for a while..
    if (scared>0) {
        scared--;
        // ... then flashes for a short period
        if (scared <70)
          if ( (scared & 8) == 0 )
            basepic=bgh;
          else
            basepic=wgh;
    }


  } while (dots>0);  // loop until all the dots and pills have been eaten

  // LEVEL FINISHED !!
  score += 500;
  goto draw_board;
}
