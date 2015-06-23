
; float modf(float value, float *iptr) __z88dk_callee

SECTION code_fp_math48

PUBLIC cm48_sdccix_modf

EXTERN cm48_sdccixp_d2m48, am48_modf, cm48_sdccixp_dstore, cm48_sdccixp_m482d

cm48_sdccix_modf:

   pop af
   
   pop de
   pop hl                      ; hlde = float value

   pop bc
   push af
   push bc
   
   ;  hlde = float value
   ; stack = float *iptr

   call cm48_sdccixp_d2m48     ; AC' = double value
   
   call am48_modf

   ; AC'= fraction
   ; AC = integer
   ; stack = iptr

   exx
   
   ex (sp),hl                  ; hl = iptr
   call cm48_sdccixp_dstore    ; *iptr = integer   

   pop hl
   
   ; AC = fraction
   
   jp cm48_sdccixp_m482d + 1
