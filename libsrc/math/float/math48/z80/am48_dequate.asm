
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dequate

EXTERN mm48_equal

   ; set AC' = AC
   ;
   ; enter : AC = double x
   ;
   ; exit  : AC'= AC = double x
   ;
   ; uses  : bc', de', hl'
   
defc am48_dequate = mm48_equal
