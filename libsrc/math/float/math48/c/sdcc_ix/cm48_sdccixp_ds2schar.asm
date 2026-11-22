
; signed char __fs2schar (float f)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_ds2schar

EXTERN cm48_sdccixp_dread1, am48_dfix8

cm48_sdccixp_ds2schar:

   ; double to signed char
   ;
   ; enter : stack = sdcc_float x, ret
   ;
   ; exit  : l = (char)(x)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   call cm48_sdccixp_dread1    ; AC'= math48(x)

   jp am48_dfix8
