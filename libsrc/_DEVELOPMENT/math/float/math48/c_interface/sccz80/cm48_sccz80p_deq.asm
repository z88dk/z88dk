
SECTION code_fp_math48

PUBLIC cm48_sccz80p_deq

EXTERN lm48_compare, error_znc, error_oc

cm48_sccz80p_deq:

   ; sccz80 float primitive
   ; left_op == right_op ?
   ;
   ; enter : AC'(BCDEHL') = right_op
   ;              stack   = left_op, ret
   ;
   ; exit  : if true
   ;
   ;            HL = 1
   ;            carry set
   ;
   ;         if false
   ;
   ;            HL = 0
   ;            carry reset
   ;
   ; uses  : AF, BC, DE, HL

   pop af
   
   pop hl                      ; AC = left_op
   pop de
   pop bc
   
   push af
   
   call lm48_compare
   
   jp nz, error_znc            ; if false
   jp error_oc                 ; if true
