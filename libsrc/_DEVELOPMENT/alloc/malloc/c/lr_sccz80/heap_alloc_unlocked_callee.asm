
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_alloc_unlocked(void *heap, size_t size)
;
; Allocate size bytes from the heap, returning ptr to the
; allocated memory or 0 with carry set on failure.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

XDEF heap_alloc_unlocked_callee

heap_alloc_unlocked_callee:

   pop bc
   pop hl
   pop de
   push bc
   
   INCLUDE "../../z80/asm_heap_alloc_unlocked.asm"
