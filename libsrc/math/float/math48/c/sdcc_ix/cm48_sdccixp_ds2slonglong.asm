
; signed long long __fs2slonglong (float f)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccixp_ds2slonglong

EXTERN cm48_sdccixp_dread3, am48_dfix64, l_store_64_dehldehl_mbc

cm48_sdccixp_ds2slonglong:

   ; double to signed long long
   ;
   ; enter : stack = sdcc_float x, result *, ret
   ;
   ; exit  : *result = (long long)(x)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   call cm48_sdccixp_dread3    ; AC'= math48(x)
   
   call am48_dfix64            ; dehl'dehl = 64-bit integer
   
   pop af
   pop bc                      ; bc = result *
   
   push bc
   push af
   
   jp l_store_64_dehldehl_mbc
