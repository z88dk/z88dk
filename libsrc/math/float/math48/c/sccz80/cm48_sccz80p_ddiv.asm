
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_ddiv

EXTERN cm48_sccz80p_dcallee1_0, am48_ddiv

cm48_sccz80p_ddiv:

   ; sccz80 float primitive
   ;
   ; enter : AC'(BCDEHL') = divisor = double x (math48)
   ;              stack   = dividend y (sccz80), ret
   ;
   ; exit  : AC'(BCDEHL') = y/x
   ;
   ; uses  : all except iy

   call cm48_sccz80p_dcallee1_0
   
   ; AC = divisor (x)
   ; AC'= dividend (y)
   
   jp am48_ddiv                ; AC'= AC'/AC
