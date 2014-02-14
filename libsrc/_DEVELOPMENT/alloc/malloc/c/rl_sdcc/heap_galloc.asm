
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_galloc(void *heap, void *p, int resize)
;
; Attempts to grow or shrink block p by signed resize bytes.
; This is a thin layer on top of realloc.
;
; Non-standard function used internally by the C library.
; See heap_realloc for exit conditions.
;
; ===============================================================

XDEF heap_galloc

heap_galloc:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_heap_galloc.asm"
