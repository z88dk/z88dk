
; char __fsneq (float left, float right)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_dsneq

EXTERN cm48_sdccixp_dread2, am48_dne

cm48_sdccixp_dsneq:

   ; (left != right)
   ;
   ; enter : sdcc_float right, sdcc_float left, ret
   ;
   ; exit  : HL = 0 and carry reset if false
   ;         HL = 1 and carry set if true
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   call cm48_sdccixp_dread2

   ; AC = right
   ; AC'= left

   jp am48_dne
