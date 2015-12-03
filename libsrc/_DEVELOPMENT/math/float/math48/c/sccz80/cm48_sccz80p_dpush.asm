
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dpush, cm48_sccz80p_dpush_0

cm48_sccz80p_dpush:

   ; sccz80 float primitive
   ; Push float in AC' onto the stack.
   ;
   ; enter : AC'   = double (math48)
   ;         stack = ret
   ;
   ; exit  : stack = double (sccz80)
   ;
   ; uses  : a, ix
   
   exx

cm48_sccz80p_dpush_0:

   pop ix
   
   ld a,l
   push af
   inc sp
   push bc
   push de
   push hl
   inc sp
   
   exx
   jp (ix)
