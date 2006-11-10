#ifndef _ADT_H
#define _ADT_H

/*
 * Abstract Data Types Library
 *
 * - Doubly Linked List +    ; added 08.2005 aralbrec
 * - Hash Table         +    ; added 08.2005 aralbrec
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
 * with HL as the parameter and return value.  XDEF both labels to
 * make them globals.
 *
 */

#ifndef _T_UCHAR
#define _T_UCHAR
   typedef unsigned char uchar;
#endif

#ifndef _T_UINT
#define _T_UINT
   typedef unsigned int uint;
#endif

/*** DOUBLY LINKED LIST

Items are stored in an ordered list.  Each list has a current pointer
that can point at: a specific item, before the list or after the list.
The list iterator is ListSearch, which searches from the item pointed
at by the current pointer and stops when the matching function
reports a match or when the current ptr points past the end of the list.

In the following:

   void *delete <->  void (*delete)(void *item)
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
extern void __LIB__  adt_ListDelete(struct adt_List *list, void *delete);  /* from C: del = 0 to do nothing */
extern uint __LIB__ __FASTCALL__ adt_ListCount(struct adt_List *list);
extern void __LIB__ __FASTCALL__ *adt_ListFirst(struct adt_List *list);
extern void __LIB__ __FASTCALL__ *adt_ListLast(struct adt_List *list);
extern void __LIB__ __FASTCALL__ *adt_ListNext(struct adt_List *list);
extern void __LIB__ __FASTCALL__ *adt_ListPrev(struct adt_List *list);
extern void __LIB__ __FASTCALL__ *adt_ListCurr(struct adt_List *list);
extern char __LIB__  adt_ListAdd(struct adt_List *list, void *item);
extern char __LIB__  adt_ListInsert(struct adt_List *list, void *item);
extern char __LIB__  adt_ListAppend(struct adt_List *list, void *item);
extern char __LIB__  adt_ListPrepend(struct adt_List *list, void *item);
extern void __LIB__ __FASTCALL__ *adt_ListRemove(struct adt_List *list);
extern void __LIB__  adt_ListConcat(struct adt_List *list1, struct adt_List *list2);
extern void __LIB__ __FASTCALL__ *adt_ListTrim(struct adt_List *list);
extern void __LIB__ *adt_ListSearch(struct adt_List *list, void *match, void *item1);


/*** HASH TABLE

A hash table stores (key,value) pairs and is intended as a fast table lookup.
You provide the key, the hash table looks up the value.

This implementation of hash table uses a linked list to store (key,value)
pairs that map to the same table location.  Keys must be unique, with the
lib functions taking sensible actions if the user violates this requirement.
Unlike most hash table implementations that only require an equals operator
on keys, this implementation requires a less/equal operator in order
to keep items in the lists sorted for marginally faster lookup when the load
factor of the hash table becomes high.

On creation, you must determine the hash table's size and provide
several functions, among them key compare and hash function, which will be
stored in the hashtable data structure and will be used implicity in hash
table function calls.  As always performance depends on a good hash function
and appropriate hash table size.  The goal is to evenly spread keys among all
table indices -- this can be helped by choosing a table size that is a prime
number.

In the following:

   void *delete    <->  void (*delete)(struct adt_HashCell *hc)
                        an opportunity for user cleanup; delete hc->key, hc->value only
   void *hashfunc  <->  uint (*hashfunc)(void *key, uint size)
                        return a uint from 0..size-1
   void *compare   <->  char (*compare)(void *key1, void *key2)
                        if *key1 < *key2 return -ve, if = return 0

delete member = 0 to do no user clean-up on deleted adt_HashCells.

*/

struct adt_HashCell {               /* Invisible to user, one for each (key,value) pair in table */
   void *key;
   struct adt_HashCell *next;       /* big endian */
   void *value;
};

struct adt_HashTable {              /* One as handle for the hash table */
   uint                size;        /* size of table */
   struct adt_HashCell **table;     /* table of buckets */
   void                *hashfunc;   /* user supplied hash function */
   void                *compare;    /* user supplied comparison of keys function */
   void                *delete;     /* user supplied function for deleting (key,value) pairs */
};

extern struct adt_HashTable __LIB__ *adt_HashCreate(uint size, void *delete, void *compare, void *hashfunc);
extern void __LIB__ __FASTCALL__ adt_HashDelete(struct adt_HashTable *ht);
extern void __LIB__ *adt_HashRemove(struct adt_HashTable *ht, void *key);
extern void __LIB__ *adt_HashLookup(struct adt_HashTable *ht, void *key);
extern void __LIB__ *adt_HashAdd(struct adt_HashTable *ht, void *key, void *value);


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

extern void __LIB__ adt_Heapify(void **array, uint n, void *compare);
extern void __LIB__ adt_HeapAdd(void *item, void **array, uint *n, void *compare);
extern void __LIB__ *adt_HeapExtract(void **array, uint *n, void *compare);


/*** QUEUE

A queue allows storage and retrieval of items in FIFO order.  New items
are added to the back of the queue and items are removed from the front
of the queue.

In the following:

     void *delete  <-> void (*delete)(void *item)
                       an opportunity for user clean up if a non-empty queue is deleted
*/

struct adt_QueueNode {                /* One for each item in queue, invisible to user */
   void *item;
   struct adt_QueueNode *next;
};

struct adt_Queue {                    /* A single handle for each queue created */
   struct adt_QueueNode *front;
   struct adt_QueueNode *back;
};

extern struct adt_Queue __LIB__ *adt_QueueCreate(void);
extern void __LIB__ adt_QueueDelete(struct adt_Queue *q, void *delete);  /* from C: del = 0 to do nothing */
extern int  __LIB__ __FASTCALL__ adt_QueueEmpty(struct adt_Queue *q);
extern void __LIB__ __FASTCALL__ *adt_QueueFront(struct adt_Queue *q);
extern void __LIB__ __FASTCALL__ *adt_QueueBack(struct adt_Queue *q);
extern void __LIB__ __FASTCALL__ *adt_QueuePopFront(struct adt_Queue *q);
extern int  __LIB__ adt_QueuePushBack(struct adt_Queue *q, void *item);


/*** STACK

A standard LIFO stack.  Items are pushed onto the top of a stack and are popped
off the top as well.

In the following:

     void *delete  <-> void __FASTCALL__ (*delete)(void *item)
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

extern struct adt_Stack __LIB__ *adt_StackCreate(void);
extern void __LIB__ adt_StackDelete(struct adt_Stack *s, void *delete);   /* from C: del = 0 to do nothing */
extern int  __LIB__ adt_StackPush(struct adt_Stack *s, void *item);
extern void __LIB__ __FASTCALL__ *adt_StackPop(struct adt_Stack *s);
extern void __LIB__ __FASTCALL__ *adt_StackPeek(struct adt_Stack *s);
extern uint __LIB__ __FASTCALL__  adt_StackCount(struct adt_Stack *s);


#endif
