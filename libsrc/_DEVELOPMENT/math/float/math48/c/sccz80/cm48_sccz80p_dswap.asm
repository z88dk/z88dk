
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dswap

EXTERN am48_dswap

   ; sccz80 float primitive
   ; Swap two math48 floats.
   ;
   ; enter : AC'(BCDEHL') = double x
   ;              stack   = double y, ret
   ;
   ; exit  : AC'(BCDEHL') = y
   ;              stack   = x
   ;
   ; uses  : AF, BC, DE, HL, BC', DE', HL'

defc cm48_sccz80p_dswap = am48_dswap
