
; void *memmem(const void *big, size_t big_len, const void *little, size_t little_len)

SECTION code_string

PUBLIC memmem_callee

memmem_callee:

   pop af
   pop bc
   pop de
   pop hl
   pop ix
   push af
   
   INCLUDE "string/z80/asm_memmem.asm"
