/* Sample for the putsprite command and gui.h
   We draw some garbage on the screen, open a window, then we put a masked arrow.
   It can be moved using arrows; ENTER closes window; ENTER again exits. 

	build with:  zcc +<platform> -lmalloc -lndos wintest.c

*/

#define AMALLOC1
#include <ctype.h>
#include <games.h>
#include <graphics.h>
#include <gui.h>
#include <malloc.h>
#include <stdio.h>

#define CURSORS

char bullet[] = { 11, 3,
    '\xE0', '\xE0',
    '\xBF', '\xA0',
    '\xE0', '\xE0' };

char arrow[] = { 8, 8,
    '\x00',
    '\x60',
    '\x70',
    '\x78',
    '\x7C',
    '\x18',
    '\x0C',
    '\x00' };

char arrow_mask[] = { 8, 8,
    '\xE0',
    '\xF0',
    '\xF8',
    '\xFC',
    '\xFE',
    '\xFE',
    '\x3E',
    '\x1E' };

char arrow_bk[] = { 8, 8,
    0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0 };

// Not the exactly the required space, but a little more..
char wbk[] = { 38, 18,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

void main()
{
    int x, y, z;
    int flag = 1;

    struct gui_win win;

    printf("%c", 12); //clear screen

    for (x = 10; x < 39; x = x + 3) //put some trash on screen
    {
        putsprite(spr_or, 2 * x, x, bullet);
        putsprite(spr_or, 2 * x - 10, x, bullet);
        putsprite(spr_or, 2 * x + 10, x, bullet);
    }
    //printf("%c",12);		//clear screen
    printf("GUI demo. Press ENTER to close.");

    win->x = 30;
    win->y = 15;
    win->flags = WIN_BORDER | WIN_SHADOW;
    win->height = 20;
    win->width = 40;
    win_open(&win);
    x = 40;
    y = 20;

    bksave(x, y, arrow_bk);
    while (flag != 2) {
        flag = 0;
#ifdef CURSORS
        switch (getk()) {
        case 'q':
            y--;
            flag = 1;
            break;
        case 'a':
            y++;
            flag = 1;
            break;
        case 'p':
            x++;
            flag = 1;
            break;
        case 'o':
            x--;
            flag = 1;
            break;
        case ' ':
            flag = 2;
        }
#else
        // Alternate controls: Kempston Joystick on Spectrum (flickers a lot), cursors on a TI calculator, etc..

        switch (joystick(1)) {
        case MOVE_UP:
            y--;
            flag = 1;
            break;
        case MOVE_DOWN:
            y++;
            flag = 1;
            break;
        case MOVE_RIGHT:
            x++;
            flag = 1;
            break;
        case MOVE_LEFT:
            x--;
            flag = 1;
            break;
        case MOVE_FIRE:
            flag = 2;
        }
#endif

        if (flag == 1) {
            bkrestore(arrow_bk);
            bksave(x, y, arrow_bk);

            clga(31, 16, 38, 18);
            getsprite(x, y, wbk);
            putsprite(spr_or, 31, 16, wbk);

            putsprite(spr_mask, x, y, arrow_mask);
            putsprite(spr_or, x, y, arrow);

            flag = 0;
        }
    }

    win_close(&win);
    while (getk() != 13)
        ;
}
