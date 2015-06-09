
SECTION code_fp_math48

PUBLIC lm48__ufloat16

EXTERN mm48_ufloat

   ; enter : hl = unsigned int n
   ;
   ; exit  : AC'(BCDEHL') = (float)(n)
   ;         exx set swapped
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

defc lm48__ufloat16 = mm48_ufloat
