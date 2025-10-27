SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_f2ullong

EXTERN am48_dfix64u, l_store_64_dehldehl_mbc, __i64_acc

cm48_sccz80p_f2ullong:

   ; double to unsigned long long
   ;
   ; enter : result *, ret
   ;         AC'(BCDEHL') = double x
   ;
   ; exit  : *result = (unsigned long long)(x)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'


   call am48_dfix64u           ; dehl'dehl = 64-bit integer

   ld bc,__i64_acc
   jp l_store_64_dehldehl_mbc

