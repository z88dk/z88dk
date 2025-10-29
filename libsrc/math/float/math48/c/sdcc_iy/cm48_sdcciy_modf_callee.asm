
; float modf(float value, float *iptr) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_modf_callee, l0_cm48_sdcciy_modf_callee

EXTERN cm48_sdcciyp_d2m48, am48_modf, cm48_sdcciyp_dstore, cm48_sdcciyp_m482d

cm48_sdcciy_modf_callee:

   pop af
   
   pop de
   pop hl                      ; hlde = float value

   pop bc
   push af
   push bc
   
   ;  hlde = float value
   ; stack = float *iptr

l0_cm48_sdcciy_modf_callee:

   call cm48_sdcciyp_d2m48     ; AC' = double value
   
   call am48_modf

   ; AC'= fraction
   ; AC = integer
   ; stack = iptr

   exx
   
   ex (sp),hl                  ; hl = iptr
   call cm48_sdcciyp_dstore    ; *iptr = integer   

   pop hl
   
   ; AC = fraction
   
   jp cm48_sdcciyp_m482d + 1
