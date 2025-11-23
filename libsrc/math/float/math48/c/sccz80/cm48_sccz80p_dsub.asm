
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dsub

EXTERN cm48_sccz80p_dcallee1_0, am48_dsub

cm48_sccz80p_dsub:

   ; sccz80 float primitive
   ; Subtract two math48 floats.
   ;
   ; enter : AC'(BCDEHL') = double right_op
   ;              stack   = double left_op, ret
   ;
   ; exit  : AC'(BCDEHL') = left_op - right_op
   ;
   ; uses  : all except iy

   call cm48_sccz80p_dcallee1_0

   ; AC = right_op
   ; AC'= left_op
   
   jp am48_dsub
