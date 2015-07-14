include(__link__.m4)

#ifndef _STDLIB_H
#define _STDLIB_H

#include <stddef.h>
#include <stdint.h>

// DATA STRUCTURES

#ifndef _SIZE_T_DEFINED
#define _SIZE_T_DEFINED
typedef unsigned int  size_t;
#endif

#ifndef _WCHAR_T_DEFINED
#define _WCHAR_T_DEFINED
typedef unsigned char wchar_t;
#endif

#ifndef _FLOAT_T_DEFINED
#define _FLOAT_T_DEFINED

   #ifdef __SDCC
   
   typedef float float_t;
   
   #else
   
   typedef double float_t;
   
   #endif
   
#endif

#ifndef _DOUBLE_T_DEFINED
#define _DOUBLE_T_DEFINED

   #ifdef __SDCC
   
   typedef float double_t;
   
   #else
   
   typedef double double_t;
   
   #endif
   
#endif

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

#ifndef NULL
#define NULL            ((void*)(0))
#endif

#define EXIT_FAILURE    0
#define EXIT_SUCCESS    1

#define RAND_MAX        32767

#define MB_CUR_MAX      1

#define FTOA_FLAG_PLUS  0x40
#define FTOA_FLAG_SPACE 0x20
#define FTOA_FLAG_HASH  0x10

#define DTOA_FLAG_PLUS  0x40
#define DTOA_FLAG_SPACE 0x20
#define DTOA_FLAG_HASH  0x10

// FUNCTIONS

__DPROTO(void,,_div_,div_t *d,int numer,int denom)
__DPROTO(void,,_divu_,divu_t *d,unsigned int numer,unsigned int denom)
__DPROTO(void,,_ldiv_,ldiv_t *ld,long numer,long denom)
__DPROTO(void,,_ldivu_,ldivu_t *ld,unsigned long numer,unsigned long denom)
__DPROTO(void,,_insertion_sort_,void *base,size_t nmemb,size_t size,void *compar)
__DPROTO(void,,_quicksort_,void *base,size_t nmemb,size_t size,void *compar)
__DPROTO(void,,_shellsort_,void *base,size_t nmemb,size_t size,void *compar)
__DPROTO(uint16_t,,_random_uniform_cmwc_8_,void *seed)
__DPROTO(uint32_t,,_random_uniform_xor_32_,uint32_t *seed)
__DPROTO(uint16_t,,_random_uniform_xor_8_,uint32_t *seed)
__DPROTO(int,,_strtoi_,char *nptr,char **endptr,int base)
__DPROTO(uint16_t,,_strtou_,char *nptr,char **endptr,int base)
__OPROTO(void,,abort,void)
__DPROTO(int,,abs,int j)
__DPROTO(int,,at_quick_exit,void *func)
__DPROTO(int,,atexit,void *func)
__DPROTO(double_t,,atof,char *nptr)
__DPROTO(int,,atoi,char *buf)
__DPROTO(long,,atol,char *buf)
__DPROTO(void,,bsearch,void *key,void *base,size_t nmemb,size_t size,void *compar)
__DPROTO(size_t,,dtoa,double_t x,void *buf,uint16_t prec,uint16_t flags)
__DPROTO(size_t,,dtoe,double_t x,void *buf,uint16_t prec,uint16_t flags)
__DPROTO(size_t,,dtog,double_t x,void *buf,uint16_t prec,uint16_t flags)
__DPROTO(size_t,,dtoh,double_t x,void *buf,uint16_t prec,uint16_t flags)
__DPROTO(void,,exit,int status)
__DPROTO(size_t,,ftoa,float_t x,void *buf,uint16_t prec,uint16_t flags)
__DPROTO(size_t,,ftoe,float_t x,void *buf,uint16_t prec,uint16_t flags)
__DPROTO(size_t,,ftog,float_t x,void *buf,uint16_t prec,uint16_t flags)
__DPROTO(size_t,,ftoh,float_t x,void *buf,uint16_t prec,uint16_t flags)
__DPROTO(char,*,itoa,int num,char *buf,int radix)
__DPROTO(long,,labs,long j)
__DPROTO(char,*,ltoa,long num,char *buf,int radix)
__DPROTO(void,,qsort,void *base,size_t nmemb,size_t size,void *compar)
__DPROTO(void,,quick_exit,int status)
__OPROTO(int,,rand,void)
__DPROTO(void,,srand,uint16_t seed)
__DPROTO(double_t,,strtod,char *nptr,char **endptr)
__DPROTO(float_t,,strtof,char *nptr,char **endptr)
__DPROTO(long,,strtol,char *nptr,char **endptr,int base)
__DPROTO(uint32_t,,strtoul,char *nptr,char **endptr,int base)
__DPROTO(int,,system,char *s)
__DPROTO(char,*,ultoa,uint32_t num,char *buf,int radix)
__DPROTO(char,*,utoa,uint16_t num,char *buf,int radix)

#ifndef _ALLOC_MALLOC_H

__DPROTO(void,*,aligned_alloc,size_t alignment,size_t size)
__DPROTO(void,*,calloc,size_t nmemb,size_t size)
__DPROTO(void,,free,void *p)
__DPROTO(void,*,malloc,size_t size)
__DPROTO(void,*,realloc,void *p,size_t size)

__DPROTO(void,*,aligned_alloc_unlocked,size_t alignment,size_t size)
__DPROTO(void,*,calloc_unlocked,size_t nmemb,size_t size)
__DPROTO(void,,free_unlocked,void *p)
__DPROTO(void,*,malloc_unlocked,size_t size)
__DPROTO(void,*,realloc_unlocked,void *p,size_t size)

#endif

#endif
