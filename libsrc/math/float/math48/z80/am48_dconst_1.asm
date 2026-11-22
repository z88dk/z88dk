
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dconst_1

EXTERN mm48__ac1

   ; set AC = 1
   ;
   ; uses : bc, de, hl
   
defc am48_dconst_1 = mm48__ac1
