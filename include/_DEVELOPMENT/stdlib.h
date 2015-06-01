
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

typedef struct
{

   int rem;
   int quot;

} div_t;

typedef struct
{

   long quot;
   long rem;

} ldiv_t;

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

// FUNCTIONS

#ifdef __SDCC

// SDCC

extern void      _div_(div_t *d, int numer, int denom);
extern void      _ldiv_(ldiv_t *ld, long numer, long denom);
extern void      _insertion_sort_(void *base, size_t nmemb, size_t size, void *compar);
extern void      _quicksort_(void *base, size_t nmemb, size_t size, void *compar);
extern void      _shellsort_(void *base, size_t nmemb, size_t size, void *compar);
extern uint16_t  _random_uniform_cmwc_8_(void *seed);
extern uint32_t  _random_uniform_xor_32_(uint32_t seed);
extern uint16_t  _random_uniform_xor_8_(uint32_t seed);
extern int       _strtoi_(char *nptr, char **endptr, int base);
extern uint16_t  _strtou_(char *nptr, char **endptr, int base);
extern void      abort(void);
extern int       abs(int j);
extern int       at_quick_exit(void *func);
extern int       atexit(void *func);
extern int       atoi(char *buf);
extern long      atol(char *buf);
extern void      bsearch(void *key, void *base, size_t nmemb, size_t size, void *compar);
extern void      exit(int status);
extern char     *itoa(int num, char *buf, int radix);
extern long      labs(long j);
extern char     *ltoa(long num, char *buf, int radix);
extern void      qsort(void *base, size_t nmemb, size_t size, void *compar);
extern void      quick_exit(int status);
extern int       rand(void);
extern void      srand(uint16_t seed);
extern long      strtol(char *nptr, char **endptr, int base);
extern uint32_t  strtoul(char *nptr, char **endptr, int base);
extern int       system(char *s);
extern char     *ultoa(uint32_t num, char *buf, int radix);
extern char     *utoa(uint16_t num, char *buf, int radix);

#ifndef _ALLOC_MALLOC_H

extern void   *aligned_alloc(size_t alignment, size_t size);
extern void   *calloc(size_t nmemb, size_t size);
extern void    free(void *p);
extern void   *malloc(size_t size);
extern void   *realloc(void *p, size_t size);

extern void   *aligned_alloc_unlocked(size_t alignment, size_t size);
extern void   *calloc_unlocked(size_t nmemb, size_t size);
extern void    free_unlocked(void *p);
extern void   *malloc_unlocked(size_t size);
extern void   *realloc_unlocked(void *p, size_t size);

#endif

#ifndef __SDCC_DISABLE_FASTCALL

// SDCC FASTCALL LINKAGE

extern uint16_t  _random_uniform_cmwc_8__fastcall(void *seed) __z88dk_fastcall;
extern uint32_t  _random_uniform_xor_32__fastcall(uint32_t seed) __z88dk_fastcall;
extern uint16_t  _random_uniform_xor_8__fastcall(uint32_t seed) __z88dk_fastcall;
extern int       abs_fastcall(int j) __z88dk_fastcall;
extern int       at_quick_exit_fastcall(void *func) __z88dk_fastcall;
extern int       atexit_fastcall(void *func) __z88dk_fastcall;
extern int       atoi_fastcall(char *buf) __z88dk_fastcall;
extern long      atol_fastcall(char *buf) __z88dk_fastcall;
extern void      exit_fastcall(int status) __z88dk_fastcall;
extern long      labs_fastcall(long j) __z88dk_fastcall;
extern void      quick_exit_fastcall(int status) __z88dk_fastcall;
extern void      srand_fastcall(uint16_t seed) __z88dk_fastcall;
extern int       system_fastcall(char *s) __z88dk_fastcall;

#ifndef _ALLOC_MALLOC_H

extern void    free_fastcall(void *p) __z88dk_fastcall;
extern void   *malloc_fastcall(size_t size) __z88dk_fastcall;

extern void    free_unlocked_fastcall(void *p) __z88dk_fastcall;
extern void   *malloc_unlocked_fastcall(size_t size) __z88dk_fastcall;

#endif

// SDCC MAKE FASTCALL LINKAGE THE DEFAULT

#define _random_uniform_cmwc_8_(a)     _random_uniform_cmwc_8__fastcall(a)
#define _random_uniform_xor_32_(a)     _random_uniform_xor_32__fastcall(a)
#define _random_uniform_xor_8_(a)      _random_uniform_xor_8__fastcall(a)
#define abs(a)                         abs_fastcall(a)
#define at_quick_exit(a)               at_quick_exit_fastcall(a)
#define atexit(a)                      atexit_fastcall(a)
#define atoi(a)                        atoi_fastcall(a)
#define atol(a)                        atol_fastcall(a)
#define exit(a)                        exit_fastcall(a)
#define labs(a)                        labs_fastcall(a)
#define quick_exit(a)                  quick_exit_fastcall(a)
#define srand(a)                       srand_fastcall(a)
#define system(a)                      system_fastcall(a)

#ifndef _ALLOC_MALLOC_H

#define free(a)                     free_fastcall(a)
#define malloc(a)                   malloc_fastcall(a)

#define free_unlocked(a)            free_unlocked_fastcall(a)
#define malloc_unlocked(a)          malloc_unlocked_fastcall(a)

#endif

#endif

#ifndef __SDCC_DISABLE_CALLEE

// SDCC CALLEE LINKAGE

extern void      _div__callee(div_t *d, int numer, int denom) __z88dk_callee;
extern void      _ldiv__callee(ldiv_t *ld, long numer, long denom) __z88dk_callee;
extern void      _insertion_sort__callee(void *base, size_t nmemb, size_t size, void *compar) __z88dk_callee;
extern void      _quicksort__callee(void *base, size_t nmemb, size_t size, void *compar) __z88dk_callee;
extern void      _shellsort__callee(void *base, size_t nmemb, size_t size, void *compar) __z88dk_callee;
extern int       _strtoi__callee(char *nptr, char **endptr, int base) __z88dk_callee;
extern uint16_t  _strtou__callee(char *nptr, char **endptr, int base) __z88dk_callee;
extern void      bsearch_callee(void *key, void *base, size_t nmemb, size_t size, void *compar) __z88dk_callee;
extern char     *itoa_callee(int num, char *buf, int radix) __z88dk_callee;
extern char     *ltoa_callee(long num, char *buf, int radix) __z88dk_callee;
extern void      qsort_callee(void *base, size_t nmemb, size_t size, void *compar) __z88dk_callee;
extern long      strtol_callee(char *nptr, char **endptr, int base) __z88dk_callee;
extern uint32_t  strtoul_callee(char *nptr, char **endptr, int base) __z88dk_callee;
extern char     *ultoa_callee(uint32_t num, char *buf, int radix) __z88dk_callee;
extern char     *utoa_callee(uint16_t num, char *buf, int radix) __z88dk_callee;

#ifndef _ALLOC_MALLOC_H

extern void     *aligned_alloc_callee(size_t alignment, size_t size) __z88dk_callee;
extern void     *calloc_callee(size_t nmemb, size_t size) __z88dk_callee;
extern void     *realloc_callee(void *p, size_t size) __z88dk_callee;

extern void     *aligned_alloc_unlocked_callee(size_t alignment, size_t size) __z88dk_callee;
extern void     *calloc_unlocked_callee(size_t nmemb, size_t size) __z88dk_callee;
extern void     *realloc_unlocked_callee(void *p, size_t size) __z88dk_callee;

#endif

// SDCC MAKE CALLEE LINKAGE THE DEFAULT

#define _div_(a,b,c)                _div__callee(a,b,c)
#define _ldiv_(a,b,c)               _ldiv__callee(a,b,c)
#define _insertion_sort_(a,b,c,d)   _insertion_sort__callee(a,b,c,d)
#define _quicksort_(a,b,c,d)        _quicksort__callee(a,b,c,d)
#define _shellsort_(a,b,c,d)        _shellsort__callee(a,b,c,d)
#define _strtoi_(a,b,c)             _strtoi__callee(a,b,c)
#define _strtou_(a,b,c)             _strtou__callee(a,b,c)
#define bsearch(a,b,c,d,e)          bsearch_callee(a,b,c,d,e)
#define itoa(a,b,c)                 itoa_callee(a,b,c)
#define ltoa(a,b,c)                 ltoa_callee(a,b,c)
#define qsort(a,b,c,d)              qsort_callee(a,b,c,d)
#define strtol(a,b,c)               strtol_callee(a,b,c)
#define strtoul(a,b,c)              strtoul_callee(a,b,c)
#define ultoa(a,b,c)                ultoa_callee(a,b,c)
#define utoa(a,b,c)                 utoa_callee(a,b,c)

#ifndef _ALLOC_MALLOC_H

#define aligned_alloc(a,b)          aligned_alloc_callee(a,b)
#define calloc(a,b)                 calloc_callee(a,b)
#define realloc(a,b)                realloc_callee(a,b)

#define aligned_alloc_unlocked(a,b) aligned_alloc_unlocked_callee(a,b)
#define calloc_unlocked(a,b)        calloc_unlocked_callee(a,b)
#define realloc_unlocked(a,b)       realloc_unlocked_callee(a,b)

#endif

#endif

#else

// SCCZ80

extern void      __LIB__               _div_(div_t *d, int numer, int denom);
extern void      __LIB__               _ldiv_(ldiv_t *ld, long numer, long denom);
extern void      __LIB__               _insertion_sort_(void *base, size_t nmemb, size_t size, void *compar);
extern void      __LIB__               _quicksort_(void *base, size_t nmemb, size_t size, void *compar);
extern void      __LIB__               _shellsort_(void *base, size_t nmemb, size_t size, void *compar);
extern uint16_t  __LIB__ __FASTCALL__  _random_uniform_cmwc_8_(void *seed);
extern uint32_t  __LIB__ __FASTCALL__  _random_uniform_xor_32_(uint32_t seed);
extern uint16_t  __LIB__ __FASTCALL__  _random_uniform_xor_8_(uint32_t seed);
extern int       __LIB__               _strtoi_(char *nptr, char **endptr, int base);
extern uint16_t  __LIB__               _strtou_(char *nptr, char **endptr, int base);
extern void      __LIB__               abort(void);
extern int       __LIB__ __FASTCALL__  abs(int j);
extern int       __LIB__ __FASTCALL__  at_quick_exit(void *func);
extern int       __LIB__ __FASTCALL__  atexit(void *func);
extern int       __LIB__ __FASTCALL__  atoi(char *buf);
extern long      __LIB__ __FASTCALL__  atol(char *buf);
extern void      __LIB__               bsearch(void *key, void *base, size_t nmemb, size_t size, void *compar);
extern void      __LIB__ __FASTCALL__  exit(int status);
extern size_t    __LIB__               ftoa(double x, char *buf, uint16_t prec, uint16_t flags);
extern size_t    __LIB__               ftoe(double x, char *buf, uint16_t prec, uint16_t flags);
extern char      __LIB__              *itoa(int num, char *buf, int radix);
extern long      __LIB__ __FASTCALL__  labs(long j);
extern char      __LIB__              *ltoa(long num, char *buf, int radix);
extern void      __LIB__               qsort(void *base, size_t nmemb, size_t size, void *compar);
extern void      __LIB__ __FASTCALL__  quick_exit(int status);
extern int       __LIB__               rand(void);
extern void      __LIB__ __FASTCALL__  srand(uint16_t seed);
extern long      __LIB__               strtol(char *nptr, char **endptr, int base);
extern uint32_t  __LIB__               strtoul(char *nptr, char **endptr, int base);
extern int       __LIB__ __FASTCALL__  system(char *s);
extern char      __LIB__              *ultoa(uint32_t num, char *buf, int radix);
extern char      __LIB__              *utoa(uint16_t num, char *buf, int radix);

#ifndef _ALLOC_MALLOC_H

extern void   __LIB__              *aligned_alloc(size_t alignment, size_t size);
extern void   __LIB__              *calloc(size_t nmemb, size_t size);
extern void   __LIB__ __FASTCALL__  free(void *p);
extern void   __LIB__ __FASTCALL__ *malloc(size_t size);
extern void   __LIB__              *realloc(void *p, size_t size);

extern void   __LIB__              *aligned_alloc_unlocked(size_t alignment, size_t size);
extern void   __LIB__              *calloc_unlocked(size_t nmemb, size_t size);
extern void   __LIB__ __FASTCALL__  free_unlocked(void *p);
extern void   __LIB__ __FASTCALL__ *malloc_unlocked(size_t size);
extern void   __LIB__              *realloc_unlocked(void *p, size_t size);

#endif

// SCCZ80 CALLEE LINKAGE

extern void      __LIB__ __CALLEE__    _div__callee(div_t *d, int numer, int denom);
extern void      __LIB__ __CALLEE__    _ldiv__callee(ldiv_t *ld, long numer, long denom);
extern void      __LIB__ __CALLEE__    _insertion_sort__callee(void *base, size_t nmemb, size_t size, void *compar);
extern void      __LIB__ __CALLEE__    _quicksort__callee(void *base, size_t nmemb, size_t size, void *compar);
extern void      __LIB__ __CALLEE__    _shellsort__callee(void *base, size_t nmemb, size_t size, void *compar);
extern int       __LIB__ __CALLEE__    _strtoi__callee(char *nptr, char **endptr, int base);
extern uint16_t  __LIB__ __CALLEE__    _strtou__callee(char *nptr, char **endptr, int base);
extern void      __LIB__ __CALLEE__    bsearch_callee(void *key, void *base, size_t nmemb, size_t size, void *compar);
extern size_t    __LIB__ __CALLEE__    ftoa_callee(double x, char *buf, uint16_t prec, uint16_t flags);
extern size_t    __LIB__ __CALLEE__    ftoe_callee(double x, char *buf, uint16_t prec, uint16_t flags);
extern char      __LIB__ __CALLEE__   *itoa_callee(int num, char *buf, int radix);
extern char      __LIB__ __CALLEE__   *ltoa_callee(long num, char *buf, int radix);
extern void      __LIB__ __CALLEE__    qsort_callee(void *base, size_t nmemb, size_t size, void *compar);
extern long      __LIB__ __CALLEE__    strtol_callee(char *nptr, char **endptr, int base);
extern uint32_t  __LIB__ __CALLEE__    strtoul_callee(char *nptr, char **endptr, int base);
extern char      __LIB__ __CALLEE__   *ultoa_callee(uint32_t num, char *buf, int radix);
extern char      __LIB__ __CALLEE__   *utoa_callee(uint16_t num, char *buf, int radix);

#ifndef _ALLOC_MALLOC_H

extern void   __LIB__ __CALLEE__   *aligned_alloc_callee(size_t alignment, size_t size);
extern void   __LIB__ __CALLEE__   *calloc_callee(size_t nmemb, size_t size);
extern void   __LIB__ __CALLEE__   *realloc_callee(void *p, size_t size);

extern void   __LIB__ __CALLEE__   *aligned_alloc_unlocked_callee(size_t alignment, size_t size);
extern void   __LIB__ __CALLEE__   *calloc_unlocked_callee(size_t nmemb, size_t size);
extern void   __LIB__ __CALLEE__   *realloc_unlocked_callee(void *p, size_t size);

#endif

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define _div_(a,b,c)                _div__callee(a,b,c)
#define _ldiv_(a,b,c)               _ldiv__callee(a,b,c)
#define _insertion_sort_(a,b,c,d)   _insertion_sort__callee(a,b,c,d)
#define _quicksort_(a,b,c,d)        _quicksort__callee(a,b,c,d)
#define _shellsort_(a,b,c,d)        _shellsort__callee(a,b,c,d)
#define _strtoi_(a,b,c)             _strtoi__callee(a,b,c)
#define _strtou_(a,b,c)             _strtou__callee(a,b,c)
#define bsearch(a,b,c,d,e)          bsearch_callee(a,b,c,d,e)
#define ftoa(a,b,c,d)               ftoa_callee(a,b,c,d)
#define ftoe(a,b,c,d)               ftoe_callee(a,b,c,d)
#define itoa(a,b,c)                 itoa_callee(a,b,c)
#define ltoa(a,b,c)                 ltoa_callee(a,b,c)
#define qsort(a,b,c,d)              qsort_callee(a,b,c,d)
#define strtol(a,b,c)               strtol_callee(a,b,c)
#define strtoul(a,b,c)              strtoul_callee(a,b,c)
#define ultoa(a,b,c)                ultoa_callee(a,b,c)
#define utoa(a,b,c)                 utoa_callee(a,b,c)

#ifndef _ALLOC_MALLOC_H

#define aligned_alloc(a,b)          aligned_alloc_callee(a,b)
#define calloc(a,b)                 calloc_callee(a,b)
#define realloc(a,b)                realloc_callee(a,b)

#define aligned_alloc_unlocked(a,b) aligned_alloc_unlocked_callee(a,b)
#define calloc_unlocked(a,b)        calloc_unlocked_callee(a,b)
#define realloc_unlocked(a,b)       realloc_unlocked_callee(a,b)

#endif

#endif

#endif
