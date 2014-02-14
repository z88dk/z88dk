
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_alloc_fixed_unlocked(void *heap, void *p, size_t size)
;
; Attempt to allocate size bytes from the heap at fixed
; address p.  The allocation will fail if the heap does
; not contain enough free memory at address p.
;
; Returns p on success or 0 with carry set on failure.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

XDEF heap_alloc_fixed_unlocked

heap_alloc_fixed_unlocked:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_heap_alloc_fixed_unlocked.asm"
