SECTION code_clib
SECTION code_l_xcc

PUBLIC __smod16
PUBLIC __modsint

EXTERN l_divs_16_16x16

; 16-bit signed modulus (xcc sdcccall(1) runtime ABI, C11 semantics)
; l_divs_16_16x16 leaves remainder in de with the sign of the dividend.
;
; enter : hl = dividend, de = divisor
; exit  : de = dividend % divisor
; uses  : af, bc, de, hl

__smod16:
__modsint:
   jp l_divs_16_16x16
