; void *tshr_saddrcleft(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrcleft

EXTERN asm_tshr_saddrcleft

_tshr_saddrcleft:

   pop af
   pop hl

   push hl
   push af

   jp asm_tshr_saddrcleft
