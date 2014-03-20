
; void *realloc(void *p, size_t size)

XDEF realloc

realloc:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_realloc.asm"
