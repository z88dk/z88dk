SECTION code_clib
SECTION code_l_xcc

PUBLIC __mul16
PUBLIC __mulint

EXTERN l_mulu_16_16x16

; 16-bit multiplication (xcc sdcccall(1) runtime ABI)
;
; enter : hl = multiplicand, de = multiplier
; exit  : de = product (low 16)
; uses  : af, bc, de, hl

__mul16:
__mulint:
   call l_mulu_16_16x16    ; hl = hl * de
   ex de,hl                ; xcc returns product in de
   ret
