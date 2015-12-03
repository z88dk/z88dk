
; float modf(float value, float *iptr)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_modf

EXTERN l0_cm48_sdccix_modf_callee

cm48_sdccix_modf:

   pop af
   
   pop de
   pop hl                      ; hlde = float value

   pop bc
   
   push bc
   
   push hl
   push de
   
   push af
   
   push bc

   jp l0_cm48_sdccix_modf_callee
