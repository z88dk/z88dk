/*
 *      Small C+ Library
 *
 *  conio.h - old apps compatibility
 * 
 *	This helps expecially with the kbhit() instruction
 *	it exists on many old compilers; the mingw port has it
 *	on "conio.h", so here it is !
 *
 *      stefano - 18/3/2004
 *
 *	$Id: conio.h,v 1.10 2013-06-20 08:25:45 stefano Exp $
 */

#ifndef __CONIO_H__
#define __CONIO_H__

// this is used by getch, putch and ungetch.
//#include <sys/compiler.h>
#include <stdio.h>
#include <stdlib.h>
//#include <graphics.h>
#include <dos.h>
#include <X11/Xz88dk.h>

#define MAXCOLORS       15
enum colors { BLACK, BLUE, GREEN, CYAN, RED, MAGENTA, BROWN, LIGHTGRAY, DARKGRAY,
              LIGHTBLUE, LIGHTGREEN, LIGHTCYAN, LIGHTRED, LIGHTMAGENTA, YELLOW, WHITE };

// Color translation table
int PCDOS_COLORS[]={0,4,2,6,1,5,1,7,4,6,2,6,1,5,3,7};
// QUICK C syntax
#define settextcolor(a)	printf("\033[%um",PCDOS_COLORS[a]+30)
// TURBO C syntax
#define textcolor(a)	printf("\033[%um",PCDOS_COLORS[a]+30)
#define textbackground(a)	printf("\033[%um",PCDOS_COLORS[a]+40)
#define textattr(a)	printf("\033[%um\033[%um",PCDOS_COLORS[a&0xF]+30,PCDOS_COLORS[a>>4]+40)
#define highvideo()	printf("\033[1m")
#define lowvideo()	printf("\033[2m")
#define normvideo()	printf("\033[m")
#define delline()	printf("\033[m")
//#define clrscr() textattr(7);fputc_cons(12)
/* In this way we can do some sort of color and setcolor functions redefinition */
#define clrscr() printf("\033[%um\033[%um%c",30,47,12)
#define clreol() printf("\033[K")

/* The leading underscores are for compatibility with the 
 * Digital Mars library */

#define cprintf printf
#define _cprintf printf
#define cputs puts_cons
#define _cputs puts_cons
#define cgets gets
#define _cgets gets
#define cscanf scanf
#define _cscanf scanf

#define gotoxy(a,b)     printf("\033[%u;%uH",b,a)
#define _gotoxy(a,b)     printf("\033[%u;%uH",b,a)

/* Reads a character directly from the console, (without echo?) */
#define getch()  fgetc_cons()
#define _getch()  fgetc_cons()
/* Reads a character directly from the console, (with echo ?) */
#define getche() fgetc_cons()               // not sure about this one...
#define _getche() fgetc_cons()                // not sure about this one...
// Direct output to console
#define putch(a) fputc_cons()
#define _putch(a) fputc_cons()

// can't be fixed easily.. i.e. the simplified gets won't work
//#define ungetch(bp)  ungetc(bp,stdin)  // this one doesn't work
//#define _ungetch(bp)  ungetc(bp,stdin)  // this one doesn't work

#ifndef kbhit
#define kbhit() (getk() ? 1 : 0)
#define _kbhit() (getk() ? 1 : 0)
#endif

#define random(a) rand()%a


// Missing functions, not implemented
//extern int  __LIB__ movetext (int _left, int _top, int _right, int _bottom, int _destleft, int _desttop);
//extern int  __LIB__ wherex (void);
//extern int  __LIB__ wherey (void);
//extern int  __LIB__ gettext (int left, int top, int right, int bottom, void *destin);


#endif /* _CONIO_H */
