
; float __slonglong2fs (signed long long sl)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_slonglong2ds_callee

EXTERN cm48_sdccixp_dcallee3, am48_double64, cm48_sdccixp_m482d

cm48_sdccixp_slonglong2ds_callee:

   ; signed long long to double
   ;
   ; enter : stack = signed long long sl, ret
   ;
   ; exit  : dehl = sdcc_float(sl)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   call cm48_sdccixp_dcallee3  ; dehl'dehl = 64-bit s1
   
   call am48_double64

   jp cm48_sdccixp_m482d
