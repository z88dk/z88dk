
; void free(void *p)

XDEF free

free:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_free.asm"
