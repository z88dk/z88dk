
SECTION code_fp_math48

PUBLIC cm48_sccz80p_ddiv

EXTERN lm48_div

cm48_sccz80p_ddiv:

   ; sccz80 float primitive
   ; divide math48 doubles
   ;
   ; enter : AC'(BCDEHL') = divisor = double x
   ;              stack   = dividend y, ret
   ;
   ; exit  : AC'(BCDEHL') = y/x
   ;
   ; uses  : AF, BC, DE, HL, AF', BC', DE', HL'

   pop af
   
   pop hl                      ; AC = y
   pop de
   pop bc
   
   push af
   
   exx
   jp lm48_div
