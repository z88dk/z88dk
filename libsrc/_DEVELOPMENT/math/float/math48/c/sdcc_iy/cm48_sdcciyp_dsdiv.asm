
; float __fsdiv (float dividend, float divisor)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_dsdiv

EXTERN cm48_sdcciyp_dread2, am48_ddiv, cm48_sdcciyp_m482d

cm48_sdcciyp_dsdiv:

   ; divide two sdcc floats
   ;
   ; enter : stack = sdcc_float divisor, sdcc_float dividend, ret
   ;
   ; exit  : dehl = sdcc_float(dividend/divisor)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   call cm48_sdcciyp_dread2

   ; AC = divisor
   ; AC'= dividend
   
   call am48_ddiv
   
   jp cm48_sdcciyp_m482d
