
SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_dconst_1

EXTERN m32_fsconst_one

   ; set DEHL = 1.0 (IEEE single)
   ;
   ; uses : af, de, hl

defc asm_dconst_1 = m32_fsconst_one
