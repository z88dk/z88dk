; void *tshr_saddrpleft(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrpleft

EXTERN asm_tshr_saddrpleft

_tshr_saddrpleft:

   pop af
   pop hl
   pop de

   push de
   push hl
   push af

   jp asm_tshr_saddrpleft
