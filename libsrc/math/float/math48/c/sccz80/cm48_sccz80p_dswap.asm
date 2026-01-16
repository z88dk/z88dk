
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dswap

EXTERN cm48_sccz80p_dcallee1_0, cm48_sccz80p_dpush_0

cm48_sccz80p_dswap:

   ; sccz80 float primitive
   ; Swap two floats.
   ;
   ; enter : AC'(BCDEHL') = double x (math48)
   ;              stack   = double y (sccz80), ret
   ;
   ; exit  : AC'(BCDEHL') = y (math48)
   ;         AC (BCDEHL ) = x (math48)
   ;              stack   = x (sccz80)
   ;
   ; uses  : all except iy

   call cm48_sccz80p_dcallee1_0

   ; AC'= y
   ; AC = x
   
   ; jp cm48_sccz80p_dpush_0 - would add extra 'exx'

   pop ix

   ld a,l
   push af
   inc sp
   push bc
   push de
   push hl
   inc sp

	jp (ix)
