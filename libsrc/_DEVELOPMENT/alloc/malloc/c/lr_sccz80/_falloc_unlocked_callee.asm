
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *_falloc_unlocked(void *p, size_t size)
;
; Attempt to allocate size bytes from the thread's heap at
; fixed address p.  Returns p or 0 with carry set on failure.
;
; Returns 0 if size = 0 without indicating error.
;
; ===============================================================

XDEF _falloc_unlocked_callee

_falloc_unlocked_callee:

   pop de
   pop hl
   pop bc
   push de

   INCLUDE "../../z80/asm_falloc_unlocked.asm"
