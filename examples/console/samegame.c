/* C version of samegame using gencon for maximum portability */


#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <ctype.h>
#include <games.h>
#include <sys/ioctl.h>

#pragma define CRT_ENABLE_STDIO=0
#pragma define CLIB_EXIT_STACK_SIZE=0


#ifdef __SV8000__
#pragma redirect CRT_FONT=_font_8x8_bbc_system
#define USE_UDGS 1
#define JOYSTICK_NUM 1
#define ARENA_W 20
#define ARENA_H 10
#define X_OFFSET 6
#define Y_OFFSET 0
#define SCORE_ROW 11
#define SWITCH_MODE 1
#endif

#ifdef __SPECTRUM__
#define USE_COLOUR 1
#define USE_BIGSPRITES 1
#define ARENA_W 16
#define ARENA_H 10
#define X_OFFSET 0
#define Y_OFFSET 0
#define SCORE_ROW 22
#endif

#ifdef __SAM__
#define USE_COLOUR 1
#define USE_BIGSPRITES 1
#define ARENA_W 16
#define ARENA_H 10
#define X_OFFSET 0
#define Y_OFFSET 0
#define SCORE_ROW 22
#define SWITCH_MODE 4
#endif


#ifndef ARENA_W
#define USE_UDGS
#define ARENA_W 20
#define ARENA_H 10
#define X_OFFSET 6
#define Y_OFFSET 5
#define SCORE_ROW 20
#endif

#ifndef TEXT_COLOUR
#define TEXT_COLOUR 0
#endif


#define K_UP 'Q'
#define K_DOWN 'A'
#define K_LEFT 'O'
#define K_RIGHT 'P'
#define K_POP ' '
#define K_RESET 'H'

static uint8_t arena[ARENA_H][ARENA_W];
static uint8_t oarena[ARENA_H][ARENA_W];
static uint8_t playing;
static int     cx;
static int     cy;
static int     selected;
static int     score;

#if USE_BIGSPRITES
static uint8_t udgs[] = {
	// ball tl
	0b00000000,
	0b00000011,
	0b00001101,
	0b00010001,
	0b00111011,
	0b00010001,
	0b01010101,
	0b00100101,

	// ball tr
	0b00000000,
	0b11000000,
	0b01110000,
	0b11111000,
	0b01111100,
	0b10111100,
	0b11111110,
	0b11111110,

	// ball bl
	0b01001101,
	0b00010011,
	0b00100101,
	0b00010011,
	0b00000101,
	0b00001100,
	0b00000011,
	0b00000000,

	// ball br
	0b01111110,
	0b11001110,
	0b11010100,
	0b10111100,
	0b11111000,
	0b11110000,
	0b11000000,
	0b00000000,

	// mini tl
	0b00000000,
	0b00000000,
	0b00000000,
	0b00000011,
	0b00000100,
	0b00001001,
	0b00011010,
	0b00010101,

	// mini tr
	0b00000000,
	0b00000000,
	0b00000000,
	0b11000000,
	0b11100000,
	0b11110000,
	0b01111000,
	0b11111000,

	// mini bl
	0b00011010,
	0b00010100,
	0b00001010,
	0b00000101,
	0b00000011,
	0b00000000,
	0b00000000,
	0b00000000,

	// mini br
	0b01111000,
	0b01101000,
	0b01110000,
	0b01100000,
	0b11000000,
	0b00000000,
	0b00000000,
	0b00000000
};
#else
static uint8_t udgs[] = {
    0b00000000,
    0b00111100,
    0b01000010,
    0b01000010,
    0b01000010,
    0b01000010,
    0b00111100,
    0b00000000,

    0b00000000,
    0b01111110,
    0b01000010,
    0b01000010,
    0b01000010,
    0b01000010,
    0b01111110,
    0b00000000,

    0b00000000,
    0b00011000,
    0b00100100,
    0b00100100,
    0b01000010,
    0b01000010,
    0b01111110,
    0b00000000,

    0b00000000,
    0b00000000,
    0b00010000,
    0b00010000,
    0b01111100,
    0b00010000,
    0b00010000,
    0b00000000,

    0b00000000,
    0b00000000,
    0b00011000,
    0b00100100,
    0b00100100,
    0b00011000,
    0b00000000,
    0b00000000,

    0b00000000,
    0b00000000,
    0b00111100,
    0b00100100,
    0b00100100,
    0b00111100,
    0b00000000,
    0b00000000,

    0b00000000,
    0b00000000,
    0b00011000,
    0b00100100,
    0b00100100,
    0b00111100,
    0b00000000,
    0b00000000,

    0b00000000,
    0b00000000,
    0b00000000,
    0b00010000,
    0b00111000,
    0b00010000,
    0b00000000,
    0b00000000
};


#endif

static void handle_keys();
static void initialise_level();
static void copy_columns(int d, int s);
static void moved();
static void checkover();
static void crunchx();
static void drawboard();
static void draw_arena();
static void crunchx();
static void crunchy();
static void print_sprite(int y, int x, uint8_t spr);
static void highlight(int y, int x, uint8_t val);


int main()
{
  int   mode;
  void *param = &udgs;
  console_ioctl(IOCTL_GENCON_SET_UDGS, &param);


#ifdef SWITCH_MODE
   mode = SWITCH_MODE;
   console_ioctl(IOCTL_GENCON_SET_MODE, &mode);
#endif
  // switch zx clones into 32 column mode
  putch(1);
  putch(32);


    while ( 1 ) {
        initialise_level();
        playing = 1;
        score = 0;
        clrscr();
        moved();
        while ( playing ) {
            handle_keys();         
        }
    }
}

static void reset()
{
    uint8_t *ptr = &arena[0][0];
    for ( int i = 0; i < ARENA_W * ARENA_H; i++ ) {
        *ptr++ &= 0x7f;
    }
}

static void moved()
{
    reset();
    selected = 0;
    oarena[cy][cx] = 0xff;
    highlight(cy, cx, arena[cy][cx]);
    if ( selected < 2 ) {
        reset();
    }
    drawboard();
}

#ifndef JOYSTICK_NUM
static uint8_t readkeys()
{
    switch ( toupper(getk()) ) {
    case K_UP:
        return MOVE_UP;
    case K_DOWN:
        return MOVE_DOWN;
    case K_LEFT:
        return MOVE_LEFT;
    case K_RIGHT:
        return MOVE_RIGHT;
    case K_POP:
        return MOVE_FIRE1;
    }
    return 0;
}
#endif

static void handle_keys() 
{
#ifdef JOYSTICK_NUM
    uint8_t joy = joystick(JOYSTICK_NUM);
#else
    uint8_t joy = readkeys();
#endif
    oarena[cy][cx] = 0xff;
    if ( joy & MOVE_LEFT ) {
        if ( cx > 0 ) {
            --cx;
            moved();
        }
    } else if ( joy & MOVE_RIGHT ) {
        if ( cx < ARENA_W - 1 ) {
            ++cx;
            moved();
        }
    } else if ( joy & MOVE_DOWN ) {
        if ( cy < ARENA_H - 1 ) {
            ++cy;
            moved();
        }
    } else if ( joy & MOVE_UP ) {
        if ( cy > 0 ) {
            --cy;
            moved();
        }
    } else if ( joy & MOVE_FIRE ) {
        if ( selected > 1 ) {
            score += (selected -2 ) * (selected -2);
            crunchy();
            crunchx();
            moved();
            checkover();
        }
    }
}

static void highlight(int y, int x, uint8_t val)
{
    uint8_t nval = arena[y][x];

    if ( nval != val ||  nval == 0 || nval & 128 ) {
        return;
    }
    arena[y][x] |= 128;
    ++selected;;
    if ( x > 0 ) highlight(y, x - 1, nval);
    if ( x < ARENA_W - 1 ) highlight(y, x + 1, nval);
    if ( y > 0 ) highlight(y - 1, x, nval);
    if ( y < ARENA_H - 1 ) highlight(y + 1, x, nval);
}

static void checkover() 
{
    for ( int y = 0; y < ARENA_H; y++ ) {
        for ( int x = 0; x < ARENA_W - 1; x++ ) {
            if ( arena[y][x] && ( arena[y][x] == arena[y][x+1] ||
                 arena[y][x] == arena[y+1][x] ) ) {
                 return;
            }
        }
    }
    playing = 0;
    gotoxy(X_OFFSET + (ARENA_W / 2) - 4, Y_OFFSET + (ARENA_H / 2));
    cputs("GAME OVER!!");
#ifdef JOYSTICK_NUM
    while ( joystick(JOYSTICK_NUM) == 0 ) 
#else
    while ( getk() == 0 ) 
#endif
        ;
}

static void initialise_level() 
{
    uint8_t *ptr = &arena[0][0];

    for ( int i = 0; i < ARENA_H * ARENA_W; i++ ) {
       *ptr++ = (rand() & 3) + 1;;
    }
    memset(oarena,0xff,ARENA_W * ARENA_H);
}



// Crunch in the y direction
static void crunchy() 
{
    for ( int x = ARENA_W - 1; x >= 0; --x ) {
       for ( int y = ARENA_H - 1; y >= 0 ; -- y) {
again:
            if ( arena[y][x] & 128 ) {
                // Marked for removal
                if ( y != 0 ) {
                    for ( int y2 = y; y2 > 0; --y2 ) {
                        arena[y2][x] = arena[y2-1][x];
                        arena[y2-1][x] = 0;
                    }
                    goto again;
                } else {
                    arena[y][x] = 0;
                }
            }
       }
    }
}

static void copy_columns(int dx, int sx)
{
    for ( int x = sx, offs = 0; x < ARENA_W; x++,offs++ ) {
        for ( int y = 0; y < ARENA_H; y++ ) {
            arena[y][dx+offs] = arena[y][sx+offs];
            arena[y][sx+offs]= 0;
        }
    }
}

// Compress in the X direction, we only look at the bottom row
static void crunchx()
{
    uint8_t *ptr = &arena[ARENA_H-1][0];
    for ( int x = 0; x < ARENA_W; x++ ) {
        if ( ptr[x] == 0 ) {
            for ( int x2 = x+1; x2 < ARENA_W; x2++ ) {
                if ( ptr[x2] ) {
                     // We've got a non-zero, copy from this column
                     copy_columns(x, x2);
                     break;
                }
            }
        } 
    }
}

static void prnum(int score)
{
   int i = score / 10;
   if ( i ) {
       prnum(i);
   }
   putch((score % 10)+ '0');
}

static void drawboard() 
{
    draw_arena();
#ifdef USE_COLOUR
    textcolor(TEXT_COLOUR);
#endif
    gotoxy(0,SCORE_ROW); cputs("Score: ");

    prnum(score);
}

static void draw_arena() 
{
    for ( int y = 0; y < ARENA_H; y++ ) {
        for ( int x = 0; x < ARENA_W; x++ ) {
            if ( arena[y][x] != oarena[y][x] ) {
                print_sprite(y, x, arena[y][x]);
                oarena[y][x] = arena[y][x];
            }
        }
    }
}

#ifdef USE_BIGSPRITES
static void print_sprite(int y, int x, uint8_t spr)
{
    uint8_t udg_num;

#ifdef USE_COLOUR
    udg_num = spr & 128 ? 132 : 128;
    textcolor(spr & 3);
#else
    // We have no colour, use different UDGs
    udg_num = (spr & 3) * 4;
    if ( spr & 128 ) udg_num *= 2;
    udg_num += 128;
#endif
    if ( y == cy && x == cx ) {
       putch(27); putch('p');
    }
    y *= 2;
    x *= 2;
    if ( spr ) {
        gotoxy(x,y); putch(udg_num++); putch(udg_num++);
        gotoxy(x,y+1); putch(udg_num++); putch(udg_num);
    } else {
        gotoxy(x,y); putch(' '); putch(' ');
        gotoxy(x,y+1); putch(' '); putch(' ');
    }
    putch(27); putch('q');
}
#else
#ifdef USE_UDGS
static uint8_t chars[] = { ' ', 128, 129, 130, 131 };
#else
static uint8_t chars[] = { ' ', '0', '1', '2', '3', '4' };
#endif
static void print_sprite(int y, int x, uint8_t spr)
{
    uint8_t char_num = chars[( spr & 7)];

    if ( spr & 128 ) {
        char_num += 4;
    }
    if ( x == cx && y == cy ) {
       putch(27); putch('p');
    }
    gotoxy(x + X_OFFSET,y + Y_OFFSET); putch(char_num);
    putch(27); putch('q');
}
#endif
