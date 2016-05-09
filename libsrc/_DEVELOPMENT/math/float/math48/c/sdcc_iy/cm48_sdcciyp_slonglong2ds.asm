
; float __slonglong2fs (signed long long sl)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_slonglong2ds

EXTERN l_load_64_dehldehl_mbc, am48_double64, cm48_sdcciyp_m482d

cm48_sdcciyp_slonglong2ds:

   ; signed long long to double
   ;
   ; enter : stack = signed long long sl, ret
   ;
   ; exit  : dehl = sdcc_float(sl)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld hl,2
   add hl,sp
   
   ld c,l
   ld b,h
   
   call l_load_64_dehldehl_mbc  ; dehl'dehl = 64-bit s1
   
   call am48_double64

   jp cm48_sdcciyp_m482d
