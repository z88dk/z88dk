; void tshr_cls(uchar ink)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_cls

EXTERN asm_tshr_cls

_tshr_cls:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_tshr_cls
