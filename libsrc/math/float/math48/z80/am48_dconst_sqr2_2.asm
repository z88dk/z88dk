
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dconst_sqr2_2

EXTERN mm48__acsqr2_2

   ; set AC = sqrt(2)/2
   ;
   ; uses : bc, de, hl
   
defc am48_dconst_sqr2_2 = mm48__acsqr2_2
