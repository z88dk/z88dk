#ifndef __MALLOC_H__
#define __MALLOC_H__


/*
 * Now some trickery to link in the correct routines for far
 *
 * $Id: malloc.h,v 1.8 2006-12-19 21:32:04 aralbrec Exp $
 */


#ifndef FARDATA

// Space must be declared to hold the process's
// standard heap:
//
// int heap;
//
// An alternative is to reserve two bytes
// in RAM at address xxxx using:
//
// extern int heap(xxxx);
//
// The heap must be initialized to empty with a
// call to mallinit() or by setting heap=0.
// Then available memory must be added by one or
// more calls to sbrk() as in:
//
// mallinit();
// sbrk(50000,4000);  /* add 4000 bytes from 50000-53999 inclusive */
// sbrk(25000,126);   /* add 126 bytes from 25000-25125 inclusive */
// a = malloc(100);

extern void __LIB__ mallinit(void);
extern void __LIB__ sbrk(void *addr, int size);
extern void __LIB__ *calloc(int nobj, int size); 
extern void __LIB__ __FASTCALL__ free(void *addr);
extern void __LIB__ __FASTCALL__ *malloc(int size);
extern void __LIB__ *realloc(void *p, int size);
extern void __LIB__ mallinfo(int *total, int *largest);

// The following is to allow programs using the
// older version of the near malloc library to
// continue to work

#define HEAPSIZE(bp)       unsigned char heap[bp+2];
#define heapinit(a)        mallinit(); sbrk(heap+2,a);
#define getfree()          asm("ld\thl,-2\nadd\thl,sp\npush\thl\ndec\thl\ndec\thl\npush\thl\ncall\tmallinfo\npop\thl\npop\thl\n");
#define getlarge()         asm("ld\thl,-2\nadd\thl,sp\npush\thl\ndec\thl\ndec\thl\npush\thl\ncall\tmallinfo\npop\thl\npop\tbc\n");
#define realloc_down(a,b)  realloc(a,b);

// Named Heap Functions
//
// The near malloc library supports multiple independent
// heaps; by referring to one by name, allocation
// and deallocation can be performed from a specific heap.
//
// To create a new heap, simply declare an integer to hold
// the heap's pointer as in:
//
// int myheap;
// 
// or, to place in RAM at specific address xxxx:
//
// extern int myheap(xxxx);
//
// Heaps must be initialized to empty with a call to
// HeapCreate() or by setting them =0 (myheap=0; eg).
// Then available memory must be added to the heap as in:
//
// HeapCreate(&myheap);
// HeapSbrk(&myheap, 50000, 5000);  /* add memory to heap */
// a = HeapAlloc(&myheap, 14);
//
// The main intent of multiple heaps is to allow various
// heaps to be valid in different memory configurations, allowing
// program segments to get valid near memory while different
// memory configurations are active.
//
// The stdlib uses the process's standard heap called "heap".

extern void __LIB__ __FASTCALL__ HeapCreate(void *heap);
extern void __LIB__ HeapSbrk(void *heap, void *addr, int size);
extern void __LIB__ *HeapCalloc(void *heap, int nobj, int size); 
extern void __LIB__ HeapFree(void *heap, void *addr);
extern void __LIB__ HeapAlloc(void *heap, int size);
extern void __LIB__ *HeapRealloc(void *heap, void *p, int size);
extern void __LIB__ HeapInfo(void *heap, int *total, int *largest);

#else

/*
 * Now some definitions for far functions
 */

#define calloc(a,b) calloc_far(a,b)
#define malloc(a)   malloc_far(a)
#define free(a)     free_far(a)

// realloc, sbrk, mallinit not implemented in far lib
#define realloc(a,b)
#define sbrk(a,b)
#define mallinit()

// mallinfo has no place in far stuff, non ANSI in anycase */
#define mallinfo(a,b)

// these are for compatibility with the older version of the near malloc lib

#define HEAPSIZE(bp)
#define getfree()  
#define getlarge()
#define heapinit(a) heapinit_far(a)

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
