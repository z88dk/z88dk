
SECTION code_fp_math48

PUBLIC cm48_sccz80p_ifix

EXTERN mm48_fix_long

   ; sccz80 float primitive
   ; Convert math48 float to signed long
   ;
   ; enter : AC'(BCDEHL') = double x
   ;
   ; exit  : DEHL = (long)(x) truncates (round toward zero)
   ;
   ; uses  : AF, BC, DE, HL, AF', BC', DE', HL'

defc cm48_sccz80p_ifix = mm48_fix_long
