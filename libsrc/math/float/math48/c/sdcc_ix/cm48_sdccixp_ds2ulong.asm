
; signed long __fs2ulong (float f)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_ds2ulong

EXTERN cm48_sdccixp_dread1, am48_dfix32u

cm48_sdccixp_ds2ulong:

   ; double to unsigned long
   ;
   ; enter : stack = sdcc_float x, ret
   ;
   ; exit  : dehl = (unsigned long)(x)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   call cm48_sdccixp_dread1    ; AC'= math48(x)

   jp am48_dfix32u
