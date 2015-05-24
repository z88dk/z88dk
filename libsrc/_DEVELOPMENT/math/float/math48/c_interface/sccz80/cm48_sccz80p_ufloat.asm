
SECTION code_fp_math48

PUBLIC cm48_sccz80p_ufloat

EXTERN mm48_ufloat_long

   ; sccz80 float primitive
   ; Convert unsigned long to math48 float
   ;
   ; enter : DEHL = unsigned long n
   ;
   ; exit  : AC'= (float)(n)
   ;
   ; uses  : AF, BC, DE, HL, AF', BC', DE', HL'

defc cm48_sccz80p_ufloat = mm48_ufloat_long
