
; void *memmem(const void *big, size_t big_len, const void *little, size_t little_len)

SECTION code_clib
SECTION code_string

PUBLIC memmem_callee

EXTERN asm_memmem

memmem_callee:

   pop af
   pop bc
   pop de
   pop hl
   pop ix
   push af
   
   jp asm_memmem
