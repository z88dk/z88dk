
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memalign_unlocked(size_t alignment, size_t size)
;
; Allocate size bytes from the thread's heap at an address
; that is a multiple of alignment.  Alignment is always an
; exact power of 2 and if it is not, it is rounded upward
; to the next power of 2.
;
; Returns 0 with carry set if allocation is not possible.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

XDEF memalign_unlocked_callee

memalign_unlocked_callee:

   pop de
   pop hl
   pop bc
   push de
   
   INCLUDE "../../z80/asm_memalign_unlocked.asm"
