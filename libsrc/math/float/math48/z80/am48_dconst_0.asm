
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dconst_0

EXTERN mm48__zero_no

   ; set AC = 0
   ;
   ; uses : bc, de, hl
   
defc am48_dconst_0 = mm48__zero_no
