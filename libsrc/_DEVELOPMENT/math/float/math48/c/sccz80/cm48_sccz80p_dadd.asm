
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dadd

EXTERN cm48_sccz80p_dcallee1_0, am48_dadd

cm48_sccz80p_dadd:

   ; sccz80 float primitive
   ;
   ; enter : AC'(BCDEHL') = double x (math48)
   ;              stack   = double y (sccz80), ret
   ;
   ; exit  : AC'(BCDEHL') = x + y
   ;
   ; uses  : all except iy

   call cm48_sccz80p_dcallee1_0
   
   ; AC = x
   ; AC'= y
   
   jp am48_dadd
