; uint tshr_saddr2px(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddr2px

EXTERN asm_tshr_saddr2px

_tshr_saddr2px:

   pop af
   pop hl

   push hl
   push af

   jp asm_tshr_saddr2px
