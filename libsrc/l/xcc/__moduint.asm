SECTION code_clib
SECTION code_l_xcc

PUBLIC __mod16
PUBLIC __moduint

EXTERN l_divu_16_16x16

; 16-bit unsigned modulus (xcc sdcccall(1) runtime ABI)
;
; enter : hl = dividend, de = divisor
; exit  : de = dividend % divisor
; uses  : af, bc, de, hl

__mod16:
__moduint:
   jp l_divu_16_16x16      ; hl = quotient, de = remainder — xcc wants de = remainder
