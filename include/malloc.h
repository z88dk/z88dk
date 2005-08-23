#ifndef __MALLOC_H__
#define __MALLOC_H__


/*
 * Now some trickery to link in the correct routines for far
 *
 * $Id: malloc.h,v 1.5 2005-08-23 00:19:21 aralbrec Exp $
 */


#ifndef FARDATA

/*
 * Heapsize is a macro which will create a heap of size bp
 */



#define HEAPSIZE(bp)    unsigned char heap[bp]; 


extern void __LIB__ *calloc(int,int); 
extern void __LIB__ __FASTCALL__ *malloc(int);
extern void __LIB__ __FASTCALL__ free(void *);
extern int __LIB__ getfree();
extern int __LIB__ getlarge();
extern void __LIB__ heapinit(int);
extern void __LIB__ *realloc_down(void *,int);

#else

/*
 * Now some definitions for far functions
 */
#define HEAPSIZE(bp)
#define calloc(a,b) calloc_far(a,b)
#define malloc(a)   malloc_far(a)
#define free(a)     free_far(a)
/* getfree/getlarge have no place in far stuff, non ANSI in anycase */
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
