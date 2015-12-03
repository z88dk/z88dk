
; char __fslt (float left, float right)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_dslt

EXTERN cm48_sdcciyp_dread2, am48_dlt

cm48_sdcciyp_dslt:

   ; (left < right)
   ;
   ; enter : sdcc_float right, sdcc_float left, ret
   ;
   ; exit  : HL = 0 and carry reset if false
   ;         HL = 1 and carry set if true
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   call cm48_sdcciyp_dread2

   ; AC = right
   ; AC'= left

   exx
   jp am48_dlt
