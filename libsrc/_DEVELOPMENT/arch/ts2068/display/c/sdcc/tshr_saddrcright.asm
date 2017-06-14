; void *tshr_saddrcright(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddrcright

EXTERN asm_tshr_saddrcright

_tshr_saddrcright:

   pop af
   pop hl

   push hl
   push af

   jp asm_tshr_saddrcright
