
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dmul

EXTERN cm48_sccz80p_dcallee1_0, am48_dmul

cm48_sccz80p_dmul:

   ; sccz80 float primitive
   ; Multiply two math48 floats.
   ;
   ; enter : AC'(BCDEHL') = double x (math48)
   ;              stack   = double y (sccz80), ret
   ;
   ; exit  : AC'(BCDEHL') = x * y
   ;
   ; uses  : all except iy

   call cm48_sccz80p_dcallee1_0
   
   ; AC = x
   ; AC'= y
   
   jp am48_dmul
