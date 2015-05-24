
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dswap

cm48_sccz80p_dswap:

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

   pop af
   
   pop hl                      ; AC'= y
   pop de
   pop bc
   
   exx
   
   push hl                     ; push x
   push de
   push bc
   
   push af
   
   ret
