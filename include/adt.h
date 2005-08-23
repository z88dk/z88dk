#ifndef _ADT_H
#define _ADT_H

/*
 * Abstract Data Types Library
 *
 * - Doubly Linked List      ; added 08.2005 aralbrec
 * - Heap                    ; added 08.2005 aralbrec
 *
 * These functions require a memory allocation policy that allows
 * memory to be allocated and freed implicitly.  You can determine
 * how the memory is allocated by declaring the u_malloc and u_free
 * functions globally in your main.c file (here the examples use
 * the standard C malloc library functions but you could use the
 * block allocator, a mixture of the two, or something of your own):
 *
 * ( u_malloc must return carry flag set if allocation successful )
 * void __FASTCALL__ *u_malloc(uint size) {
 *    return(malloc(size));   * lib function malloc sets carry *
 * }
 *
 * ( u_free must ignore addr == 0 )
 * void __FASTCALL__ u_free(void *addr) {
 *    free(addr);             * lib function free ignores 0 *
 * }
 *
 * If implemented in assembler, use the labels _u_malloc and _u_free
 * with HL as the parameter and return value.  XDEF both labels to
 * make them globals.
 *
 */


typedef unsigned char uchar;
typedef unsigned int uint;


/*** DOUBLY LINKED LIST

Items are stored in an ordered list.  Each list has a current pointer
that can point at: a specific item, before the list or after the list.

In the following:

   void *free   <->  void (*free)(void *item)
   void *match  <->  char (*match)(void *item1, void *item2) return 0 if =

*/

struct adt_ListNode {              /* Invisible to User, one for each item in list */
   void                *item;
   struct adt_ListNode *next;      /* big endian */
   struct adt_ListNode *prev;      /* big endian */
};

struct adt_List {                  /* One as handle for each list */
   uint               count;       /* number of NODEs in list */
   uchar              state;       /* state of curr ptr: 1 = INLIST, 0 = BEFORE, 2 = AFTER */
   struct adt_ListNode *current;   /* points at current NODE in list, big endian */
   struct adt_ListNode *head;      /* points at first NODE in list, big endian */
   struct adt_ListNode *tail;      /* points at last NODE in list, big endian */
};

extern struct adt_List __LIB__ *adt_ListCreate(void);
extern uint __LIB__ __FASTCALL__ adt_ListCount(struct adt_List *list);
extern void __LIB__ __FASTCALL__ *adt_ListFirst(struct adt_List *list);
extern void __LIB__ __FASTCALL__ *adt_ListLast(struct adt_List *list);
extern void __LIB__ __FASTCALL__ *adt_ListNext(struct adt_List *list);
extern void __LIB__ __FASTCALL__ *adt_ListPrev(struct adt_List *list);
extern void __LIB__ __FASTCALL__ *adt_ListCurr(struct adt_List *list);
extern int  __LIB__  adt_ListAdd(struct adt_List *list, void *item);
extern int  __LIB__  adt_ListInsert(struct adt_List *list, void *item);
extern int  __LIB__  adt_ListAppend(struct adt_List *list, void *item);
extern int  __LIB__  adt_ListPrepend(struct adt_List *list, void *item);
extern void __LIB__ __FASTCALL__ *adt_ListRemove(struct adt_List *list);
extern void __LIB__  adt_ListConcat(struct adt_List *list1, struct adt_List *list2);
extern void __LIB__  adt_ListFree(struct adt_List *list, void *free);  /* from C: free = 0 to do nothing */
extern void __LIB__ __FASTCALL__ *adt_ListTrim(struct adt_List *list);
extern void __LIB__ *adt_ListSearch(struct adt_List *list, void *match, void *item1);


/*** HEAP (PRIORITY QUEUE)

The heap is an array of void* with indices 1..N used to store items.  Items in a
heap are stored in a special order that allows single item insertion and ordered
extraction quickly.  When an array is sorted in this special order, it is said to
posses the heap property.

Heapify can be used to convert an unsorted random array into a heap with the heap
property.  HeapAdd is used to add items to a valid heap incrementally.  HeapExtract
pulls items out of the heap one at a time in order.

In the following:

     void *compare  <->  char (*compare)(void *item1, void *item2)
       return negative if item1>item2 for max heap (extract largest item first)
       return negative if item1<item2 for min heap (extract smallest item first)

Maximum array size (N) is 32767.  You provide the array and N, the number of items
in the heap.  N will automatically be modified as items are added and removed from
the heap.

*/

extern void __LIB__ adt_Heapify(void **array, uint n, void *compare);
extern void __LIB__ adt_HeapAdd(void *item, void **array, uint *n, void *compare);
extern void __LIB__ *adt_HeapExtract(void **array, uint *n, void *compare);


#endif
