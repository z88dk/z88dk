
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *_falloc(void *p, size_t size)
;
; Attempt to allocate size bytes from the thread's heap at
; fixed address p.  Returns p or 0 with carry set on failure.
;
; Returns 0 if size = 0 without indicating error.
;
; ===============================================================

XDEF _falloc

_falloc:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de

   INCLUDE "../../z80/asm_falloc.asm"
