
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void free_unlocked(void *p)
;
; Deallocate memory previously allocated at p from the thread's
; default heap.
;
; If p == 0, function returns without performing an action.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_free_unlocked

EXTERN __malloc_heap
EXTERN asm_heap_free_unlocked

asm_free_unlocked:

   ; Return the memory block to the heap for reuse without locking
   ;
   ; enter : hl = void *p
   ;
   ; exit  : carry reset
   ;
   ; uses  : af, de, hl

   ld de,(__malloc_heap)
   jp asm_heap_free_unlocked
