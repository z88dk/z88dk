
; signed long long __fs2ulonglong (float f)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_ds2ulonglong_callee

EXTERN cm48_sdccixp_d2m48, am48_dfix64u, l_store_64_dehldehl_mbc

cm48_sdccixp_ds2ulonglong_callee:

   ; double to unsigned long long
   ;
   ; enter : stack = sdcc_float x, result *, ret
   ;
   ; exit  : *result = (unsigned long long)(x)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   pop af
   pop bc
   pop de
   pop hl
   push af
   
   push bc                     ; save result *
   
   call cm48_sdccixp_d2m48     ; AC'= math48(x)
   
   call am48_dfix64u           ; dehl'dehl = 64-bit result
   
   pop bc                      ; bc = result *

   jp l_store_64_dehldehl_mbc
