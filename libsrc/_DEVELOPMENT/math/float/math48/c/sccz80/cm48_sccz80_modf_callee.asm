
; double __CALLEE__ modf(double value, double *iptr)

SECTION code_fp_math48

PUBLIC cm48_sccz80_modf_callee, l0_cm48_sccz80_modf_callee

EXTERN am48_modf, cm48_sccz80p_dstore

cm48_sccz80_modf_callee:

   pop af
   
   pop hl                      ; hl = iptr
   
   exx
   
   pop hl                      ; AC'= value
   pop de
   pop bc
   
   exx
   
   push af

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
