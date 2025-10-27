
; float l_f48_sllong2f (signed long long sl)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_sllong2f

EXTERN l_load_64_dehldehl_mbc, am48_double64, __i64_acc

cm48_sccz80p_sllong2f:

   ; signed long long to double
   ;
   ; enter : stack = signed long long sl, ret
   ;
   ; exit  : AC'= (float)(n)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ld bc,__i64_acc
   
   call l_load_64_dehldehl_mbc  ; dehl'dehl = 64-bit s1
   
   jp am48_double64
