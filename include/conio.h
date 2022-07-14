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
 *	$Id: conio.h $
 */

#ifndef __CONIO_H__
#define __CONIO_H__

// this is used by getch, putch and ungetch.
#include <sys/compiler.h>
#include <stdio.h>
#include <stdlib.h>
//#include <graphics.h>
#include <dos.h>
#include <X11/Xz88dk.h>


#define MAXCOLORS       15
enum colors { BLACK, BLUE, GREEN, CYAN, RED, MAGENTA, BROWN, LIGHTGRAY, DARKGRAY,
              LIGHTBLUE, LIGHTGREEN, LIGHTCYAN, LIGHTRED, LIGHTMAGENTA, YELLOW, WHITE };



#ifdef __CONIO_VT100
// Much faster shortcut passing the colors in vt-ansi mode (equivalent to a "set text rendition" ESC sequence)
extern void   __LIB__      vtrendition(unsigned int attribute) __z88dk_fastcall;

// Color translation table
static int PCDOS_COLORS[]={0,4,2,6,1,5,1,7,4,6,2,6,1,5,3,7};

// QUICK C syntax
#define settextcolor(a)    vtrendition(PCDOS_COLORS[a]+30)

// TURBO C syntax
#define textcolor(a)       vtrendition(PCDOS_COLORS[a]+30)
#define textbackground(a)  vtrendition(PCDOS_COLORS[a]+40)

#define textattr(a)		   vtrendition(PCDOS_COLORS[a&0xF]+30); vtrendition(PCDOS_COLORS[a>>4]+40)

#define highvideo()        vtrendition(1)
#define lowvideo()         vtrendition(2)
#define normvideo()        vtrendition(0)
#define clreol()           printf("\033[K")

// Useless, DL is not fully implemented in the VT-ansi engine
//#define delline()	       printf("\033[M")

#define clrscr()           fputc_cons(12)
#else
// Definitions for VT52/generic console, these set common variables for both VT100 and
// VT52, but may drag in more code than intended.

extern void __LIB__        textcolor(int c) __z88dk_fastcall;
extern void __LIB__        textbackground(int c) __z88dk_fastcall;
#define clrscr()           fputc_cons(12)
#endif



extern int     __LIB__     wherex (void);
extern int     __LIB__     wherey (void);
extern void    __LIB__     gotoxy(unsigned int x, unsigned int y) __smallc;
extern void    __LIB__     gotoxy_callee(unsigned int x, unsigned int y) __smallc __z88dk_callee;

extern void    __LIB__     screensize(unsigned int *x, unsigned int *y) __smallc;
extern void    __LIB__     screensize_callee(unsigned int *x, unsigned int *y) __smallc __z88dk_callee;

#define gotoxy(a,b) gotoxy_callee(a,b)
#define screensize(a,b) screensize_callee(a,b)


/* The leading underscores are for compatibility with the 
 * Digital Mars library */

extern int __LIB__ cprintf(const char *fmt,...) __vasmallc;
#define _cprintf cprintf
extern void __LIB__ cputs(const char *message);
#define _cputs cputs
extern void __LIB__ cgets(char *dest);
#define _cgets cgets

#define cscanf scanf
#define _cscanf scanf

/* Reads a character directly from the console, (with echo ?) */
#define getche() getch()               // not sure about this one...
#define _getche() getch()                // not sure about this one...
// Direct output to console
#define putch(a) fputc_cons(a)
#define _putch(a) fputc_cons(a)

// can't be fixed easily.. i.e. the simplified gets won't work
//#define ungetch(bp)  ungetc(bp,stdin)  // this one doesn't work
//#define _ungetch(bp)  ungetc(bp,stdin)  // this one doesn't work

#define random(a) (rand()%(a))

extern int __LIB__ kbhit(void);
extern int __LIB__ getch(void);

// Get the character that is on screen at the specified location
extern int __LIB__ cvpeek(int x, int y) __smallc;


// Get the character that is on screen at the specified location (no charset
// translations will be made)
extern int __LIB__ cvpeekr(int x, int y) __smallc;

// Set the border colour, may not be implemented on all ports
extern int __LIB__ bordercolor(int c) __z88dk_fastcall;

// Missing functions, not implemented
//extern int  __LIB__ movetext (int _left, int _top, int _right, int _bottom, int _destleft, int _desttop);
//extern int  __LIB__ gettext (int left, int top, int right, int bottom, void *destin);


// CC65 compatibility
#define cgetc() getch()
#define cputc(a) fputc_cons(a)


#endif /* _CONIO_H */
