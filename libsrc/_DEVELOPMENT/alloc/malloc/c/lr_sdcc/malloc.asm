
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *malloc(size_t size)
;
; Allocate size bytes from the current thread's heap, returning
; ptr to the allocated memory or 0 with carry set on failure.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

XDEF malloc

malloc:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_malloc.asm"
