
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_galloc_unlocked(void *heap, void *p, int resize)
;
; Attempts to grow or shrink block p by signed resize bytes.
; This is a thin layer on top of realloc.
;
; Non-standard function used internally by the C library.
; See heap_realloc for exit conditions.
;
; ===============================================================

XDEF heap_galloc_unlocked

heap_galloc_unlocked:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_heap_galloc_unlocked.asm"
