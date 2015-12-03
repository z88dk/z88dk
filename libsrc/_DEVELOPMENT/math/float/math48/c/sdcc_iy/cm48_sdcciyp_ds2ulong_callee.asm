
; signed long __fs2ulong_callee(float f)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_ds2ulong_callee

EXTERN cm48_sdcciyp_dcallee1, am48_dfix32u

cm48_sdcciyp_ds2ulong_callee:

   ; double to unsigned long
   ;
   ; enter : stack = sdcc_float x, ret
   ;
   ; exit  : dehl = (unsigned long)(x)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   call cm48_sdcciyp_dcallee1    ; AC'= math48(x)

   jp am48_dfix32u
