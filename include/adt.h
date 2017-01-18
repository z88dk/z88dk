#ifndef _ADT_H
#define _ADT_H

/*
 * Abstract Data Types Library
 *
 * - Doubly Linked List +    ; added 08.2005 aralbrec
 * - Heap                    ; added 08.2005 aralbrec
 * - Stack              +    ; added 09.2005 aralbrec
 * - Queue              +    ; added 09.2005 aralbrec
 *
 * The data types marked with "+" require a memory allocation policy
 * that allows memory to be allocated and freed implicitly.  You can
 * determine how that memory is allocated by declaring the u_malloc
 * and u_free functions globally in your main.c file (here the examples
 * use the standard C malloc library functions but you could use the
 * block allocator, a mixture of the two, or something of your own):
 *
 * ( u_malloc must return carry flag set if allocation successful )
 * void *u_malloc(uint size) {
 *    return(malloc(size));   * lib function malloc sets carry *
 * }
 *
 * ( u_free must ignore addr == 0 )
 * void u_free(void *addr) {
 *    free(addr);             * lib function free ignores 0 *
 * }
 *
 * If implemented in assembler, use the labels _u_malloc and _u_free
 * with HL as the parameter and return value.  PUBLIC both labels to
 * make them globals.
 *
 */

#include <sys/compiler.h>
#include <sys/types.h>

/*** DOUBLY LINKED LIST

Items are stored in an ordered list.  Each list has a current pointer
that can point at: a specific item, before the list or after the list.
The list iterator is ListSearch, which searches from the item pointed
at by the current pointer and stops when the matching function
reports a match or when the current ptr points past the end of the list.

In the following:

   void *delete <->  void [] (*delete)(void *item)
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
extern void __LIB__  adt_ListCreateS(struct adt_List *list) __z88dk_fastcall;
extern void __LIB__  adt_ListDelete(struct adt_List *list, void *delete) __smallc;   /* from C: del = 0 to do nothing */
extern void __LIB__  adt_ListDeleteS(struct adt_List *list, void *delete) __smallc;  /* from C: del = 0 to do nothing */
extern uint __LIB__  adt_ListCount(struct adt_List *list) __z88dk_fastcall;
extern void __LIB__  *adt_ListFirst(struct adt_List *list) __z88dk_fastcall;
extern void __LIB__  *adt_ListLast(struct adt_List *list) __z88dk_fastcall;
extern void __LIB__  *adt_ListNext(struct adt_List *list) __z88dk_fastcall;
extern void __LIB__  *adt_ListPrev(struct adt_List *list) __z88dk_fastcall;
extern void __LIB__  *adt_ListCurr(struct adt_List *list) __z88dk_fastcall;
extern int  __LIB__  adt_ListAdd(struct adt_List *list, void *item) __smallc;
extern int  __LIB__  adt_ListInsert(struct adt_List *list, void *item) __smallc;
extern int  __LIB__  adt_ListAppend(struct adt_List *list, void *item) __smallc;
extern int  __LIB__  adt_ListPrepend(struct adt_List *list, void *item) __smallc;
extern void __LIB__  adt_ListConcat(struct adt_List *list1, struct adt_List *list2) __smallc;
extern void __LIB__  *adt_ListTrim(struct adt_List *list) __z88dk_fastcall;
extern void __LIB__  *adt_ListPopFront(struct adt_List *list) __z88dk_fastcall;
extern void __LIB__  adt_ListSetCurrBefore(struct adt_List *list) __z88dk_fastcall;
extern void __LIB__  adt_ListSetCurrAfter(struct adt_List *list) __z88dk_fastcall;
extern void __LIB__ adt_ListSetCurr(struct adt_List *list, struct adt_ListNode *n) __smallc;
extern void __LIB__ *adt_ListSearch(struct adt_List *list, void *match, void *item1) __smallc;

// make CALLEE linkage default

extern void __LIB__  adt_ListDelete_callee(struct adt_List *list, void *delete) __smallc __z88dk_callee;   /* from C: del = 0 to do nothing */
extern void __LIB__  adt_ListDeleteS_callee(struct adt_List *list, void *delete) __smallc __z88dk_callee;  /* from C: del = 0 to do nothing */
extern int  __LIB__  adt_ListAdd_callee(struct adt_List *list, void *item) __smallc __z88dk_callee;
extern int  __LIB__  adt_ListInsert_callee(struct adt_List *list, void *item) __smallc __z88dk_callee;
extern int  __LIB__  adt_ListAppend_callee(struct adt_List *list, void *item) __smallc __z88dk_callee;
extern int  __LIB__  adt_ListPrepend_callee(struct adt_List *list, void *item) __smallc __z88dk_callee;
extern void __LIB__  adt_ListConcat_callee(struct adt_List *list1, struct adt_List *list2) __smallc __z88dk_callee;
extern void __LIB__  adt_ListSetCurr_callee(struct adt_List *list, struct adt_ListNode *n) __smallc __z88dk_callee;
extern void __LIB__  *adt_ListSearch_callee(struct adt_List *list, void *match, void *item1) __smallc __z88dk_callee;

#define adt_ListDelete(a,b)     adt_ListDelete_callee(a,b)
#define adt_ListDeleteS(a,b)    adt_ListDeleteS_callee(a,b)
#define adt_ListAdd(a,b)        adt_ListAdd_callee(a,b)
#define adt_ListInsert(a,b)     adt_ListInsert_callee(a,b)
#define adt_ListAppend(a,b)     adt_ListAppend_callee(a,b)
#define adt_ListPrepend(a,b)    adt_ListPrepend_callee(a,b)
#define adt_ListConcat(a,b)     adt_ListConcat_callee(a,b)
#define adt_ListSetCurr(a,b)    adt_ListSetCurr_callee(a,b)
#define adt_ListSearch(a,b,c)   adt_ListSearch_callee(a,b,c)

#define adt_ListPopBack(a)      adt_ListTrim(a)
#define adt_ListPushBack(a,b)   adt_ListAppend_callee(a,b)
#define adt_ListPushFront(a,b)  adt_ListPrepend_callee(a,b)


/*** HEAP (PRIORITY QUEUE)

The heap is an array of void* with indices 1..N used to store items.  Items in a
heap are stored in a special order that allows single item insertion and ordered
extraction quickly.  When an array is sorted in this special order, it is said to
posses the heap property.

Heapify can be used to convert an unsorted random array into a heap with the heap
property.  HeapAdd is used to add items to a valid heap incrementally.  HeapExtract
pulls items out of the heap one at a time in order.

Besides returning the smallest (min heap) / largest (max heap) item in the heap,
HeapExtract will also write the extracted item to the end of the array.  If all
items in an array are extracted one after the other, the array, after all
extractions, will be sorted in ascending order (max heap) or descending order
(min heap).  This is an implementation of heapsort.

In the following:

     void *compare  <->  char (*compare)(void **item1, void **item2)
       return negative if item1>item2 for max heap (extract largest item first)
       return negative if item1<item2 for min heap (extract smallest item first)

     NOTE ON VOID** Addresses within the array are being passed not array contents

Maximum array size (N) is 32767.  You provide the array and N, the number of items
in the heap.  N will automatically be modified as items are added and removed from
the heap.

*/

extern void __LIB__  adt_Heapify(void **array, uint n, void *compare) __smallc;
extern void __LIB__  adt_HeapAdd(void *item, void **array, uint *n, void *compare) __smallc;
extern void __LIB__ *adt_HeapExtract(void **array, uint *n, void *compare) __smallc;

// make CALLEE linkage default

extern void __LIB__   adt_Heapify_callee(void **array, uint n, void *compare) __smallc __z88dk_callee;
extern void __LIB__   adt_HeapAdd_callee(void *item, void **array, uint *n, void *compare) __smallc __z88dk_callee;
extern void __LIB__  *adt_HeapExtract_callee(void **array, uint *n, void *compare) __smallc __z88dk_callee;

#define adt_Heapify(a,b,c)      adt_Heapify_callee(a,b,c)
#define adt_HeapAdd(a,b,c,d)    adt_HeapAdd_callee(a,b,c,d)
#define adt_HeapExtract(a,b,c)  adt_HeapExtract_callee(a,b,c)


/*** QUEUE

A queue allows storage and retrieval of items in FIFO order.  New items
are added to the back of the queue and items are removed from the front
of the queue.

In the following:

     void *delete  <-> void [] (*delete)(void *item)
                       an opportunity for user clean up if a non-empty queue is deleted
*/

struct adt_QueueNode {                /* One for each item in queue, invisible to user */
   void *item;
   struct adt_QueueNode *next;
};

struct adt_Queue {                    /* A single handle for each queue created */
   uint                  count;
   struct adt_QueueNode *front;
   struct adt_QueueNode *back;
};

extern struct adt_Queue __LIB__  *adt_QueueCreate(void);
extern void __LIB__  *adt_QueueCreateS(struct adt_Queue *q) __z88dk_fastcall;
extern void __LIB__ adt_QueueDelete(struct adt_Queue *q, void *delete) __smallc;  /* from C: del = 0 to do nothing */
extern void __LIB__ adt_QueueDeleteS(struct adt_Queue *q, void *delete) __smallc; /* from C: del = 0 to do nothing */
extern uint __LIB__  adt_QueueCount(struct adt_Queue *q) __z88dk_fastcall;
extern void __LIB__  *adt_QueueFront(struct adt_Queue *q) __z88dk_fastcall;
extern void __LIB__  *adt_QueueBack(struct adt_Queue *q) __z88dk_fastcall;
extern void __LIB__  *adt_QueuePopFront(struct adt_Queue *q) __z88dk_fastcall;
extern void __LIB__  *adt_QueuePopBack(struct adt_Queue *q) __z88dk_fastcall;
extern int  __LIB__ adt_QueuePushFront(struct adt_Queue *q, void *item) __smallc;
extern int  __LIB__ adt_QueuePushBack(struct adt_Queue *q, void *item) __smallc;

// make CALLEE linkage default

extern void __LIB__  adt_QueueDelete_callee(struct adt_Queue *q, void *delete) __smallc __z88dk_callee;
extern void __LIB__  adt_QueueDeleteS_callee(struct adt_Queue *q, void *delete) __smallc __z88dk_callee;
extern int  __LIB__  adt_QueuePushFront_callee(struct adt_Queue *q, void *item) __smallc __z88dk_callee;
extern int  __LIB__  adt_QueuePushBack_callee(struct adt_Queue *q, void *item) __smallc __z88dk_callee;

#define adt_QueueDelete(a,b)     adt_QueueDelete_callee(a,b)
#define adt_QueueDeleteS(a,b)    adt_QueueDeleteS_callee(a,b)
#define adt_QueuePushFront(a,b)  adt_QueuePushFront_callee(a,b)
#define adt_QueuePushBack(a,b)   adt_QueuePushBack_callee(a,b)


/*** STACK

A standard LIFO stack.  Items are pushed onto the top of a stack and are popped
off the top as well.

In the following:

     void *delete  <-> void [] (*delete)(void *item)
                       an opportunity for user clean up if a non-empty stack is deleted
*/

struct adt_StackNode {                 /* One for each item in stack */
   void *item;
   struct adt_Stack *next;
};

struct adt_Stack {
   uint count;                         /* Number of items in stack     */
   struct adt_StackNode *next;         /* Pointer to top item in stack */
};

extern struct adt_Stack __LIB__  *adt_StackCreate(void);
extern void __LIB__   adt_StackCreateS(struct adt_Stack *s) __z88dk_fastcall;
extern void __LIB__ adt_StackDelete(struct adt_Stack *s, void *delete) __smallc;   /* from C: del = 0 to do nothing */
extern void __LIB__ adt_StackDeleteS(struct adt_Stack *s, void *delete) __smallc;  /* from C: del = 0 to do nothing */
extern int  __LIB__ adt_StackPush(struct adt_Stack *s, void *item) __smallc;
extern void __LIB__  *adt_StackPop(struct adt_Stack *s) __z88dk_fastcall;
extern void __LIB__  *adt_StackPeek(struct adt_Stack *s) __z88dk_fastcall;
extern uint __LIB__   adt_StackCount(struct adt_Stack *s) __z88dk_fastcall;

// make CALLEE linkage default

extern void __LIB__  adt_StackDelete_callee(struct adt_Stack *s, void *delete) __smallc __z88dk_callee;
extern void __LIB__  adt_StackDeleteS_callee(struct adt_Stack *s, void *delete) __smallc __z88dk_callee;
extern int  __LIB__  adt_StackPush_callee(struct adt_Stack *s, void *item) __smallc __z88dk_callee;

#define adt_StackDelete(a,b)   adt_StackDelete_callee(a,b)
#define adt_StackDeleteS(a,b)  adt_StackDeleteS_callee(a,b)
#define adt_StackPush(a,b)     adt_StackPush_callee(a,b)


#endif
