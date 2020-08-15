
SECTION code_fp_am9511

PUBLIC __mulint_callee

EXTERN cam32_sdcc_imul_callee

   ; multiply two 16-bit multiplicands into a 16-bit product
   ;
   ; enter : stack = multiplicand (16-bit), multiplicand (16-bit), ret
   ;
   ; exit  : dehl = product

defc __mulint_callee = cam32_sdcc_imul_callee
