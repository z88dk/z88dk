; void *tshr_saddrpleft(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrpleft_callee

EXTERN asm_tshr_saddrpleft

_tshr_saddrpleft_callee:

   pop af
   pop hl
   dec sp
   pop de
   push af

   ld e,d
   jp asm_tshr_saddrpleft
