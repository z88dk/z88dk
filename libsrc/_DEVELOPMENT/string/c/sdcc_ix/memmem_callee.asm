
; void *memmem_callee(const void *big, size_t big_len, const void *little, size_t little_len)

SECTION code_string

PUBLIC _memmem_callee, l0_memmem_callee

_memmem_callee:

   pop af
   exx
   pop bc
   exx
   pop hl
   pop de
   pop bc
   push af

l0_memmem_callee:

   exx
   push bc
   exx
   
   ex (sp),ix
   
   call asm_memmem
   
   pop ix
   ret

   INCLUDE "string/z80/asm_memmem.asm"
