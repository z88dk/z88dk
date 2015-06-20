
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dlt

EXTERN am48_dlt_s

cm48_sccz80p_dlt:

   ; sccz80 float primitive
   ; left_op < right_op ?
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

defc cm48_sccz80p_dlt = am48_dlt_s
