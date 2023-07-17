#ifndef __STDLIB_H__
#define __STDLIB_H__

/*
 * Lots of nice support functions here and a few defines
 * to support some functions
 *
 * $Id: stdlib.h,v 1.51 2016-07-10 20:59:19 dom Exp $
 */

#include <sys/compiler.h>
#include <sys/types.h>
#include <stdint.h>


/**********************************/
/* STANDARD K&R LIBRARY FUNCTIONS */
/**********************************/


//////////////////////////////////
//// String <-> Number Conversions
//////////////////////////////////

// double atof(char *s);                    /* check math library for availability */

extern int  __LIB__   atoi(const char *s);
#ifndef __STDC_ABI_ONLY
extern int  __LIB__   atoi_fastcall(const char *s) __z88dk_fastcall;
#define atoi(x) atoi_fastcall(x)
#endif

extern long __LIB__   atol(const char *s);
#ifndef __STDC_ABI_ONLY
extern long __LIB__   atol_fastcall(const char *s) __z88dk_fastcall;
#define atol(x) atol_fastcall(x)
#endif

__ZPROTO3(char,*,itoa,int,num,char *,buf,int,radix)
#ifndef __STDC_ABI_ONLY
extern char __LIB__ *itoa_callee(int num,char *buf,int radix) __smallc __z88dk_callee;
#define itoa(a,b,c) itoa_callee(a,b,c)
#endif

__ZPROTO3(char,*,ltoa,long,num,char *,buf,int,radix)
#ifndef __STDC_ABI_ONLY
extern char __LIB__ *ltoa_callee(long num,char *buf,int radix) __smallc __z88dk_callee;
#define ltoa(a,b,c) ltoa_callee(a,b,c)
#endif

__ZPROTO3(long,,strtol,char *,nptr,char **,endptr,int,base)
#ifndef __STDC_ABI_ONLY
extern long __LIB__ strtol_callee(char *nptr,char **endptr,int base) __smallc __z88dk_callee;
#define strtol(a,b,c) strtol_callee(a,b,c)
#endif

__ZPROTO3(uint32_t,,strtoul,char *,nptr,char **,endptr,int,base)
#ifndef __STDC_ABI_ONLY
extern uint32_t __LIB__ strtoul_callee(char *nptr,char **endptr,int base) __smallc __z88dk_callee;
#define strtoul(a,b,c) strtoul_callee(a,b,c)
#endif

__ZPROTO3(char,*,ultoa,uint32_t,num,char *,buf,int,radix)
#ifndef __STDC_ABI_ONLY
extern char __LIB__ *ultoa_callee(uint32_t num,char *buf,int radix) __smallc __z88dk_callee;
#define ultoa(a,b,c) ultoa_callee(a,b,c)
#endif

__ZPROTO3(char,*,utoa,uint16_t,num,char *,buf,int,radix)
#ifndef __STDC_ABI_ONLY
extern char __LIB__ *utoa_callee(uint16_t num,char *buf,int radix) __smallc __z88dk_callee;
#define utoa(a,b,c) utoa_callee(a,b,c)
#endif


// double strtod(char *s, char **endp);     /* check math library for availability */

/* 64 bit is only available with sdcc */
extern long long atoll(char *buf) __smallc;
#ifndef __STDC_ABI_ONLY
extern long long atoll_callee(char *buf) __z88dk_callee __smallc;
#define atoll(a) atoll_callee(a)
#endif


extern char *lltoa(long long num,char *buf,int radix) __smallc;
#ifndef __STDC_ABI_ONLY
extern char *lltoa_callee(long long num,char *buf,int radix) __z88dk_callee __smallc;
#define lltoa(a,b,c) lltoa_callee(a,b,c)
#endif


extern long long strtoll(char *nptr,char **endptr,int base) __smallc;
#ifndef __STDC_ABI_ONLY
extern long long strtoll_callee(char *nptr,char **endptr,int base) __z88dk_callee __smallc;
#define strtoll(a,b,c) strtoll_callee(a,b,c)
#endif


extern unsigned long long strtoull(char *nptr,char **endptr,int base) __smallc;
#ifndef __STDC_ABI_ONLY
extern unsigned long long strtoull_callee(char *nptr,char **endptr,int base) __z88dk_callee __smallc;
#define strtoull(a,b,c) strtoull_callee(a,b,c)
#endif


extern char *ulltoa(unsigned long long num,char *buf,int radix) __smallc;
#ifndef __STDC_ABI_ONLY
extern char *ulltoa_callee(unsigned long long num,char *buf,int radix) __z88dk_callee __smallc;
#define ulltoa(a,b,c) ulltoa_callee(a,b,c)
#endif

///////////////////
//// Random Numbers
///////////////////

#define RAND_MAX    32767

extern int  __LIB__              rand(void);
extern void __LIB__  srand(unsigned int seed);
#ifndef __STDC_ABI_ONLY
extern void __LIB__  srand_fastcall(unsigned int seed) __z88dk_fastcall;
#define srand(x) srand_fastcall(x)
#endif

// Not sure why Rex has it's own rand() routine using different seed?

#define randRex() rand()

//////////////////////
//// Memory Allocation
//////////////////////

// Before using the malloc library you must initialize the heap -- see malloc.h for details
// calloc(), malloc(), realloc(), free(), mallinit(), mallinfo(), sbrk()
// ot use the -DAMALLOC option to let z88dk doing it automatically

#include <malloc.h>

///////////////////////
//// System Environment
///////////////////////

// Z88: abort is a macro to exit with RC_Err - only for apps

#define abort() exit(15)

#define EXIT_FAILURE   1
#define EXIT_SUCCESS   0

extern void __LIB__  exit(int status);
extern int  __LIB__  atexit(void (*func)(void));

#ifndef __STDC_ABI_ONLY
extern void __LIB__  exit_fastcall(int status) __z88dk_fastcall;
extern int  __LIB__  atexit_fastcall(void (*func)(void)) __z88dk_fastcall;
#define exit(x) exit_fastcall(x)
#define atexit(x) atexit_fastcall(x)
#endif

// int system(char *s);                     /* might be implemented in target's library but doubtful */

// Environment variables, may be present in fcntl library
extern char __LIB__ *getenv(const char *name); 
__ZPROTO3(char,*,getenv_r,const char *,name,char *,buf,size_t,len)
__ZPROTO3(int,,setenv,const char *,name,const char *,value,int,overflow)
extern int __LIB__ unsetenv(const char *name);



__ZPROTO3(int,,getopt,int,argc,char **,argv,const char *,optstring)


extern   char *optarg;                      /* getopt(3) external variables */
extern   int opterr;
extern   int optind;
extern   int optopt;
extern   int optreset;

//////////////////
//// Search & Sort
//////////////////

// These are not quite ansi (array items are assumed to be two bytes in length).  Also look
// into the heapsort implementation in the abstract data types library (adt.h) as a stack-
// usage-free alternative to quicksort.
//
// void *cmp == char (*cmp)(void *key, void *datum);

extern void __LIB__  *l_bsearch(void *key, void *base, unsigned int n, void *cmp) __smallc;
extern void __LIB__  *l_bsearch_callee(void *key, void *base, unsigned int n, void *cmp) __smallc __z88dk_callee;
extern void __LIB__  l_qsort(void *base, unsigned int size, void *cmp) __smallc;
extern void __LIB__  l_qsort_callee(void *base, unsigned int size, void *cmp) __smallc __z88dk_callee;

#define l_bsearch(a,b,c,d) l_bsearch_callee(a,b,c,d)

extern void __LIB__  qsort_sccz80(void *base, unsigned int nel, unsigned int width, void *compar) __smallc;
extern void __LIB__  qsort_sccz80_callee(void *base, unsigned int nel, unsigned int width, void *compar) __smallc __z88dk_callee;

extern void __LIB__  qsort_sdcc(void *base, unsigned int nel, unsigned int width, void *compar) __smallc;
extern void __LIB__  qsort_sdcc_callee(void *base, unsigned int nel, unsigned int width, void *compar) __smallc __z88dk_callee;

#ifdef __Z88DK_R2L_CALLING_CONVENTION

#define qsort                  qsort_sdcc
#define qsort_sdcc(a,b,c,d)    qsort_sdcc_callee(a,b,c,d)

#else

#define qsort                  qsort_sccz80
#define qsort_sccz80(a,b,c,d)  qsort_sccz80_callee(a,b,c,d)

#endif

#ifdef __ZX81__
#define l_qsort(a,b,c) qsort(a,b,2,c)
#else
#define l_qsort(a,b,c) l_qsort_callee(a,b,c)
#endif


//////////////////////////
//// Division routines
//////////////////////////

typedef struct
{

   int rem;
   int quot;

} div_t;

typedef struct
{

   unsigned int rem;
   unsigned int quot;

} divu_t;

typedef struct
{

   long quot;
   long rem;

} ldiv_t;

typedef struct
{

   unsigned long quot;
   unsigned long rem;

} ldivu_t;

extern void __LIB__ _div_(div_t *d,int numer,int denom) __smallc;
#ifndef __STDC_ABI_ONLY
extern void __LIB__ _div__callee(div_t *d,int numer,int denom) __smallc __z88dk_callee;
#define _div_(a,b,c) _div__callee(a,b,c)
#endif


extern void __LIB__ _divu_(divu_t *d,unsigned int numer,unsigned int denom) __smallc;
#ifndef __STDC_ABI_ONLY
extern void __LIB__ _divu__callee(divu_t *d,unsigned int numer,unsigned int denom) __smallc __z88dk_callee;
#define _divu_(a,b,c) _divu__callee(a,b,c)
#endif


extern void __LIB__ _ldiv_(ldiv_t *ld,long numer,long denom) __smallc;
#ifndef __STDC_ABI_ONLY
extern void __LIB__ _ldiv__callee(ldiv_t *ld,long numer,long denom) __smallc __z88dk_callee;
#define _ldiv_(a,b,c) _ldiv__callee(a,b,c)
#endif


extern void __LIB__ _ldivu_(ldivu_t *ld,unsigned long numer,unsigned long denom) __smallc;
#ifndef __STDC_ABI_ONLY
extern void __LIB__ _ldivu__callee(ldivu_t *ld,unsigned long numer,unsigned long denom) __smallc __z88dk_callee;
#define _ldivu_(a,b,c) _ldivu__callee(a,b,c)
#endif



//////////////////////////
//// Misc Number Functions
//////////////////////////

extern int  __LIB__  abs(int n);
#ifndef __STDC_ABI_ONLY
extern int  __LIB__  abs_fastcall(int n) __z88dk_fastcall;
#define abs(x) abs_fastcall(x)
#endif

extern long __LIB__  labs(long n);
#ifndef __STDC_ABI_ONLY
extern long  __LIB__  labs_fastcall(long n) __z88dk_fastcall;
#define labs(x) labs_fastcall(x)
#endif


extern uint __LIB__  isqrt(uint n);
#ifndef __STDC_ABI_ONLY
extern uint __LIB__  isqrt_fastcall(uint n) __z88dk_fastcall;
#define isqrt(x) isqrt_fastcall(x)
#endif


/******************************************************/
/* NON-STANDARD BUT GENERALLY USEFUL FOR Z80 MACHINES */
/******************************************************/


//////////////
//// I/O PORTS
//////////////

// For accessing 16-bit i/o ports from C.  The macros can be
// used to inline code if the parameters resolve to constants.

extern unsigned int  __LIB__  inp(unsigned int port);
#ifndef __STDC_ABI_ONLY
extern unsigned int  __LIB__  inp_fastcall(unsigned int port) __z88dk_fastcall;
#define inp(p) inp_fastcall(p)
#endif

__ZPROTO2(void,,outp,unsigned int,port,unsigned int,byte)
#ifndef __STDC_ABI_ONLY
extern void  __LIB__  outp_callee(unsigned int port, unsigned int byte) __smallc __z88dk_callee;
#define outp(a,b) outp_callee(a,b)
#endif

#define M_INP(port) asm("ld\tbc,"#port"\nin\tl,(c)\nld\th,0\n");
#define M_INP8(port) asm("in\ta,("#port")\nld\tl,a\nld\th,0\n");
#define M_OUTP(port,byte) asm("ld\tbc,"#port"\nld\ta,"#byte"\nout\t(c),a\n");
#define M_OUTP8(port,byte) asm("ld\ta,"#byte"\nout\t("#port"),a\n");

///////////////////////////////
//// Direct Memory Manipulation
///////////////////////////////

extern void __LIB__  *swapendian(void *addr) __z88dk_fastcall;

// The macros can be used to inline code if the parameters resolve to constants

__ZPROTO2(void,,bpoke,void *,addr,unsigned char,byte)
__ZPROTO2(void,,wpoke,void *,addr,unsigned int,byte)


extern unsigned char __LIB__    bpeek(const void *addr);
extern unsigned int  __LIB__    wpeek(const void *addr);


#ifndef __STDC_ABI_ONLY
extern unsigned char __LIB__    bpeek_fastcall(const void *addr) __z88dk_fastcall;
#define bpeek(x) bpeek_fastcall(x)
extern unsigned int  __LIB__    wpeek_fastcall(const void *addr) __z88dk_fastcall;
#define wpeek(x) wpeek_fastcall(x)

extern void          __LIB__    bpoke_callee(void *addr, unsigned char byte) __smallc __z88dk_callee;
extern void          __LIB__    wpoke_callee(void *addr, unsigned int word) __smallc __z88dk_callee;
#define bpoke(a,b) bpoke_callee(a,b)
#define wpoke(a,b) wpoke_callee(a,b)
#endif

#define M_BPOKE(addr,byte) asm("ld\thl,"#addr"\nld\t(hl),"#byte"\n");
#define M_WPOKE(addr,word) asm("ld\thl,"#addr"\nld\t(hl),"#word"%256\ninc\thl\nld\t(hl),"#word"/256\n");
#define M_BPEEK(addr) asm("ld\thl,("#addr")\nld\th,0\n");
#define M_WPEEK(addr) asm("ld\thl,("#addr")\n");

//////////////////////////////////////////////////
// Timing (some are non-standard)
//////////////////////////////////////////////////

// ACCURATE T-STATE DELAY
extern void   __LIB__    t_delay(unsigned int tstates) __z88dk_fastcall;   // at least 141 T

extern int __LIB__ __SAVEFRAME__     sleep (int secs);
#ifndef __STDC_ABI_ONLY
extern int __LIB__ __SAVEFRAME__     sleep_fastcall (int secs) __z88dk_fastcall;
#define sleep(x) sleep_fastcall(x)
#endif

extern void __LIB__ msleep(unsigned int milliseconds);
#ifndef __STDC_ABI_ONLY
extern int __LIB__  msleep_fastcall (unsigned int milliseconds) __z88dk_fastcall;
#define msleep(x) msleep_fastcall(x)
#endif

#ifdef __Z88__
/* Sleep for a number of centiseconds */
extern void __LIB__    __SAVEFRAME__  csleep(unsigned int centiseconds) __z88dk_fastcall;
#else
#define csleep(x) msleep((x) * 10)
#endif


/*********/
/* OTHER */
/*********/

// Non standard stdlib.h defs (mode is ignored)
// Extract a given number of bits from a byte string (at specified bit position) and load into a long value
extern unsigned long __LIB__   extract_bits(unsigned char *data, unsigned int start, unsigned int size) __smallc;
#ifndef __STDC_ABI_ONLY
extern unsigned long __LIB__   extract_bits_callee(unsigned char *data, unsigned int start, unsigned int size) __smallc __z88dk_callee;
#define extract_bits(a,b,c)  extract_bits_callee(a,b,c)
#endif

// Compare a file name in "8.3" format to a wildcard expression
__ZPROTO2(int,,wcmatch,char,*wildname,char *,filename)

// Convert a BCD encoded value to unsigned int
extern unsigned int __LIB__ unbcd(unsigned int value);

#ifdef __Z88__
extern int system(const char *text);              /* should this be in the z88 library? */
#endif



#endif
