
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_alloc_aligned_unlocked(void *heap, size_t alignment, size_t size)
;
; Allocate size bytes from the heap at an address that is an
; integer multiple of alignment.
;
; Returns 0 with carry set on failure.
;
; If alignment is not an exact power of 2, it will be rounded up
; to the next power of 2.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

XDEF heap_alloc_aligned_unlocked_callee

heap_alloc_aligned_unlocked_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "../../z80/asm_heap_alloc_aligned_unlocked.asm"
