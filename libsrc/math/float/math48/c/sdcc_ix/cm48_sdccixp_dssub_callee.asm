
; float __fssub_callee(float left, float right)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_dssub_callee

EXTERN cm48_sdccixp_dcallee2, am48_dsub, cm48_sdccixp_m482d

cm48_sdccixp_dssub_callee:

   ; subtract two sdcc floats
   ;
   ; enter : stack = sdcc_float right, sdcc_float left, ret
   ;
   ; exit  : dehl = sdcc_float(left-right)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   call cm48_sdccixp_dcallee2

   ; AC'= right
   ; AC = left

   exx
   call am48_dsub

   jp cm48_sdccixp_m482d
