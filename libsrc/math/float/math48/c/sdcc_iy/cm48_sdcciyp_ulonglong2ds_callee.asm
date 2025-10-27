
; float __ulonglong2fs (unsigned long long sl)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_ulonglong2ds_callee

EXTERN cm48_sdcciyp_dcallee3, am48_double64u, cm48_sdcciyp_m482d

cm48_sdcciyp_ulonglong2ds_callee:

   ; unsigned long long to double
   ;
   ; enter : stack = unsigned long long sl, ret
   ;
   ; exit  : dehl = sdcc_float(sl)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   call cm48_sdcciyp_dcallee3  ; dehl'dehl = 64-bit s1
   
   call am48_double64u

   jp cm48_sdcciyp_m482d
