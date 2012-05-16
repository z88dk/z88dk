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
 *	$Id: conio.h,v 1.5 2012-05-16 16:59:56 stefano Exp $
 */

#ifndef __CONIO_H__
#define __CONIO_H__

// this is used by getch, putch and ungetch.
//#include <sys/compiler.h>
#include <stdio.h>
#include <stdlib.h>
#include <dos.h>

// THIS ONE IS TERRIFIC !
#define elseif else if

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

#define gotoxy(a,b)     printf("%c[%u;%uH",27,b-1,a-1)


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


#endif /* _CONIO_H */
