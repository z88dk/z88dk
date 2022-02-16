
SECTION code_clib
SECTION code_fp_am9511

PUBLIC cam32_sdcc___mulsint2slong_callee

EXTERN asm_am9511_imul

cam32_sdcc___mulsint2slong_callee:

   ; 16-bit multiplication, 32-bit result
   ;
   ; enter : stack = multiplicand, multiplicand, ret
   ;
   ; exit  : dehl = product

   pop hl
   pop de
   ex (sp),hl

   jp asm_am9511_imul       ; product in dehl
