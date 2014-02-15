
; void *memmem(const void *big, size_t big_len, const void *little, size_t little_len)

XDEF memmem

memmem:

   pop af
   pop bc
   pop de
   pop hl
   exx
   pop bc
   
   push bc
   exx
   push hl
   push de
   push bc
   push af
   
   push ix
   
   exx
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_memmem
   
   pop ix
   ret

   INCLUDE "../../z80/asm_memmem.asm"
