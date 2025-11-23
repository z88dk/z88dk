
; signed long long __fs2ulonglong (float f)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_ds2ulonglong

EXTERN cm48_sdcciyp_dread3, am48_dfix64u, l_store_64_dehldehl_mbc

cm48_sdcciyp_ds2ulonglong:

   ; double to unsigned long long
   ;
   ; enter : stack = sdcc_float x, result *, ret
   ;
   ; exit  : *result = (unsigned long long)(x)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   call cm48_sdcciyp_dread3    ; AC'= math48(x)
   
   call am48_dfix64u           ; dehl'dehl = 64-bit integer
   
   pop af
   pop bc                      ; bc = result *
   
   push bc
   push af
   
   jp l_store_64_dehldehl_mbc
