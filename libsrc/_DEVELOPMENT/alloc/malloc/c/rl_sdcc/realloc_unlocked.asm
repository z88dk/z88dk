
; void *realloc_unlocked(void *p, size_t size)

XDEF realloc_unlocked

realloc_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_realloc_unlocked.asm"
