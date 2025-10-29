
; float __fsmul_callee(float a1, float a2)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_dsmul_callee

EXTERN cm48_sdccixp_dcallee2, am48_dmul, cm48_sdccixp_m482d

cm48_sdccixp_dsmul_callee:

   ; multiply two sdcc floats
   ;
   ; enter : stack = sdcc_float a2, sdcc_float a1, ret
   ;
   ; exit  : dehl = sdcc_float(a1*a2)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   call cm48_sdccixp_dcallee2
   
   ; AC'= a2
   ; AC = a1
   
   call am48_dmul
   
   jp cm48_sdccixp_m482d
