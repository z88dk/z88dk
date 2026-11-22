; void *tshr_saddrpright(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrpright

EXTERN asm_tshr_saddrpright

_tshr_saddrpright:

   pop af
   pop hl
   pop de

   push de
   push hl
   push af

   jp asm_tshr_saddrpright
