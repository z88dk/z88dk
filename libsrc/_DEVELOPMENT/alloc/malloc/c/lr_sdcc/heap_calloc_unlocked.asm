
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_calloc_unlocked(void *heap, size_t nmemb, size_t size)
;
; Allocate nmemb * size bytes from the heap and initialize
; that memory to 0.
;
; Returns 0 with carry set on failure.
;
; Returns 0 if nmemb * size == 0 without indicating error.
;
; ===============================================================

XDEF heap_calloc_unlocked

heap_calloc_unlocked:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_heap_calloc_unlocked.asm"
