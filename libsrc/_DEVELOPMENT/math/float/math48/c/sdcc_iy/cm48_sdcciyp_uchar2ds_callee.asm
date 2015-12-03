
; float __uchar2fs_callee(unsigned char uc)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_uchar2ds_callee

EXTERN am48_double8u, cm48_sdcciyp_m482d

cm48_sdcciyp_uchar2ds_callee:

   ; unsigned char to double
   ;
   ; enter : stack = unsigned char uc, ret
   ;
   ; exit  : dehl = sdcc_float(uc)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   pop af
   pop hl
   dec sp
   push af

   call am48_double8u
   
   jp cm48_sdcciyp_m482d
