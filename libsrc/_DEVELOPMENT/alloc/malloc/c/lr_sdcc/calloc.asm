
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *calloc(size_t nmemb, size_t size)
;
; Allocate nmemb * size bytes from the current thread's heap and
; initialize that memory to 0.
;
; Returns 0 if nmemb*size == 0 without indicating error.
;
; ===============================================================

XDEF calloc

calloc:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   
   INCLUDE "../../z80/asm_calloc.asm"
