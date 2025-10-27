
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dge

EXTERN cm48_sccz80p_dcallee1_0, am48_dge

cm48_sccz80p_dge:

   ; sccz80 float primitive
   ; left_op >= right_op ?
   ;
   ; enter : AC'(BCDEHL') = right_op (math48)
   ;              stack   = left_op (sccz80), ret
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
   ; uses  : all except iy

   call cm48_sccz80p_dcallee1_0
   exx
   
   ; AC'= right_op
   ; AC = left_op
   
   jp am48_dge
