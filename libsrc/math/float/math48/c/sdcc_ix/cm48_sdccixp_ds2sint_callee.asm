
; signed int __fs2sint_callee(float f)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_ds2sint_callee

EXTERN cm48_sdccixp_dcallee1, am48_dfix16

cm48_sdccixp_ds2sint_callee:

   ; double to signed int
   ;
   ; enter : stack = sdcc_float x, ret
   ;
   ; exit  : hl = (int)(x)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   call cm48_sdccixp_dcallee1    ; AC'= math48(x)

   jp am48_dfix16
