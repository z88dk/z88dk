/*
 *      Small C+ Library
 *
 *  curses.h - very minimal porting aid
 * 
 *
 *	$Id: curses.h$
 */

#ifndef __CURSES_H__
#define __CURSES_H__

#include <termcap.h>
#include <conio.h>
#include <stdlib.h>

#define FALSE 0
#define TRUE 1

#define move(x,y) gotoxy(x,y)
#define mvaddch(x,y,c) gotoxy(x,y);fputc_cons(c)

#define beep() fputc_cons(7)
#define flash() fputc_cons(7)
#define	clear() clrscr()
#define	erase() clrscr()

// Not supported or not supportable stuff

#define refresh() {}
#define doupdate() {}
#define echo() {}
#define noecho() {}
#define cbreak() {}
#define nocbreak() {}
#define raw() {}
#define noraw() {}

// #define stdscr <something>?
#define keypad(s,b) {}

// TODO: with nodelay, remap getch to getk 
#define nodelay(s,b) {}


// Simplifications/shortcuts
#define attron(a) highvideo()
#define attroff(a) normvideo()

// We'd need a trick to get a variadic macro, here
#define mvprintw(x,y,a) gotoxy(x,y);printf(a)

#ifdef getch
#undef getch
#endif

// show/hide cursor
#define curs_set(v) {(v==0)?puts_cons("\033x5"):puts_cons("\033y5");}

#define getch() getk()
#define flushinp() {while(getk()){}}

#define napms(t) msleep(t)


// --------------------------------------------------------------------------------------------------------
// vline, hline, mvvline, mvhline, border... - use single-byte characters to draw vertical/horizontal lines
// --------------------------------------------------------------------------------------------------------

__ZPROTO2(void,,curs_vline,int,ch,int,n)
#ifndef __STDC_ABI_ONLY
extern void    __LIB__     curs_vline_callee(int ch, int n) __smallc __z88dk_callee;
#define curs_vline(a,b) curs_vline_callee(a,b)
#endif

__ZPROTO2(void,,curs_hline,int,ch,int,n)
#ifndef __STDC_ABI_ONLY
extern void    __LIB__     curs_hline_callee(int ch, int n) __smallc __z88dk_callee;
#define curs_hline(a,b) curs_hline_callee(a,b)
#endif

#define vline(a,b) curs_vline(a,b)
#define hline(a,b) curs_hline(a,b)

#define mvvline(x,y,a,b) gotoxy(x,y);vline(a,b)
#define mvhline(x,y,a,b) gotoxy(x,y);hline(a,b)


// Default values for box, border, etc..
#define ACS_VLINE '|'
#define ACS_HLINE '-'
#define ACS_ULCORNER 'o'
#define ACS_URCORNER 'o'
#define ACS_BLCORNER 'o'
#define ACS_BRCORNER 'o'


// TODO: Those 2 variables should become "extern"
unsigned int COLS, LINES;

#define initscr() screensize(&COLS,&LINES)
#define endwin() {}

#ifdef border
#undef border
#endif

#define border(ls,rs,ts,bs,tl,tr,bl,br) gotoxy(0,0);fputc_cons(tl?tl:ACS_ULCORNER);hline(ts?ts:ACS_HLINE,COLS-2);fputc_cons(tr?tr:ACS_URCORNER);vline(ls?ls:ACS_VLINE,LINES-2);gotoxy(0,LINES-1);fputc_cons(bl?bl:ACS_BLCORNER);hline(bs?bs:ACS_HLINE,COLS-2);fputc_cons(bl?bl:ACS_BRCORNER);gotoxy(COLS-1,1);vline(rs?rs:ACS_VLINE,LINES-2);gotoxy(1,1)

// --------------------------------------------------------------------------------------------------------


#endif /* __CURSES_H__ */
