
; void *memmem(const void *big, size_t big_len, const void *little, size_t little_len)

SECTION code_clib
SECTION code_string

PUBLIC _memmem

EXTERN l0_memmem_callee

_memmem:

   pop af
   exx
   pop bc
   exx
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push bc
   push af

   jp l0_memmem_callee
