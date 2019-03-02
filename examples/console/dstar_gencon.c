/*
 *      DStar converted to use generic console/conio for drawing
 *
 *      Program history is in other versions of dstar
 *
 *      -DUSE_JOYSTICK switches to using the joystick
 */


#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <ctype.h>
#include <games.h>


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

extern unsigned char levels[];

/* Mapping between block numbers and ascii characters */
static char blocks[] = { ' ', 'X', '@', '#', '$' };
static unsigned char balloffset; /* Ball position */
static unsigned char boxoffset;  /* Box position */
static unsigned char ballorbox;  /* 1 if box, 0 if ball */
static unsigned char level;      /* Take a guess! */

static unsigned char x_offset;
static unsigned char y_offset;

static unsigned char board[144]; /* Level internal map thing */

static void playgame();
static void setupgame();
static void gamekeys();
static void left(char* ptr);
static void right(char* ptr);
static void down(char* ptr);
static void up(char* ptr);
static void setuplevel();
static void drawboard();
static int checkfinish();
static int standardmiddle(char nextpos);

int
main()
{
  int  maxx, maxy;

  screensize(&maxx, &maxy);
  x_offset = (maxx - 16) / 2;
  y_offset = (maxy - 9) / 2;

  clrscr();
  gotoxy(0,0);
  cputs("DSTAR TERMINAL");
  playgame(); /* Play the game */
  return;
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
      break;
    case K_EXIT:
      exit(0);
    case K_CLEAR:
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
static void left(char* ptr)
{
  unsigned char* locn;

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

static void right(char* ptr)
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

static void down(char* ptr)
{
  unsigned char* locn;

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

static void up(char* ptr)
{
  unsigned char* locn;

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
static int standardmiddle(char nextpos)
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
  unsigned char* ptr;
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
  int y, x;
  unsigned char *ptr, *ptr2;
  ptr2 = board;
  ptr = levels + (level * 38);
  /* ptr points to start of level now */
  /* First two bytes are the ball and the boxes position */
  balloffset = *ptr++;
  boxoffset = *ptr++;

  /* Now, decompress level into board */
  for (y = 0; y != 9; y++) {
    for (x = 0; x != 4; x++) {
      *ptr2++ = ((*ptr) >> 6) & 3;
      *ptr2++ = ((*ptr) >> 4) & 3;
      *ptr2++ = ((*ptr) >> 2) & 3;
      *ptr2++ = (*ptr) & 3;
      ptr++;
    }
  }
  /* Now, plot the ball and box into the internal map */
  ptr2 = board;
  *(ptr2 + balloffset) = BALL;
  *(ptr2 + boxoffset) = BOX;
  drawboard();
}

static void drawboard()
{
  int x, y;
  unsigned char* ptr;

  ptr = board;
  for (y = 0; y != 9; y++) {
    for (x = 0; x != 16; x++) {
      gotoxy(x + x_offset, y + y_offset);
      putch(blocks[*ptr++]);
    }
  }
}



#asm
	SECTION 	rodata_user

._levels
 defb    17,30                           ;ball offset, box offset
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01000101,@00000000,@00000000,@10010001
 defb    @01000000,@00000000,@00000010,@00010101
 defb    @01000000,@00000000,@01011000,@00000001
 defb    @01000000,@01010010,@00000000,@00000101
 defb    @01010010,@00001000,@00000000,@10000001
 defb    @01001000,@00000000,@00100101,@00100001
 defb    @01000000,@00000101,@10000000,@00001001
 defb    @01010101,@01010101,@01010101,@01010101
.level2
 defb    30,86
 defb    @00010000,@01000100,@01000000,@01000101
 defb    @01000000,@10000000,@00000000,@00000001
 defb    @00000001,@10000001,@10000000,@10000000
 defb    @01000100,@10000000,@00001000,@00010001
 defb    @00000000,@00000100,@00001000,@00000100
 defb    @01000000,@00010001,@00001000,@00000001
 defb    @00000001,@00000100,@01000000,@01101001
 defb    @01000000,@00000000,@00000000,@00000100
 defb    @00010000,@01000000,@00000000,@00010000
.level3
 defb    30,46
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01000000,@00000000,@00000000,@10010001
 defb    @01000000,@01010000,@00000000,@01010001
 defb    @01000000,@01100000,@00000010,@00000001
 defb    @01001000,@00000000,@10010100,@00001001
 defb    @01000110,@00001000,@00100100,@00100101
 defb    @01000101,@10000110,@00001000,@10010101
 defb    @01100000,@00000101,@10000000,@00000001
 defb    @01010101,@01010101,@01010101,@01010101
.level4
 defb    125,30
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01000000,@00000000,@00000000,@00010001
 defb    @01000000,@00000100,@00000000,@00000001
 defb    @01011001,@10001001,@10011001,@10011001
 defb    @01000100,@01100010,@01000100,@01000101
 defb    @01011001,@10011000,@10011001,@10011001
 defb    @01000000,@00000100,@00000000,@00000001
 defb    @01000000,@01000000,@00000000,@01000001
 defb    @01010101,@01010101,@01010101,@01010101
.level5
 defb    17,110
 defb    @00010101,@01010101,@01010101,@01010100
 defb    @01000000,@01000000,@01000001,@00000001
 defb    @01000001,@10000100,@10000010,@00010001
 defb    @01010000,@00000000,@01000001,@00000001
 defb    @01100001,@10010000,@00000000,@00000101
 defb    @01010000,@00000001,@00100001,@00000001
 defb    @01100100,@00010001,@00010000,@00010001
 defb    @01000000,@01000000,@00100100,@00011001
 defb    @00010101,@01010101,@01010101,@01010100
.level6
 defb    65,113
 defb    @00000000,@01010101,@01010101,@01010101
 defb    @00000001,@00000010,@00000001,@10001001
 defb    @00000100,@00000010,@00000000,@01000101
 defb    @00010000,@00000010,@00000000,@00000001
 defb    @01000000,@00000010,@00000000,@00000001
 defb    @01010000,@00000010,@00000100,@00000101
 defb    @01000000,@00000010,@00000000,@01000001
 defb    @01000001,@00000010,@00000101,@10000001
 defb    @01010101,@01010101,@01010101,@01010101
.level7
 defb    115,122
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01000000,@00000000,@00000000,@00000001
 defb    @00010100,@01010100,@00011000,@01011001
 defb    @00011000,@00011000,@01000100,@01000100
 defb    @00000100,@00010000,@01010100,@01010000
 defb    @00010100,@00010000,@01100100,@01100100
 defb    @01000000,@00000000,@00000000,@00000001
 defb    @01000000,@01100000,@00000000,@00011001
 defb    @01010101,@01010101,@01010101,@01010101
.level8
 defb    108,98
 defb    @01010101,@01010101,@01010101,@01010100
 defb    @01000010,@01010000,@00000000,@00000101
 defb    @01000001,@10000001,@01001000,@00000001
 defb    @01000010,@01010001,@00011000,@00000001
 defb    @01010000,@00000001,@01000001,@10010001
 defb    @01010001,@00000000,@00000010,@01100001
 defb    @01100010,@01000000,@10000001,@00010001
 defb    @01010000,@00000000,@00000000,@00000001
 defb    @00010101,@01010101,@01010101,@01010101
.level9
 defb    30,72
 defb    @00000100,@01010101,@01010101,@01010100
 defb    @00011001,@10000000,@00000001,@00000001
 defb    @01100010,@01000000,@00100000,@00000100
 defb    @00010001,@00001001,@01000010,@01000001
 defb    @01000001,@10000110,@00100000,@00001001
 defb    @01000000,@00001001,@01000000,@00000100
 defb    @01100110,@00000000,@00000000,@00010000
 defb    @01000000,@00000000,@00000000,@01000000
 defb    @01010101,@01010101,@01010101,@00000000
.level10
 defb    93,36
 defb    @00000000,@01010101,@01010101,@01010100
 defb    @01010101,@00100000,@00000000,@00000001
 defb    @01000000,@00000101,@01100010,@01001001
 defb    @01001000,@00000110,@00011000,@00000100
 defb    @01000000,@00000100,@00100000,@01001001
 defb    @01100110,@00000100,@10010000,@01000100
 defb    @00011000,@00000101,@01000001,@01010000
 defb    @01000000,@00000000,@00000100,@01000100
 defb    @00010101,@01010101,@01010000,@01000001
.level11
 defb    30,108
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01000000,@00000001,@00000000,@00000001
 defb    @01000001,@10100000,@00000010,@10000101
 defb    @01010000,@00100000,@00010100,@00001001
 defb    @01100000,@00000110,@01101000,@00010101
 defb    @01010001,@01000000,@00010100,@00000001
 defb    @01100000,@10010010,@00000000,@00001001
 defb    @01011001,@01010000,@00000100,@00000101
 defb    @00010100,@01010101,@01010101,@01010100
.level12
 defb    17,92
 defb    @01010000,@00000001,@01000001,@01010100
 defb    @01000101,@01010110,@00010101,@00100101
 defb    @01000000,@00101000,@00000000,@10000001
 defb    @01000101,@00000101,@10000001,@10010001
 defb    @01000100,@10000101,@01100001,@01000001
 defb    @01000101,@00000101,@00000001,@00010001
 defb    @01000000,@00001000,@00000000,@00000001
 defb    @01000000,@00000000,@00100000,@00000001
 defb    @01010101,@01010101,@01010101,@01010101
.level13
 defb    18,113
 defb    @00010101,@01010101,@01010101,@01010100
 defb    @01000001,@00000000,@00000000,@10000101
 defb    @01000100,@00000110,@00000010,@01010001
 defb    @01000000,@00000000,@10000000,@00010001
 defb    @01001000,@00000000,@00000000,@00011001
 defb    @01000100,@00000000,@00100000,@00000001
 defb    @01010000,@00000000,@10001000,@00011001
 defb    @01000000,@01000000,@00100001,@00010001
 defb    @00010101,@01010101,@01010101,@01010100
.level14
 defb    36,50
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01100110,@00000000,@00000000,@10011001
 defb    @01001001,@00000000,@00000001,@01000001
 defb    @01000000,@00000000,@00000010,@00000001
 defb    @01000000,@00000000,@00100100,@00000001
 defb    @01000000,@00000010,@00000000,@00000001
 defb    @01001001,@00000000,@00000000,@01000001
 defb    @01100110,@00000000,@00000000,@10011001
 defb    @01010101,@01010101,@01010101,@01010101
.level15
 defb    51,76
 defb    @00010101,@01010100,@01010101,@01010100
 defb    @01000000,@00001001,@00000000,@00100001
 defb    @01000100,@10000100,@00010000,@00100001
 defb    @01000000,@01000000,@01101000,@01100001
 defb    @00010001,@00000001,@00100000,@00010001
 defb    @01100000,@00000000,@00010000,@01100001
 defb    @00010000,@00000000,@10000000,@00000100
 defb    @01100000,@00000000,@00000000,@00001001
 defb    @00010101,@01010101,@01010101,@01010100
.level16
 defb    35,19
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01010000,@01100010,@00000000,@00001001
 defb    @01100000,@10011000,@00000000,@00000101
 defb    @01010001,@01010000,@00001000,@00000101
 defb    @01010000,@00000010,@01100100,@00000001
 defb    @01101000,@00000000,@00001001,@10000001
 defb    @01010010,@00000000,@01010101,@10000001
 defb    @01011001,@00000100,@00000000,@00000001
 defb    @01010101,@01010101,@01010101,@01010101
.level17
 defb    29,124
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01001001,@00000000,@00000000,@01000001
 defb    @01000100,@00100110,@10011000,@00010001
 defb    @01000000,@00011001,@01100100,@10000001
 defb    @01001001,@00000000,@00000010,@01000001
 defb    @01000010,@01100000,@00001001,@00000001
 defb    @01000100,@00010001,@01100100,@00010001
 defb    @01000000,@00100001,@10000000,@00000001
 defb    @01010101,@01010101,@01010101,@01010101
.level18
 defb    115,26
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01001000,@00000010,@00000001,@00000001
 defb    @01000001,@10011000,@00000110,@00000001
 defb    @01000000,@01100100,@00000001,@10000001
 defb    @01000000,@10000001,@00000010,@01100001
 defb    @01000110,@01000000,@01001001,@00000001
 defb    @01001001,@10000100,@10000100,@00000001
 defb    @01100100,@00000100,@00000000,@01000001
 defb    @01010101,@01010101,@01010101,@01010101
.level19
 defb    126,110
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01100000,@00010100,@00000000,@01011001
 defb    @01000100,@00010000,@00000000,@01100001
 defb    @01001001,@00000010,@01010000,@10000001
 defb    @01000100,@00000001,@10000000,@00000001
 defb    @01000000,@00010000,@00100100,@00000001
 defb    @01000101,@00100100,@01011000,@00010001
 defb    @01001001,@00011000,@00000000,@01010001
 defb    @01010101,@01010101,@01010101,@01010101
.level20
 defb    77,66
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01000000,@10011000,@00000000,@00000001
 defb    @01011000,@00100100,@01011000,@00000101
 defb    @01000100,@01001000,@00000100,@00010001
 defb    @01000000,@01000001,@01000001,@00001001
 defb    @01000100,@00010000,@00100001,@00010001
 defb    @01010000,@00100101,@00011000,@00100101
 defb    @01000000,@00000000,@00100110,@00000001
 defb    @01010101,@01010101,@01010101,@01010101
.level21
 defb    103,105
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01000101,@01000000,@00001000,@00000101
 defb    @01000000,@01000000,@00000000,@01000101
 defb    @01000000,@01011000,@00000000,@00100001
 defb    @01000010,@00000000,@10000000,@10000101
 defb    @01000000,@00010000,@00000101,@01100001
 defb    @01000010,@00100000,@00000010,@00101001
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @00000000,@00000000,@00000000,@00000000
.level22
 defb    103,105
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01100100,@00011001,@00011000,@00010001
 defb    @01000000,@00010000,@00000000,@00000001
 defb    @01100000,@00010000,@01100000,@10000001
 defb    @01010001,@10000000,@00000010,@00010101
 defb    @01001000,@01000000,@01010110,@00000001
 defb    @01000000,@00000100,@01000000,@10000001
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @00000000,@00000000,@00000000,@00000000
.level23
 defb    103,105
 defb    @00010101,@01010101,@01010101,@01010100
 defb    @01000100,@00011001,@00011000,@00010001
 defb    @01000000,@00100000,@01000000,@00000001
 defb    @01010000,@00010000,@00100001,@10000001
 defb    @01000001,@10000001,@00001010,@00100001
 defb    @01011000,@01000000,@01010010,@00000001
 defb    @01000000,@00000100,@01000000,@10000001
 defb    @00010101,@01010101,@01010101,@01010100
 defb    @00000000,@00000000,@00000000,@00000000
.level24
 defb    103,105
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01000000,@00000100,@00000000,@00000101
 defb    @01000101,@10001000,@00000001,@01100101
 defb    @01000110,@00000000,@00100100,@00010101
 defb    @01001010,@00001001,@00010100,@00000001
 defb    @01000110,@00100001,@00000000,@01010001
 defb    @01000101,@00000000,@01000101,@01101001
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @00000000,@00000000,@00000000,@00000000
.level25
 defb    103,105
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @01000000,@00000000,@00000000,@00010001
 defb    @01001000,@01011000,@00001000,@00000001
 defb    @01000000,@01100000,@10000001,@01000001
 defb    @01001000,@00000001,@01000001,@10000001
 defb    @01000110,@00000010,@01000000,@00100001
 defb    @01000101,@10000100,@00000000,@00000001
 defb    @01010101,@01010101,@01010101,@01010101
 defb    @00000000,@00000000,@00000000,@00000000

#endasm
