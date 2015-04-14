
#ifndef _ALLOC_BALLOC_H
#define _ALLOC_BALLOC_H

#include <stddef.h>

#ifdef _SDCC

// SDCC

extern void   *balloc_addmem(int q, size_t num, size_t size, void *p);
extern void   *balloc_alloc(int q);
extern size_t  balloc_blockcount(int q);
extern void   *balloc_firstfit(int q, int numq);
extern void    balloc_free(void *p);

#ifdef __SDCC_ENABLE_FASTCALL

// SDCC FASTCALL LINKAGE

extern void   *balloc_alloc_fastcall(int q);
extern size_t  balloc_blockcount_fastcall(int q);
extern void    balloc_free_fastcall(void *p);

// SDCC MAKE FASTCALL LINKAGE THE DEFAULT

#define balloc_alloc(a)             balloc_alloc_fastcall(a)
#define balloc_blockcount(a)        balloc_blockcount_fastcall(a)
#define balloc_free(a)              balloc_free_fastcall(a)

#endif

#else

// SCCZ80

extern void   __LIB__              *balloc_addmem(int q, size_t num, size_t size, void *p);
extern void   __LIB__ __FASTCALL__ *balloc_alloc(int q);
extern size_t __LIB__ __FASTCALL__  balloc_blockcount(int q);
extern void   __LIB__              *balloc_firstfit(int q, int numq);
extern void   __LIB__ __FASTCALL__  balloc_free(void *p);

// SCCZ80 CALLEE LINKAGE

extern void   __LIB__ __CALLEE__   *balloc_addmem_callee(int q, size_t num, size_t size, void *p);
extern void   __LIB__ __CALLEE__   *balloc_firstfit_callee(int q, int numq);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define balloc_addmem(a,b,c,d)      balloc_addmem_callee(a,b,c,d)
#define balloc_firstfit(a,b)        balloc_firstfit_callee(a,b)

#endif

#endif
