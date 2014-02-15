
; void *memmove(void *s1, const void *s2, size_t n)

XDEF memmove_callee

memmove_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "../../z80/asm_memmove.asm"
