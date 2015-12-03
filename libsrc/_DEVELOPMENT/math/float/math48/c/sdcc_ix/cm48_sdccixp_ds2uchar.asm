
; unsigned char __fs2uchar (float f)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_ds2uchar

EXTERN cm48_sdccixp_dread1, am48_dfix8u

cm48_sdccixp_ds2uchar:

   ; double to unsigned char
   ;
   ; enter : stack = sdcc_float x, ret
   ;
   ; exit  : l = (unsigned char)(x)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   call cm48_sdccixp_dread1    ; AC'= math48(x)

   jp am48_dfix8u
