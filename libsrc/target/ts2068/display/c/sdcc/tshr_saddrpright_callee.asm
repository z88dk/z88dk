; void *tshr_saddrpright(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrpright_callee

EXTERN asm_tshr_saddrpright

_tshr_saddrpright_callee:

   pop af
   pop hl
   dec sp
   pop de
   push af

   ld e,d
   jp asm_tshr_saddrpright
