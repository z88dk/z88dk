
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_calloc(void *heap, size_t nmemb, size_t size)
;
; Allocate nmemb * size bytes from the heap and initialize
; that memory to 0.
;
; Returns 0 with carry set on failure.
;
; Returns 0 if nmemb * size == 0 without indicating error.
;
; ===============================================================

XDEF heap_calloc

heap_calloc:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
      
   INCLUDE "../../z80/asm_heap_calloc.asm"
