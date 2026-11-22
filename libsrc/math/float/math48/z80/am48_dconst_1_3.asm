
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dconst_1_3

EXTERN mm48__ac1_3

   ; set AC = 1/3
   ;
   ; uses : bc, de, hl
   
defc am48_dconst_1_3 = mm48__ac1_3
