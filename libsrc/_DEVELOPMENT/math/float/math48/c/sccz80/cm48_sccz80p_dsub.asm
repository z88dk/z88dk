
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dsub

EXTERN am48_dsub

cm48_sccz80p_dsub:

   ; sccz80 float primitive
   ; Subtract two math48 floats.
   ;
   ; enter : AC'(BCDEHL') = double right_op
   ;              stack   = double left_op, ret
   ;
   ; exit  : AC'(BCDEHL') = left_op - right_op
   ;
   ; uses  : AF, BC, DE, HL, AF', BC', DE', HL'
   
   pop af
   
   pop hl                      ; AC = y
   pop de
   pop bc

   push af
   
   exx
   jp am48_dsub
