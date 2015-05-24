
SECTION code_fp_math48

PUBLIC cm48_sccz80p_minusfa

EXTERN mm48_negate

cm48_sccz80p_minusfa:

   ; sccz80 float primitive
   ; Negate float in AC'
   ;
   ; enter : AC'(BCDEHL') = double x (math48 format)
   ;
   ; exit  : AC'(BCDEHL') = -x (math48 format)
   ;
   ; uses  : AF, B'

   exx
   call mm48_negate
   exx

   ret
