SECTION code_clib
SECTION code_l_xcc

PUBLIC __smod32
PUBLIC __modslong

EXTERN l_divs_32_32x32

; 32-bit signed modulus (xcc sdcccall(1) runtime ABI, C11: sign of dividend).
; l_divs_32_32x32 leaves the remainder in the shadow bank with the sign of
; the dividend, matching xcc's expected semantic.

__smod32:
__modslong:
   push ix
   ld ix,0
   add ix,sp

   ex de,hl
   exx

   ld l,(ix+4)
   ld h,(ix+5)
   ld e,(ix+6)
   ld d,(ix+7)

   call l_divs_32_32x32

   exx
   ex de,hl

   pop ix
   ret
