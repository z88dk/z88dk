
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_minusfa

EXTERN am48_dneg

   ; sccz80 float primitive
   ; Negate float in AC'
   ;
   ; enter : AC'(BCDEHL') = double x (math48 format)
   ;
   ; exit  : AC'(BCDEHL') = -x (math48 format)
   ;
   ; uses  : AF, B'

defc cm48_sccz80p_minusfa = am48_dneg
