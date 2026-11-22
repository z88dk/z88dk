
; double __CALLEE__ modf(double value, double *iptr)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_modf_callee, l0_cm48_sccz80_modf_callee

EXTERN am48_modf, cm48_sccz80p_dstore, cm48_sccz80p_dcallee1

cm48_sccz80_modf_callee:

   pop af
   pop hl                      ; hl = iptr
   push af

   call cm48_sccz80p_dcallee1  ; AC'= value

l0_cm48_sccz80_modf_callee:

   push hl                     ; save iptr

   call am48_modf
   
   ; AC'= fraction
   ; AC = integer
   ; stack = iptr
   
   exx
   
   ex (sp),hl                  ; hl = iptr
   call cm48_sccz80p_dstore    ; *iptr = integer
   
   pop hl
   
   exx
   
   ; AC'= fraction
   
   ret
