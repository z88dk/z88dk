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

#define move(x,y) gotoxy(x,y)
#define mvaddch(x,y,c) gotoxy(x,y);fputc_cons(c)
#define beep() fputc_cons(7)
#define flash() fputc_cons(7)

// We'd need a trick to get a variadic macro, here
#define mvprintw(x,y,a) gotoxy(x,y);printf(a)

#ifdef getch
#undef getch
#endif

// show/hide cursor
#define curs_set(v) v?puts_cons("\033x5"):puts_cons("\033y5")

#define getch() getk()


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

unsigned int curs_w, curs_h;

#ifdef border
#undef border
#endif

#define border(ls,rs,ts,bs,tl,tr,bl,br) screensize(&curs_w,&curs_h);gotoxy(0,0);fputc_cons(tl?tl:ACS_ULCORNER);hline(ts?ts:ACS_HLINE,curs_w-2);fputc_cons(tr?tr:ACS_URCORNER);vline(ls?ls:ACS_VLINE,curs_h-2);gotoxy(0,curs_h-1);fputc_cons(bl?bl:ACS_BLCORNER);hline(bs?bs:ACS_HLINE,curs_w-2);fputc_cons(bl?bl:ACS_BRCORNER);gotoxy(curs_w-1,1);vline(rs?rs:ACS_VLINE,curs_h-2);gotoxy(1,1)

// --------------------------------------------------------------------------------------------------------


#endif /* __CURSES_H__ */
