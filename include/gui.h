/* gui.h - simple GUI functions */

#ifndef __GUI_H__
#define __GUI_H__

#include <sys/compiler.h>
#include <malloc.h>
#include <stdio.h>
#include <graphics.h>
#include <games.h>

#define WIN_BORDER	1
#define WIN_LITE_BORDER	2
#define WIN_SHADOW	5

#define win_border	WIN_BORDER
#define win_lite_border	WIN_LITE_BORDER
#define win_shadow	WIN_SHADOW


struct gui_win {
        char    *back;
        char    x;
        char    y;
        char    width;
        char    height;
        char    flags;
};


extern void __LIB__ win_open(struct gui_win win);
extern void __LIB__ win_close(struct gui_win win);
extern void __LIB__ win_move(int x, int y, struct gui_win win);


#endif
