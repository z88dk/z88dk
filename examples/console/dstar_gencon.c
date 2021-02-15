/*
 *      DStar converted to use generic console/conio for drawing
 *
 *      Program history is in other versions of dstar
 *
 *     -DUSE_JOYSTICK switches to using the joystick
 *     -DUSE_UDGS uses UDGs for the characters
 *     -DSWITCH_MODE=x switches to screenmode x for display
 *     -DSOUND or -DSOUNDB adds bells and whistles if available
 */


#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <ctype.h>
#include <games.h>
#include <sys/ioctl.h>

#ifdef SOUND
#include <sound.h>
#endif
#ifdef SOUNDB
#include <sound.h>
#endif


/* Key definitions, change these to define your keys! */
#ifndef USE_JOYSTICK

#define K_UP 'Q'
#define K_DOWN 'A'
#define K_LEFT 'O'
#define K_RIGHT 'P'
#define K_SWITCH ' '
#define K_EXIT 'G'
#define K_CLEAR 'H'
#endif

#define MAXLEVEL 25
#define STARTLEV 0 /* Start level -1 */

#define WALL 1
#define BUBB 2
#define BALL 3
#define BOX 4


/* Mapping between block numbers and ascii characters */
#ifdef USE_UDGS
static const unsigned char blocks[] = { ' ', 128, 129, 130, 131 };
#else
static const unsigned char blocks[] = { ' ', 'X', 'o', '@', '#' };
#endif
static unsigned char balloffset; /* Ball position */
static unsigned char boxoffset;  /* Box position */
static unsigned char ballorbox;  /* 1 if box, 0 if ball */
static unsigned char level;      /* Take a guess! */

static unsigned char x_offset;
static unsigned char y_offset;

static unsigned char board[144]; /* Level internal map thing */


#ifdef USE_UDGS
static unsigned char udgs[] = {
    0b01111110,	// Wall
    0b10101001,
    0b11000111,
    0b10110001,
    0b11001011,
    0b10100101,
    0b10101001,
    0b01111110,

    0b00000000, // bubble
    0b00000000,
    0b00011000,
    0b00100100,
    0b00100100,
    0b00011000,
    0b00000000,
    0b00000000,

    0b00000000, // movable ball
    0b00111100,
    0b01110110,
    0b01111010,
    0b01111010,
    0b01111110,
    0b00111100,
    0b00000000,

    0b00000000, // movable block
    0b01111110,
    0b01000010,
    0b01000010,
    0b01000010,
    0b01000010,
    0b01111110,
    0b00000000
};
#endif

// Level definition
static const unsigned char levels[][38] = {
   {
        17,30,                        //ball offset, box offset
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01000101,0b00000000,0b00000000,0b10010001,
        0b01000000,0b00000000,0b00000010,0b00010101,
        0b01000000,0b00000000,0b01011000,0b00000001,
        0b01000000,0b01010010,0b00000000,0b00000101,
        0b01010010,0b00001000,0b00000000,0b10000001,
        0b01001000,0b00000000,0b00100101,0b00100001,
        0b01000000,0b00000101,0b10000000,0b00001001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level2
        30,86,
        0b00010000,0b01000100,0b01000000,0b01000101,
        0b01000000,0b10000000,0b00000000,0b00000001,
        0b00000001,0b10000001,0b10000000,0b10000000,
        0b01000100,0b10000000,0b00001000,0b00010001,
        0b00000000,0b00000100,0b00001000,0b00000100,
        0b01000000,0b00010001,0b00001000,0b00000001,
        0b00000001,0b00000100,0b01000000,0b01101001,
        0b01000000,0b00000000,0b00000000,0b00000100,
        0b00010000,0b01000000,0b00000000,0b00010000
    },
    {
//.level3
        30,46,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01000000,0b00000000,0b00000000,0b10010001,
        0b01000000,0b01010000,0b00000000,0b01010001,
        0b01000000,0b01100000,0b00000010,0b00000001,
        0b01001000,0b00000000,0b10010100,0b00001001,
        0b01000110,0b00001000,0b00100100,0b00100101,
        0b01000101,0b10000110,0b00001000,0b10010101,
        0b01100000,0b00000101,0b10000000,0b00000001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level4
        125,30,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01000000,0b00000000,0b00000000,0b00010001,
        0b01000000,0b00000100,0b00000000,0b00000001,
        0b01011001,0b10001001,0b10011001,0b10011001,
        0b01000100,0b01100010,0b01000100,0b01000101,
        0b01011001,0b10011000,0b10011001,0b10011001,
        0b01000000,0b00000100,0b00000000,0b00000001,
        0b01000000,0b01000000,0b00000000,0b01000001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level5
        17,110,
        0b00010101,0b01010101,0b01010101,0b01010100,
        0b01000000,0b01000000,0b01000001,0b00000001,
        0b01000001,0b10000100,0b10000010,0b00010001,
        0b01010000,0b00000000,0b01000001,0b00000001,
        0b01100001,0b10010000,0b00000000,0b00000101,
        0b01010000,0b00000001,0b00100001,0b00000001,
        0b01100100,0b00010001,0b00010000,0b00010001,
        0b01000000,0b01000000,0b00100100,0b00011001,
        0b00010101,0b01010101,0b01010101,0b01010100
    },
    {
//.level6
        65,113,
        0b00000000,0b01010101,0b01010101,0b01010101,
        0b00000001,0b00000010,0b00000001,0b10001001,
        0b00000100,0b00000010,0b00000000,0b01000101,
        0b00010000,0b00000010,0b00000000,0b00000001,
        0b01000000,0b00000010,0b00000000,0b00000001,
        0b01010000,0b00000010,0b00000100,0b00000101,
        0b01000000,0b00000010,0b00000000,0b01000001,
        0b01000001,0b00000010,0b00000101,0b10000001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level7
        115,122,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01000000,0b00000000,0b00000000,0b00000001,
        0b00010100,0b01010100,0b00011000,0b01011001,
        0b00011000,0b00011000,0b01000100,0b01000100,
        0b00000100,0b00010000,0b01010100,0b01010000,
        0b00010100,0b00010000,0b01100100,0b01100100,
        0b01000000,0b00000000,0b00000000,0b00000001,
        0b01000000,0b01100000,0b00000000,0b00011001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level8
        108,98,
        0b01010101,0b01010101,0b01010101,0b01010100,
        0b01000010,0b01010000,0b00000000,0b00000101,
        0b01000001,0b10000001,0b01001000,0b00000001,
        0b01000010,0b01010001,0b00011000,0b00000001,
        0b01010000,0b00000001,0b01000001,0b10010001,
        0b01010001,0b00000000,0b00000010,0b01100001,
        0b01100010,0b01000000,0b10000001,0b00010001,
        0b01010000,0b00000000,0b00000000,0b00000001,
        0b00010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level9
        30,72,
        0b00000100,0b01010101,0b01010101,0b01010100,
        0b00011001,0b10000000,0b00000001,0b00000001,
        0b01100010,0b01000000,0b00100000,0b00000100,
        0b00010001,0b00001001,0b01000010,0b01000001,
        0b01000001,0b10000110,0b00100000,0b00001001,
        0b01000000,0b00001001,0b01000000,0b00000100,
        0b01100110,0b00000000,0b00000000,0b00010000,
        0b01000000,0b00000000,0b00000000,0b01000000,
        0b01010101,0b01010101,0b01010101,0b00000000
    },
    {
//.level10
        93,36,
        0b00000000,0b01010101,0b01010101,0b01010100,
        0b01010101,0b00100000,0b00000000,0b00000001,
        0b01000000,0b00000101,0b01100010,0b01001001,
        0b01001000,0b00000110,0b00011000,0b00000100,
        0b01000000,0b00000100,0b00100000,0b01001001,
        0b01100110,0b00000100,0b10010000,0b01000100,
        0b00011000,0b00000101,0b01000001,0b01010000,
        0b01000000,0b00000000,0b00000100,0b01000100,
        0b00010101,0b01010101,0b01010000,0b01000001
    },
    {
//.level11
        30,108,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01000000,0b00000001,0b00000000,0b00000001,
        0b01000001,0b10100000,0b00000010,0b10000101,
        0b01010000,0b00100000,0b00010100,0b00001001,
        0b01100000,0b00000110,0b01101000,0b00010101,
        0b01010001,0b01000000,0b00010100,0b00000001,
        0b01100000,0b10010010,0b00000000,0b00001001,
        0b01011001,0b01010000,0b00000100,0b00000101,
        0b00010100,0b01010101,0b01010101,0b01010100
    },
    {
//.level12
        17,92,
        0b01010000,0b00000001,0b01000001,0b01010100,
        0b01000101,0b01010110,0b00010101,0b00100101,
        0b01000000,0b00101000,0b00000000,0b10000001,
        0b01000101,0b00000101,0b10000001,0b10010001,
        0b01000100,0b10000101,0b01100001,0b01000001,
        0b01000101,0b00000101,0b00000001,0b00010001,
        0b01000000,0b00001000,0b00000000,0b00000001,
        0b01000000,0b00000000,0b00100000,0b00000001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level13
        18,113,
        0b00010101,0b01010101,0b01010101,0b01010100,
        0b01000001,0b00000000,0b00000000,0b10000101,
        0b01000100,0b00000110,0b00000010,0b01010001,
        0b01000000,0b00000000,0b10000000,0b00010001,
        0b01001000,0b00000000,0b00000000,0b00011001,
        0b01000100,0b00000000,0b00100000,0b00000001,
        0b01010000,0b00000000,0b10001000,0b00011001,
        0b01000000,0b01000000,0b00100001,0b00010001,
        0b00010101,0b01010101,0b01010101,0b01010100
    },
    {
//.level14
        36,50,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01100110,0b00000000,0b00000000,0b10011001,
        0b01001001,0b00000000,0b00000001,0b01000001,
        0b01000000,0b00000000,0b00000010,0b00000001,
        0b01000000,0b00000000,0b00100100,0b00000001,
        0b01000000,0b00000010,0b00000000,0b00000001,
        0b01001001,0b00000000,0b00000000,0b01000001,
        0b01100110,0b00000000,0b00000000,0b10011001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level15
        51,76,
        0b00010101,0b01010100,0b01010101,0b01010100,
        0b01000000,0b00001001,0b00000000,0b00100001,
        0b01000100,0b10000100,0b00010000,0b00100001,
        0b01000000,0b01000000,0b01101000,0b01100001,
        0b00010001,0b00000001,0b00100000,0b00010001,
        0b01100000,0b00000000,0b00010000,0b01100001,
        0b00010000,0b00000000,0b10000000,0b00000100,
        0b01100000,0b00000000,0b00000000,0b00001001,
        0b00010101,0b01010101,0b01010101,0b01010100
    },
    {
//.level16
        35,19,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01010000,0b01100010,0b00000000,0b00001001,
        0b01100000,0b10011000,0b00000000,0b00000101,
        0b01010001,0b01010000,0b00001000,0b00000101,
        0b01010000,0b00000010,0b01100100,0b00000001,
        0b01101000,0b00000000,0b00001001,0b10000001,
        0b01010010,0b00000000,0b01010101,0b10000001,
        0b01011001,0b00000100,0b00000000,0b00000001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level17
        29,124,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01001001,0b00000000,0b00000000,0b01000001,
        0b01000100,0b00100110,0b10011000,0b00010001,
        0b01000000,0b00011001,0b01100100,0b10000001,
        0b01001001,0b00000000,0b00000010,0b01000001,
        0b01000010,0b01100000,0b00001001,0b00000001,
        0b01000100,0b00010001,0b01100100,0b00010001,
        0b01000000,0b00100001,0b10000000,0b00000001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level18
        115,26,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01001000,0b00000010,0b00000001,0b00000001,
        0b01000001,0b10011000,0b00000110,0b00000001,
        0b01000000,0b01100100,0b00000001,0b10000001,
        0b01000000,0b10000001,0b00000010,0b01100001,
        0b01000110,0b01000000,0b01001001,0b00000001,
        0b01001001,0b10000100,0b10000100,0b00000001,
        0b01100100,0b00000100,0b00000000,0b01000001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level19
        126,110,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01100000,0b00010100,0b00000000,0b01011001,
        0b01000100,0b00010000,0b00000000,0b01100001,
        0b01001001,0b00000010,0b01010000,0b10000001,
        0b01000100,0b00000001,0b10000000,0b00000001,
        0b01000000,0b00010000,0b00100100,0b00000001,
        0b01000101,0b00100100,0b01011000,0b00010001,
        0b01001001,0b00011000,0b00000000,0b01010001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level20
        77,66,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01000000,0b10011000,0b00000000,0b00000001,
        0b01011000,0b00100100,0b01011000,0b00000101,
        0b01000100,0b01001000,0b00000100,0b00010001,
        0b01000000,0b01000001,0b01000001,0b00001001,
        0b01000100,0b00010000,0b00100001,0b00010001,
        0b01010000,0b00100101,0b00011000,0b00100101,
        0b01000000,0b00000000,0b00100110,0b00000001,
        0b01010101,0b01010101,0b01010101,0b01010101
    },
    {
//.level21
        103,105,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01000101,0b01000000,0b00001000,0b00000101,
        0b01000000,0b01000000,0b00000000,0b01000101,
        0b01000000,0b01011000,0b00000000,0b00100001,
        0b01000010,0b00000000,0b10000000,0b10000101,
        0b01000000,0b00010000,0b00000101,0b01100001,
        0b01000010,0b00100000,0b00000010,0b00101001,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b00000000,0b00000000,0b00000000,0b00000000
    },
    {
//.level22
        103,105,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01100100,0b00011001,0b00011000,0b00010001,
        0b01000000,0b00010000,0b00000000,0b00000001,
        0b01100000,0b00010000,0b01100000,0b10000001,
        0b01010001,0b10000000,0b00000010,0b00010101,
        0b01001000,0b01000000,0b01010110,0b00000001,
        0b01000000,0b00000100,0b01000000,0b10000001,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b00000000,0b00000000,0b00000000,0b00000000
    },
    {
//.level23
        103,105,
        0b00010101,0b01010101,0b01010101,0b01010100,
        0b01000100,0b00011001,0b00011000,0b00010001,
        0b01000000,0b00100000,0b01000000,0b00000001,
        0b01010000,0b00010000,0b00100001,0b10000001,
        0b01000001,0b10000001,0b00001010,0b00100001,
        0b01011000,0b01000000,0b01010010,0b00000001,
        0b01000000,0b00000100,0b01000000,0b10000001,
        0b00010101,0b01010101,0b01010101,0b01010100,
        0b00000000,0b00000000,0b00000000,0b00000000
    },
    {
//.level24
        103,105,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01000000,0b00000100,0b00000000,0b00000101,
        0b01000101,0b10001000,0b00000001,0b01100101,
        0b01000110,0b00000000,0b00100100,0b00010101,
        0b01001010,0b00001001,0b00010100,0b00000001,
        0b01000110,0b00100001,0b00000000,0b01010001,
        0b01000101,0b00000000,0b01000101,0b01101001,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b00000000,0b00000000,0b00000000,0b00000000
    },
    {
//.level25
        103,105,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b01000000,0b00000000,0b00000000,0b00010001,
        0b01001000,0b01011000,0b00001000,0b00000001,
        0b01000000,0b01100000,0b10000001,0b01000001,
        0b01001000,0b00000001,0b01000001,0b10000001,
        0b01000110,0b00000010,0b01000000,0b00100001,
        0b01000101,0b10000100,0b00000000,0b00000001,
        0b01010101,0b01010101,0b01010101,0b01010101,
        0b00000000,0b00000000,0b00000000,0b00000000
    }
};

static void playgame();
static void setupgame();
static void gamekeys();
static void left(unsigned char *ptr);
static void right(unsigned char *ptr);
static void down(unsigned char *ptr);
static void up(unsigned char *ptr);
static void setuplevel();
static void drawboard();
static int checkfinish();
static int standardmiddle(unsigned char nextpos);

int
main()
{
  int  maxx, maxy;

#ifdef USE_UDGS
  void *param = &udgs;
  console_ioctl(IOCTL_GENCON_SET_UDGS, &param);
#endif

#ifdef SWITCH_MODE
   maxy = SWITCH_MODE;
   console_ioctl(IOCTL_GENCON_SET_MODE, &maxy);
#endif

#ifdef __SPECTRUM
  cputs("\x01 ");
#endif

  screensize(&maxx, &maxy);
  x_offset = (maxx - 16) / 2;
  y_offset = (maxy - 9) / 2;

  clrscr();
  gotoxy(0,0);
  cputs("DSTAR TERMINAL");
  playgame(); /* Play the game */
  return 0;
}

static void playgame()
{
  setupgame(); /* Set level to 1, get level etc */
               /* Loop while checkfinish() says we haven't finished! */

  while (checkfinish()) {
    gamekeys(); /* Scan keys */
  }
}

/* Set some variables up at the start.. */

static void setupgame()
{
  ballorbox = 0;
  level = STARTLEV;
  setuplevel();
}

#ifndef USE_JOYSTICK
static void gamekeys()
{
  unsigned char* charptr;

  if (ballorbox)
    charptr = &boxoffset;
  else
    charptr = &balloffset;

  switch (toupper(getk())) { 
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
      ballorbox ^= 1; /* Toggle ball/box */
		  #ifdef SOUND
		    bit_fx4 (5);
		  #endif
		  #ifdef SOUNDB
			bit_fx6 (6);
		  #endif
      break;
    case K_EXIT:
		  #ifdef SOUNDB
		  bit_fx6 (4);
		  #endif
      exit(0);
    case K_CLEAR:
		  #ifdef SOUND
		    bit_fx4 (3);
		  #endif
		  #ifdef SOUNDB
			bit_fx6 (1);
		  #endif
      setuplevel();
  }
}
#else
static void gamekeys()
{
  unsigned char* charptr;
  unsigned char joy;

  if (ballorbox)
    charptr = &boxoffset;
  else
    charptr = &balloffset;

  joy = joystick(1);
  if (joy & MOVE_DOWN) {
    down(charptr);
  } else if (joy & MOVE_UP) {
    up(charptr);
  } else if (joy & MOVE_RIGHT) {
    right(charptr);
  } else if (joy & MOVE_LEFT) {
    left(charptr);
  } else if (joy & MOVE_FIRE) {
    ballorbox ^= 1; /* Toggle ball/box */
  } else if (joy & MOVE_FIRE2) {
    setuplevel();
  }
}
#endif

/* Movement functions - all of these are pretty well similar so I
 * will only comment the first one - it's fairly obvious what is
 * happening though
 */
static void left(unsigned char *ptr)
{
  unsigned char *locn;

  while (1) {
    locn = *(ptr) + board;
    if (standardmiddle(*(locn - 1)))
      return;
    *(locn - 1) = *locn;
    *locn = 0;
    (*ptr)--;    /* ptr is the location of blob */
    drawboard(); /* Draw screen */
  }
}

static void right(unsigned char *ptr)
{
  unsigned char* locn;

  while (1) {
    locn = *(ptr) + board;
    if (standardmiddle(*(locn + 1)))
      return;
    *(locn + 1) = *locn;
    *locn = 0;
    (*ptr)++;
    drawboard();
  }
}

static void down(unsigned char *ptr)
{
  unsigned char *locn;

  while (1) {
    locn = *(ptr) + board;
    if (standardmiddle(*(locn + 16)))
      return;
    *(locn + 16) = *locn;
    *locn = 0;
    (*ptr) += 16;
    drawboard();
  }
}

static void up(unsigned char *ptr)
{
  unsigned char *locn;

  while (1) {
    locn = *(ptr) + board;
    if (standardmiddle(*(locn - 16)))
      return;
    *(locn - 16) = *locn;
    *locn = 0;
    (*ptr) -= 16;
    drawboard();
  }
}

/* Check to see if we're running into anything, if box is set then
 * if we hit anything we want to stop, if we're ball then if we
 * hit anything except for bubble we wanna stop
 */
static int standardmiddle(unsigned char nextpos)
{
  if (ballorbox)
    return (nextpos); /* For box */
  else if (nextpos == BUBB || nextpos == 0)
    return (0);
  return (1);
}

/* Check to see if a level is finished
 * There are 144 squares in each level, note the use of != instead of
 * </<= - this is quicker to execute on the Z80!
 */
static int checkfinish()
{
  unsigned char *ptr;
  int i;
  ptr = board;
  for (i = 1; i != 144; i++) {
    if (*ptr++ == BUBB)
      return (1);
  }
  if (++level == MAXLEVEL)
    return (0); /* Done all the levels!! */
  setuplevel();
  return (1);
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
static void setuplevel()
{
  int y;
  const unsigned char *ptr;
  unsigned char *ptr2;

  ptr2 = board;
  ptr = &levels[level][0];
  /* ptr points to start of level now */
  /* First two bytes are the ball and the boxes position */
  balloffset = *ptr++;
  boxoffset = *ptr++;

  /* Now, decompress level into board */
  for (y = 0; y != 36; y++) {
    *ptr2++ = ((*ptr) >> 6) & 3;
    *ptr2++ = ((*ptr) >> 4) & 3;
    *ptr2++ = ((*ptr) >> 2) & 3;
    *ptr2++ = (*ptr) & 3;
    ptr++;
  }
  /* Now, plot the ball and box into the internal map */
  ptr2 = board;
  *(ptr2 + balloffset) = BALL;
  *(ptr2 + boxoffset) = BOX;
  drawboard();
#ifdef SOUND
	bit_fx4 (1);
#endif
#ifdef SOUNDB
	bit_fx6 (0);
#endif
}

static void drawboard()
{
  unsigned char x, y;
  unsigned char *ptr;

  ptr = board;
  for (y = 0; y != 9; y++) {
    for (x = 0; x != 16; x++) {
      gotoxy(x + x_offset, y + y_offset);
      putch(blocks[*ptr++]);
    }
  }
#ifdef SOUND
	bit_open();
	bit_click();
	bit_close();
#endif
#ifdef SOUNDB
	bit_open();
	bit_click();
	bit_close();
#endif
}


