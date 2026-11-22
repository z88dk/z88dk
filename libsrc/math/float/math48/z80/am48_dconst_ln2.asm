
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dconst_ln2

EXTERN mm48__acln2

   ; set AC = ln(2)
   ;
   ; uses : bc, de, hl
   
defc am48_dconst_ln2 = mm48__acln2
