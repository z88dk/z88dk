
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_m482d

EXTERN l_ret

   ; convert math48 double to sccz80_float
   ;
   ; enter : AC' = math48 double
   ;
   ; exit  : AC' = sccz80 double

defc cm48_sccz80_m482d = l_ret
