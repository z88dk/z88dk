
; double __CALLEE__ modf(double value, double *iptr)

SECTION code_fp_math48

PUBLIC cm48_sccz80_modf

EXTERN lm48_modf, cm48_sccz80p_dstore

cm48_sccz80_modf:

   pop af
   
   pop hl                      ; AC'= value
   pop de
   pop bc
   
   exx
   
   pop hl
   
   push af
   
   push hl                     ; save iptr

   call lm48_modf
   
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
