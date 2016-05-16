/*
 * BDS C Compatibility
 * $Id: bdscio.h,v 1.9 2016-05-16 20:08:26 dom Exp $
 */

#ifndef __BDSCIO_H__
#define __BDSCIO_H__

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <ctype.h>
#include <setjmp.h>
#include <string.h>
#include <ctype.h>


/**********************************************************************
	General purpose Symbolic constants:
***********************************************************************/

#define BASE 0		/* Base of CP/M system RAM (0 or 0x4200)  */

//#define NULL 0		/* Used by some functions to indicate zilch */

//#define EOF -1		/* Physical EOF returned by low level I/O functions */

#define ERROR -1	/* General "on error" return value */

#define OK 0		/* General purpose "no error" return value */

#define CPMEOF 0x1a	/* CP/M End-of-text-file marker (sometimes!)  */

#define SECSIZ 128	/* Physical sector size for CP/M r/w calls */

//#define MAXLINE 132	/* Longest line of input expected from the console */
#define MAXLINE 255	/* Longest line of input expected from the console */



#define NSECTS 8	/* Number of sectors to buffer up in ram */

// BUFSIZ has to do with an old fashioned fopen version: please hand-adjust the code
//#define BUFSIZ (NSECTS * SECSIZ + 6 )	/* Don't touch this */


#define STDIN stdin
#define STDOUT stdout
#define STDERR stderr


/* FOPEN conversion note
 * 
 * BDS C features a non-standard file access library
 * 'buffers' were defined in place of file handles; the easiest way to port it
 * is to change the "char buf1[BUFSIZ]" into "FILE *buf1" declarations
 * 
 * The fopen calls can be changed, in example, follows:
 *       //if(fopen(argv[1],buf1)==ERROR)
 *       if(buf1=fopen(argv[1],"r"))
 * choose "r" or "w" properly.
 * 
*/

#define fgets(a,b) fgets(a,MAXLINE,b)

#define unlink(a) remove(a)
#define fefc(a) fclose(a)

/* The functions in 'dio.h' are not necessary with z88dk */

#define dioinit(a,b) {}
#define dioflush() 0

//#define exit() exit(0)


#define FALSE 0
#define TRUE 1

#define max(a,b) (a>b?a:b)
#define min(a,b) (a<b?a:b)

#define out(a) puts_cons(a)
#define eqs(a,b) (!strcmp(a,b)==0)

#define error(a) puts_cons(a);exit(1)

#define movmem(a,b,c) memcpy(b,a,c)

#define alloc(a) malloc(a)
#undef sbrk
#define sbrk(a) malloc(a)?asm("\n"):-1

#define isalpnum(a) isalnum(a)
#define toupper(a) strupr(a)

#define biosh(a,b) bios(a,b,0)


/*******   Some console (video) terminal characteristics:   *******/

#define TWIDTH	80	/* # of columns	*/

#define TLENGTH	24	/* # of lines	*/

#define CSTAT	0	/* Console status port	*/

#define CDATA 1		/* Console data port	*/

#define CIMASK	0x40	/* Console input data ready mask   */

#define COMASK	0x80	/* Console output data ready mask  */

#define CAHI	1	/* True if console status active high	*/

#define CRESET	0	/* True if status port needs to be reset  */

#define CRESETVAL 0	/* If CRESET is true, this is the value to send	*/

//#define CLEARS	"\033E"	/* String to clear screen on console	*/
#define CLEARS	"\014"	/* String to clear screen on console	*/

#define INTOREV	"\033p"	/* String to switch console into reverse video	*/

#define OUTAREV "\033q"	/* String to switch console OUT of reverse video  */

#define CURSOROFF "\033x5"	/* String to turn cursor off	*/

#define CURSORON "\033y5"	/* String to turn cursor on	*/

#define ESC	'\033'	/* Standard ASCII 'escape' character	*/


#endif

