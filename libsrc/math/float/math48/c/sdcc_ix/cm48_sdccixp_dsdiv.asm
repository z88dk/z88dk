
; float __fsdiv (float dividend, float divisor)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_dsdiv

EXTERN cm48_sdccixp_dread2, am48_ddiv, cm48_sdccixp_m482d

cm48_sdccixp_dsdiv:

   ; divide two sdcc floats
   ;
   ; enter : stack = sdcc_float divisor, sdcc_float dividend, ret
   ;
   ; exit  : dehl = sdcc_float(dividend/divisor)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   call cm48_sdccixp_dread2

   ; AC = divisor
   ; AC'= dividend
   
   call am48_ddiv
   
   jp cm48_sdccixp_m482d
