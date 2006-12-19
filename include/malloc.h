#ifndef __MALLOC_H__
#define __MALLOC_H__


/*
 * Now some trickery to link in the correct routines for far
 *
 * $Id: malloc.h,v 1.6 2006-12-19 10:08:54 aralbrec Exp $
 */


#ifndef FARDATA

// macro statically reserves space for
// the process's default heap

#define M_HEAPDECLARE    int heap; 

// an alternative is to reserve two bytes
// in RAM at address xxxx using:
//
// extern int heap(xxxx);

extern void __LIB__ mallinit(void);
extern void __LIB__ sbrk(void *addr, int size);
extern void __LIB__ *calloc(int nobj, int size); 
extern void __LIB__ __FASTCALL__ free(void *addr);
extern void __LIB__ __FASTCALL__ *malloc(int size);
extern void __LIB__ *realloc(void *p, int size);
extern void __LIB__ mallinfo(int *total, int *largest);

#else

/*
 * Now some definitions for far functions
 */

#define M_HEAPDECLARE

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
/* getfree/getlarge has no place in far stuff, non ANSI in anycase */
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
