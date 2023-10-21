
SECTION code_clib
SECTION code_math

PUBLIC l_kc160_divu_32_32x16, l0_kc160_divu_32_32x16

EXTERN error_divide_by_zero_mc


   ; compute:  dehl = dehl / bc, dehl' = dehl % bc
   ; alters :  af, bc, de, hl, bc', de', hl', ix

   ; alternate entry (l0_divu_32_32x16)
   ; skips divide by zero check

l_kc160_divu_32_32x16:

   ld a,b
   or c
   jr z,divide_zero

l0_kc160_divu_32_32x16:
   div dehl,bc
   push de   ; remainder
   exx
   pop hl
   ld de,0   ; extend out remainder
   exx
   ld de,0   ; extend out result
   ret

divide_zero:

   dec de
   jp error_divide_by_zero_mc
