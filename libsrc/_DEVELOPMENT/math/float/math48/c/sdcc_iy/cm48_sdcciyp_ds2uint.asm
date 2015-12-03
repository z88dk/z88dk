
; signed int __fs2suint (float f)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_ds2uint

EXTERN cm48_sdcciyp_dread1, am48_dfix16u

cm48_sdcciyp_ds2uint:

   ; double to unsigned int
   ;
   ; enter : stack = sdcc_float x, ret
   ;
   ; exit  : hl = (unsigned int)(x)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   call cm48_sdcciyp_dread1    ; AC'= math48(x)

   jp am48_dfix16u
