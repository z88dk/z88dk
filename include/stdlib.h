#ifndef __STDLIB_H__
#define __STDLIB_H__

/*
 * Lots of nice support functions here and a few defines
 * to support some functions
 *
 * $Id: stdlib.h,v 1.35 2008-06-30 20:45:52 aralbrec Exp $
 */

#include <sys/types.h>


/**********************************/
/* STANDARD K&R LIBRARY FUNCTIONS */
/**********************************/


//////////////////////////////////
//// String <-> Number Conversions
//////////////////////////////////

// double atof(char *s);                    /* check math library for availability */

extern int  __LIB__ __FASTCALL__  atoi(char *s);
extern long __LIB__ __FASTCALL__  atol(char *s);

extern int  __LIB__               itoa(int n, char *s, uchar radix);
extern int  __LIB__ __CALLEE__    itoa_callee(int n, char *s, uchar radix);
extern int  __LIB__               utoa(uint n, char *s, uchar radix);
extern int  __LIB__ __CALLEE__    utoa_callee(uint n, char *s, uchar radix);
extern int  __LIB__               ltoa(long n, char *s, uchar radix);
extern int  __LIB__ __CALLEE__    ltoa_callee(long n, char *s, uchar radix);
extern int  __LIB__               ultoa(unsigned long n, char *s, uchar radix);
extern int  __LIB__ __CALLEE__    ultoa_callee(unsigned long n, char *s, uchar radix);

#define itoa(a,b,c)  itoa_callee(a,b,c)
#define utoa(a,b,c)  utoa_callee(a,b,c)
#define ltoa(a,b,c)  ltoa_callee(a,b,c)
#define ultoa(a,b,c) ultoa_callee(a,b,c)

// double strtod(char *s, char **endp);     /* check math library for availability */

extern long          __LIB__               strtol(char *s, char **endp, int base);
extern long          __LIB__ __CALLEE__    strtol_callee(char *s, char **endp, int base);
extern unsigned long __LIB__               strtoul(char *s, char **endp, int base);

#define strtol(a,b,c)  strtol_callee(a,b,c)
#define strtoul(a,b,c) strtol_callee(a,b,c)

///////////////////
//// Random Numbers
///////////////////

// The pseudo-random number generator requires a 16-bit seed.
// The seed is present in the crt0 for a given platform, but if
// you wish to define your own then do it in whatever way you wish
// and add the following pragma to your source code:
// #pragma output HAVESEED

extern int std_seed;


#define RAND_MAX    32767
#define M_SRAND(a)  asm("ld\thl,"#a"\nld\t(_std_seed),hl\n");

extern int  __LIB__              rand(void);
extern void __LIB__              randomize(void);
extern void __LIB__ __FASTCALL__ srand(unsigned int seed);

// Not sure why Rex has it's own rand() routine using different seed?

#define randRex() rand()

//////////////////////
//// Memory Allocation
//////////////////////

// Before using the malloc library you must initialize the heap -- see malloc.h for details
// calloc(), malloc(), realloc(), free(), mallinit(), mallinfo(), sbrk()

#include <malloc.h>

///////////////////////
//// System Environment
///////////////////////

// Z88: abort is a macro to exit with RC_Err - only for apps

#define abort() exit(15)

#define EXIT_FAILURE   1
#define EXIT_SUCCESS   0

extern void __LIB__ __FASTCALL__ exit(int status);
extern int  __LIB__ __FASTCALL__ atexit(void *fcn);

// int system(char *s);                     /* might be implemented in target's library but doubtful */
// char *getenv(char *name);                /* might be implemented in target's library but doubtful */

extern void __LIB__  sleep(int);
extern int  __LIB__  getopt (int, char **, char *);
extern   char *optarg;                      /* getopt(3) external variables */
extern   int opterr;
extern   int optind;
extern   int optopt;
extern   int optreset;

#ifdef __Z88__
extern int system(char *text);              /* should this be in the z88 library? */
#endif

//////////////////
//// Search & Sort
//////////////////

// These are not quite ansi (array items are assumed to be two bytes in length).  Also look
// into the heapsort implementation in the abstract data types library (adt.h) as a stack-
// usage-free alternative to quicksort.
//
// void *cmp == char (*cmp)(void *key, void *datum);

extern void __LIB__            *l_bsearch(void *key, void *base, unsigned int n, void *cmp);
extern void __LIB__ __CALLEE__ *l_bsearch_callee(void *key, void *base, unsigned int n, void *cmp);
extern void __LIB__            l_qsort(void *base, unsigned int size, void *cmp);
extern void __LIB__ __CALLEE__ l_qsort_callee(void *base, unsigned int size, void *cmp);

#define l_bsearch(a,b,c,d) l_bsearch_callee(a,b,c,d)
#define l_qsort(a,b,c) l_qsort_callee(a,b,c)

//////////////////////////
//// Misc Number Functions
//////////////////////////

extern int  __LIB__ __FASTCALL__ abs(int n);
extern long __LIB__              labs(long n);
extern long __LIB__ __CALLEE__   labs_callee(long n);

#define labs(a) labs_callee(a)

extern uint __LIB__ __FASTCALL__ isqrt(uint n);


/******************************************************/
/* NON-STANDARD BUT GENERALLY USEFUL FOR Z80 MACHINES */
/******************************************************/


//////////////
//// I/O PORTS
//////////////

// For accessing 16-bit i/o ports from C.  The macros can be
// used to inline code if the parameters resolve to constants.

extern unsigned int  __LIB__ __FASTCALL__ inp(unsigned int port);
extern void          __LIB__              outp(unsigned int port, unsigned char byte);
extern void          __LIB__ __CALLEE__   outp_callee(unsigned int port, unsigned char byte);

#define outp(a,b) outp_callee(a,b)

#define M_INP(port) asm("ld\tbc,"#port"\nin\tl,(c)\nld\th,0\n");
#define M_INP8(port) asm("in\ta,("#port")\nld\tl,a\nld\th,0\n");
#define M_OUTP(port,byte) asm("ld\tbc,"#port"\nld\ta,"#byte"\nout\t(c),a\n");
#define M_OUTP8(port,byte) asm("ld\ta,"#byte"\nout\t("#port"),a\n");

///////////////////////////////
//// Direct Memory Manipulation
///////////////////////////////

extern void __LIB__ __FASTCALL__ *swapendian(void *addr);

// The macros can be used to inline code if the parameters resolve to constants

extern void          __LIB__              bpoke(void *addr, unsigned char byte);
extern void          __LIB__ __CALLEE__   bpoke_callee(void *addr, unsigned char byte);
extern void          __LIB__              wpoke(void *addr, unsigned int word);
extern void          __LIB__ __CALLEE__   wpoke_callee(void *addr, unsigned int word);
extern unsigned char __LIB__ __FASTCALL__ bpeek(void *addr);
extern unsigned int  __LIB__ __FASTCALL__ wpeek(void *addr);

#define bpoke(a,b) bpoke_callee(a,b)
#define wpoke(a,b) wpoke_callee(a,b)

#define M_BPOKE(addr,byte) asm("ld\thl,"#addr"\nld\t(hl),"#byte"\n");
#define M_WPOKE(addr,word) asm("ld\thl,"#addr"\nld\t(hl),"#word"%256\ninc\thl\nld\t(hl),"#word"/256\n");
#define M_BPEEK(addr) asm("ld\thl,("#addr")\nld\th,0\n");
#define M_WPEEK(addr) asm("ld\thl,("#addr")\n");

/////////////////////////
// ACCURATE T-STATE DELAY
/////////////////////////

extern void          __LIB__ __FASTCALL__ delay(unsigned int tstates);   // at least 141 T


/*********/
/* OTHER */
/*********/

// Non standard stdlib.h defs (mode is ignored)

#ifdef __Z88__
extern __LIB__ csleep(int);                 /* Very non standard! sleep for centisecs! (z88)*/
#endif


#endif
