#ifndef __STDLIB_H__
#define __STDLIB_H__

/*
 * Lots of nice support functions here and a few defines
 * to support some functions
 *
 * $Id: stdlib.h,v 1.16 2005-08-23 00:20:08 aralbrec Exp $
 */

#include <sys/types.h>

extern __LIB__ abs(int);
extern long __LIB__ labs(long);
extern __LIB__ atexit();
extern __LIB__ __FASTCALL__ exit(int);  /* Fast call stops pushing on stack*/

/* Exit status can be defined for all machines */
#define EXIT_FAILURE     1     /* Failed */
#define EXIT_SUCCESS     0     /* Succeeded */


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
#ifndef __FCNTL_H__
extern __LIB__ mkdir(char *, int mode);
extern char __LIB__ *getcwd(char *buf, size_t maxlen); 
#endif

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


extern int __LIB__  getopt (int, char **, char *);
extern   char *optarg;                  /* getopt(3) external variables */
extern   int opterr;
extern   int optind;
extern   int optopt;
extern   int optreset;


extern void __LIB__ *l_bsearch(void *key, void *base, unsigned int n, void *cmp);
extern void __LIB__ l_qsort(void *base, unsigned int size, void *cmp);
/* void *cmp  <=>  char (*cmp)(const void *key, const void *datum) */


/*
 *	Okay..include in malloc.h to be standard..
 */
#include <malloc.h>

#endif
