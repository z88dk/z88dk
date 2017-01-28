#ifndef __MALLOC_H__
#define __MALLOC_H__

#include <sys/compiler.h>

/*
 * Now some trickery to link in the correct routines for far
 *
 * $Id: malloc.h,v 1.17 2016-06-11 19:53:08 dom Exp $
 */


#ifndef FARDATA

// The Near Malloc Library is still a simple first
// fit linear search of a list of free blocks.  The
// list of free blocks is kept sorted by address so
// that merging of adjacent blocks can occur.
//
// The block memory allocator (balloc.lib) is an
// alternative for allocating blocks of fixed size.
// Its main advantage is that it is very quick O(1)
// in comparison to the O(N) of this library.
//
// Space must be declared to hold the process's
// standard heap:
//
// long heap;
//
// An alternative is to reserve four bytes
// in RAM at address xxxx using:
//
// extern long heap(xxxx);
//
// The heap must be initialized to empty with a
// call to mallinit() or by setting heap=0L.
// Then available memory must be added by one or
// more calls to sbrk() as in:
//
// mallinit();        /* heap = 0L; is an alternative              */
// sbrk(50000,4000);  /* add 4000 bytes from 50000-53999 inclusive */
// sbrk(25000,126);   /* add 126 bytes from 25000-25125 inclusive  */
// a = malloc(100);

/* Trick to force a default malloc initialization    */
/* Activate it by invoking zcc with i.e. '-DAMALLOC' */

// Automatic Preset for malloc:  3/4 of the free memory
#ifdef AMALLOC
#pragma output USING_amalloc
#endif
#ifdef AMALLOC3
#pragma output USING_amalloc
#endif

// Automatic Preset for malloc:  2/4 of the free memory
#ifdef AMALLOC2
#pragma output USING_amalloc
#pragma output USING_amalloc_2
#endif

// Automatic Preset for malloc:  1/4 of the free memory
#ifdef AMALLOC1
#pragma output USING_amalloc
#pragma output USING_amalloc_2
#pragma output USING_amalloc_1
#endif

extern void __LIB__              mallinit(void);
extern void __LIB__              sbrk(void *addr, unsigned int size) __smallc;
extern void __LIB__    sbrk_callee(void *addr, unsigned int size) __smallc __z88dk_callee;
extern void __LIB__              *calloc(unsigned int nobj, unsigned int size) __smallc;
extern void __LIB__    *calloc_callee(unsigned int nobj, unsigned int size) __smallc __z88dk_callee; 
extern void __LIB__  free(void *addr) __z88dk_fastcall;
extern void __LIB__  *malloc(unsigned int size) __z88dk_fastcall;
extern void __LIB__              *realloc(void *p, unsigned int size) __smallc;
extern void __LIB__    *realloc_callee(void *p, unsigned int size) __smallc __z88dk_callee;
extern void __LIB__              mallinfo(unsigned int *total, unsigned int *largest) __smallc;
extern void __LIB__    mallinfo_callee(unsigned int *total, unsigned int *largest) __smallc __z88dk_callee;

#define sbrk(a,b)      sbrk_callee(a,b)
#define calloc(a,b)    calloc_callee(a,b)
#define realloc(a,b)   realloc_callee(a,b)
#define mallinfo(a,b)  mallinfo_callee(a,b)

// The following is to allow programs using the
// older version of the near malloc library to
// continue to work

#define HEAPSIZE(bp)       unsigned char heap[bp+4];
#define heapinit(a)        mallinit(); sbrk_callee(heap+4,a);
#define getfree()          asm("EXTERN\tMAHeapInfo\nEXTERN\t_heap\nld\thl,_heap\ncall\tMAHeapInfo\nex\tde,hl\n")
#define getlarge()         asm("EXTERN\tMAHeapInfo\nEXTERN\t_heap\nld\thl,_heap\ncall\tMAHeapInfo\nld\tl,c\nld\th,b\n")
#define realloc_down(a,b)  realloc_callee(a,b)



// Named Heap Functions
//
// The near malloc library supports multiple independent
// heaps; by referring to one by name, allocation
// and deallocation can be performed from a specific heap.
//
// To create a new heap, simply declare a long to hold
// the heap's pointer as in:
//
// long myheap;
// 
// or, to place in RAM at specific address xxxx:
//
// extern long myheap(xxxx);
//
// Heaps must be initialized to empty with a call to
// HeapCreate() or by setting them =0L (myheap=0L; eg).
// Then available memory must be added to the heap
// with one or more calls to HeapSbrk():
//
// HeapCreate(&myheap);             /* myheap = 0L;       */
// HeapSbrk(&myheap, 50000, 5000);  /* add memory to heap */
// a = HeapAlloc(&myheap, 14);
//
// The main intent of multiple heaps is to allow various
// heaps to be valid in different memory configurations, allowing
// program segments to get valid near memory while different
// memory configurations are active.
//
// The stdlib functions implicitly use the heap named "heap".
// So, for example, a call to HeapAlloc(heap,size) is equivalent
// to a call to malloc(size).

extern void __LIB__  HeapCreate(void *heap) __z88dk_fastcall;
extern void __LIB__              HeapSbrk(void *heap, void *addr, unsigned int size) __smallc;
extern void __LIB__    HeapSbrk_callee(void *heap, void *addr, unsigned int size) __smallc __z88dk_callee;
extern void __LIB__              *HeapCalloc(void *heap, unsigned int nobj, unsigned int size) __smallc;
extern void __LIB__    *HeapCalloc_callee(void *heap, unsigned int nobj, unsigned int size) __smallc __z88dk_callee;
extern void __LIB__              HeapFree(void *heap, void *addr) __smallc;
extern void __LIB__    HeapFree_callee(void *heap, void *addr) __smallc __z88dk_callee;
extern void __LIB__              *HeapAlloc(void *heap, unsigned int size) __smallc;
extern void __LIB__    *HeapAlloc_callee(void *heap, unsigned int size) __smallc __z88dk_callee;
extern void __LIB__              *HeapRealloc(void *heap, void *p, unsigned int size) __smallc;
extern void __LIB__    *HeapRealloc_callee(void *heap, void *p, unsigned int size) __smallc __z88dk_callee;
extern void __LIB__              HeapInfo(unsigned int *total, unsigned int *largest, void *heap) __smallc;
extern void __LIB__    HeapInfo_callee(unsigned int *total, unsigned int *largest, void *heap) __smallc __z88dk_callee;

#define HeapSbrk(a,b,c)     HeapSbrk_callee(a,b,c)
#define HeapCalloc(a,b,c)   HeapCalloc_callee(a,b,c)
#define HeapFree(a,b)       HeapFree_callee(a,b)
#define HeapAlloc(a,b)      HeapAlloc_callee(a,b)
#define HeapRealloc(a,b,c)  HeapRealloc_callee(a,b,c)
#define HeapInfo(a,b,c)     HeapInfo_callee(a,b,c)

#else

/*
 * Now some definitions for far functions
 */

#define calloc(a,b) calloc_far(a,b)
#define malloc(a)   malloc_far(a)
#define free(a)     free_far(a)

// realloc, sbrk, mallinit, mallinfo not implemented in far lib

#define realloc(a,b)
#define sbrk(a,b)      heapinit_far(b)
#define mallinit()
#define mallinfo(a,b)

// these are for compatibility with the older version of the near malloc lib

#define HEAPSIZE(bp)
#define getfree()  
#define getlarge()
#define heapinit(a)    heapinit_far(a)

extern far void __LIB__ *calloc_far(int, int);
extern far void __LIB__ *malloc_far(long);
extern void __LIB__ free_far(far void *);
extern void __LIB__ freeall_far();

/* Create the correct memory spec */
#ifdef MAKE_PACKAGE
#pragma output far_mmset
#endif



#endif /* FARDATA */



#endif /* _MALLOC_H */
