#ifndef __STDLIB_H__
#define __STDLIB_H__

/*
 * Lots of nice support functions here and a few defines
 * to support some functions
 *
 * $Id: stdlib.h,v 1.12 2002-11-20 19:50:51 dom Exp $
 */

extern __LIB__ abs(int);
extern long __LIB__ labs(long);
extern __LIB__ atexit();
extern __LIB__ __FASTCALL__ exit(int);  /* Fast call stops pushing on stack*/


extern long __LIB__ strtol(char *,char **,int);
extern unsigned long __LIB__ strtoul(char *,char **,int);

#ifndef USEATOISTRTOL
extern int __LIB__ atoi(char *);
#else
#define atoi(s) (int)strtol((s),(char **)NULL,10)
#endif

#ifdef __Z88__
extern long __LIB__ atol(char *);
#else
#define atol(s) strtol((s),(char **)NULL,10)
#endif

#if 0
#ifndef _HAVE_ATOF_
#define _HAVE_ATOF_
extern double __LIB__ atof(char *);
#endif
#endif


/* random number things */

#define RAND_MAX 32767

extern int __LIB__ rand(void);
extern void __LIB__ srand(int);

extern __LIB__ sleep(int);


/* Non standard stdlib.h defs (mode is ignored)*/
extern __LIB__ mkdir(char *, int mode);
extern char __LIB__ *getcwd(char *buf, int maxlen); 

#ifdef __Z88__
extern __LIB__ csleep(int);  /* Very non standard! sleep for centisecs! (z88)*/
#endif

/* abort is a macro to exit with RC_Err - only for apps */

#define abort() exit(15)

/* itoa is used by the Rex6000 port, but anyone could use it */
extern char __LIB__ *itoa(char *buf, int num);
/* Not sure why Rex has it's own rand() routine using different seed? */
#define randRex() rand()


#ifdef __Z88__
/* Define a system() function - only valid for z88 shell */
extern int system(char *text);
#endif


extern int __LIB__  getopt (int, char **, const char *);
extern   char *optarg;                  /* getopt(3) external variables */
extern   int opterr;
extern   int optind;
extern   int optopt;
extern   int optreset;



/*
 *	Okay..include in malloc.h to be standard..
 */
#include <malloc.h>

#endif
