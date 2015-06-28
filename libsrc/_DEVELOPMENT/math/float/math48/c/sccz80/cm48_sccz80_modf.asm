
; double modf(double value, double *iptr)

SECTION code_fp_math48

PUBLIC cm48_sccz80_modf

EXTERN l0_cm48_sccz80_modf_callee, am48_dloadb

cm48_sccz80_modf:

   pop af
   pop hl                      ; hl = iptr
   
   push hl
   push af
   
   exx
   
   ld hl,9
   add hl,sp
   
   call am48_dloadb
   
   jp l0_cm48_sccz80_modf_callee
