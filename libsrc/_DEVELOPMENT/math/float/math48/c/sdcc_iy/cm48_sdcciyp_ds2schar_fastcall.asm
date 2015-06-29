
; signed char __fs2schar_fastcall(float f)

SECTION code_fp_math48

PUBLIC cm48_sdcciyp_ds2schar_fastcall

EXTERN cm48_sdcciyp_dcallee1, am48_dfix8

cm48_sdcciyp_ds2schar_fastcall:

   ; double to signed char
   ;
   ; enter : stack = sdcc_float x, ret
   ;
   ; exit  : l = (char)(x)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   call cm48_sdcciyp_dcallee1    ; AC'= math48(x)

   jp am48_dfix8
