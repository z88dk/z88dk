
; void *memmem(const void *big, size_t big_len, const void *little, size_t little_len)

XDEF memmem_callee

memmem_callee:

   pop af
   pop bc
   pop de
   pop hl
   pop ix
   push af
   
   INCLUDE "../../asm_memmem.asm"
