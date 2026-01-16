
; signed long long __fs2slonglong (float f)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_ds2slonglong_callee

EXTERN cm48_sdccixp_d2m48, am48_dfix64, l_store_64_dehldehl_mbc

cm48_sdccixp_ds2slonglong_callee:

   ; double to signed long long
   ;
   ; enter : stack = sdcc_float x, result *, ret
   ;
   ; exit  : *result = (long long)(x)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   pop af
   pop bc
   pop de
   pop hl
   push af
   
   push bc                     ; save result *
   
   call cm48_sdccixp_d2m48     ; AC'= math48(x)
   
   call am48_dfix64            ; dehl'dehl = 64-bit result
   
   pop bc                      ; bc = result *

   jp l_store_64_dehldehl_mbc
