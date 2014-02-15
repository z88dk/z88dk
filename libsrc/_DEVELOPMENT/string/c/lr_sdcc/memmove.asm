
; void *memmove(void *s1, const void *s2, size_t n)

XDEF memmove

memmove:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_memmove.asm"
