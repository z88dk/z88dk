
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *realloc_unlocked(void *p, size_t size)
;
; Reallocation occurs from the thread's default heap.
;
; Resize the memory block p to size bytes.  If this cannot
; be done in-place, a new memory block is allocated and the
; data at address p is copied to the new block.
;
; If p == 0, an effective malloc is performed, except a
; successful allocation occurs from the largest block available
; in the heap to allow for further quick growth via realloc.
;
; If p != 0 and size == 0, the block is reduced to zero size
; but is not freed.  You must call free to free blocks.
;
; If successful, returns ptr to the reallocated memory block,
; which may be p if the block was resized in place.
;
; If unsuccessful, returns 0 with carry set.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_realloc_unlocked

EXTERN __malloc_heap

EXTERN asm_heap_realloc_unlocked

asm_realloc_unlocked:

   ; Realloc using the thread's default heap without locking
   ;
   ; enter : hl = void *p (existing pointer to memory)
   ;         bc = uint size (realloc size)
   ;
   ; exit  : success
   ;
   ;            hl = void *p_new
   ;            carry reset
   ;
   ;         fail on insufficient memory
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ;         fail on lock acquisition
   ;
   ;            hl = 0
   ;            carry set, errno = ENOLCK
   ;
   ; uses  : af, bc, de, hl

   ld de,(__malloc_heap)
   jp asm_heap_realloc_unlocked
