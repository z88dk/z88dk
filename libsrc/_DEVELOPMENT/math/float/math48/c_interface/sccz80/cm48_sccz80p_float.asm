
SECTION code_fp_math48

PUBLIC cm48_sccz80p_float

EXTERN mm48_float_long

   ; sccz80 float primitive
   ; Convert signed long to math48 float
   ;
   ; enter : DEHL = long n
   ;
   ; exit  : AC'= (float)(n)
   ;
   ; uses  : AF, BC, DE, HL, AF', BC', DE', HL'

defc cm48_sccz80p_float = mm48_float_long
