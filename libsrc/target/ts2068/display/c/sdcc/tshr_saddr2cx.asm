; uchar tshr_saddr2cx(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_saddr2cx

EXTERN asm_tshr_saddr2cx

_tshr_saddr2cx:

   pop af
   pop hl

   push hl
   push af

   jp asm_tshr_saddr2cx
