SECTION code_clib
SECTION code_l_xcc

PUBLIC __mod16
PUBLIC __xcc_moduint

EXTERN l_divu_16_16x16

; 16-bit unsigned modulus (xcc sdcccall(1) runtime ABI)
;
; enter : hl = dividend, de = divisor
; exit  : de = dividend % divisor
; uses  : af, bc, de, hl
;
; l_divu_16_16x16 leaves the remainder in de.

defc __mod16 = l_divu_16_16x16
defc __xcc_moduint = __mod16
