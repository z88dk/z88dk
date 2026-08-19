
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

   ; div dehl,bc is 32/16 with 16-bit quot in HL and rem in DE.
   ; two passes: qMSW = nMSW / D, then (rem:nLSW) / D.

   push hl                     ; nLSW
   ex de,hl                    ; HL = nMSW
   ld de,0
   div dehl,bc                 ; HL = qMSW, DE = rem
   ex (sp),hl                  ; HL = nLSW, (sp) = qMSW
   div dehl,bc                 ; HL = qLSW, DE = rem
   ex de,hl                    ; HL = rem, DE = qLSW
   ex (sp),hl                  ; HL = qMSW, (sp) = rem
   ex de,hl                    ; dehl = quotient
   exx
   pop hl
   ld de,0                     ; dehl' = remainder
   exx
   and a
   ret

divide_zero:

   dec de
   jp error_divide_by_zero_mc
