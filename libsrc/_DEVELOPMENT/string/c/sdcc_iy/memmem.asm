
; void *memmem(const void *big, size_t big_len, const void *little, size_t little_len)

XDEF memmem

memmem:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push ix
   push af

   INCLUDE "string/z80/asm_memmem.asm"
