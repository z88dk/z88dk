
; void *memmem_callee(const void *big, size_t big_len, const void *little, size_t little_len)

SECTION code_clib
SECTION code_string

PUBLIC _memmem_callee

EXTERN asm_memmem

_memmem_callee:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   push af

   jp asm_memmem
