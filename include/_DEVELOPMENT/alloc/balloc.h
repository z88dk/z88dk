
#ifndef _ALLOC_BALLOC_H
#define _ALLOC_BALLOC_H

// SCCZ80

extern void   __LIB__              *balloc_addmem(int q, size_t num, size_t size, void *p);
extern void   __LIB__ __FASTCALL__ *balloc_alloc(int q);
extern size_t __LIB__ __FASTCALL__  balloc_blockcount(int q);
extern void   __LIB__              *balloc_firstfit(int q, int numq);
extern void   __LIB__ __FASTCALL__  balloc_free(void *p);
extern void   __LIB__ __FASTCALL__  balloc_init(int numq);

// SCCZ80 CALLEE LINKAGE

extern void   __LIB__ __CALLEE__   *balloc_addmem_callee(int q, size_t num, size_t size, void *p);
extern void   __LIB__ __CALLEE__   *balloc_firstfit_callee(int q, int numq);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define balloc_addmem(a,b,c,d)      balloc_addmem_callee(a,b,c,d)
#define balloc_firstfit(a,b)        balloc_firstfit_callee(a,b)

#endif
