
; unsigned char __fs2uchar_fastcall(float f)

SECTION code_fp_math48

PUBLIC cm48_sdcciyp_ds2uchar_fastcall

EXTERN cm48_sdcciyp_dcallee1, am48_dfix8u

cm48_sdcciyp_ds2uchar_fastcall:

   ; double to unsigned char
   ;
   ; enter : stack = sdcc_float x, ret
   ;
   ; exit  : l = (unsigned char)(x)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   call cm48_sdcciyp_dcallee1    ; AC'= math48(x)

   jp am48_dfix8u
