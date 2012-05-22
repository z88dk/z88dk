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
 *	$Id: conio.h,v 1.6 2012-05-22 19:54:36 stefano Exp $
 */

#ifndef __CONIO_H__
#define __CONIO_H__

// this is used by getch, putch and ungetch.
//#include <sys/compiler.h>
#include <stdio.h>
#include <stdlib.h>
#include <dos.h>


#define    BLACK         0
#define    BLUE          1
#define    GREEN         2
#define    CYAN          3
#define    RED           4
#define    MAGENTA       5
#define    BROWN         6
#define    LIGHTGRAY     7
#define    DARKGRAY      8
#define    LIGHTBLUE     9
#define    LIGHTGREEN   10
#define    LIGHTCYAN    11
#define    LIGHTRED     12
#define    LIGHTMAGENTA 13
#define    YELLOW       14
#define    WHITE        15
#define    BLINK        13


// Color translation table
int PCDOS_COLORS[]={0,4,2,6,1,5,1,7,4,6,2,6,1,5,3,7};
// QUICK C syntax
#define settextcolor(a)	printf("%c[%um",27,PCDOS_COLORS[a]+30)
// TURBO C syntax
#define textcolor(a)	printf("%c[%um",27,PCDOS_COLORS[a]+30)
#define textbackground(a)	printf("%c[%um",27,PCDOS_COLORS[a]+40)
#define textattr(a)	printf("%c[%um%c[%um",27,PCDOS_COLORS[a&0xF]+30,27,PCDOS_COLORS[a>>4]+40)
#define highvideo()	printf("%c[1m",27);
#define lowvideo()	printf("%c[2m",27);
#define normvideo()	printf("%c[m",27);
#define delline()	printf("%c[m",27);
#define clrscr() textattr(7);fputc_cons(12)
#define clreol() printf("%c[K",27)

#define cprintf printf
#define cputs puts_cons
#define cgets gets
#define cscanf scanf

#define gotoxy(a,b)     printf("%c[%u;%uH",27,b,a)


/* Reads a character directly from the console, without echo. */
#define getch()  fgetc_cons()
/* Reads a character directly from the console, without echo. */
#define getche() fputc_cons(fgetc_cons())                // not sure about this one...
// Direct output to console
#define putch(a) fputc_cons(a)
//#define putch(bp,fp) fputc(bp,fp)
// #define ungetch(bp)  ungetc(bp,stdout)  // this one doesn't work

#ifndef kbhit
#define kbhit() (getk() ? 1 : 0)
#endif

#define random(a) rand()%a


// Missing functions, not yet implemented
//extern int  __LIB__ movetext (int _left, int _top, int _right, int _bottom, int _destleft, int _desttop);
//extern int  __LIB__ wherex (void);
//extern int  __LIB__ wherey (void);
//extern int  __LIB__ gettext (int left, int top, int right, int bottom, void *destin);

#define	getpixel(a,b)	point(a,b)
#define	putpixel(a,b,c)	(c ? plot(a,b):unplot(a,b))
#define getmaxcolor()	1
#define closegraph()		clrscr()
#define initgraph(a,b,c)	clrscr()
#define DETECT	0
#define	grOk	0
/*
#define graphresult()	0
#define clearviewport()	clrscr()
*/
#define	outtextxy(a,b,c) {}
#define	rectangle(a,b,c,d) drawb(a,b,c-a,d-b)
#define	ellipse(a,b,c,d,e,f) {}
#define	circle(a,b,c) circle(a,b,c,1)
#define	line(a,b,c,d) draw(a,b,c,d)
#define	sector(a,b,c,d,e,f) {}
#define drawpoly(a,b) {}

#endif /* _CONIO_H */
