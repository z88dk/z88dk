SECTION code_clib
SECTION code_l_xcc

PUBLIC __sdiv16
PUBLIC __xcc_divsint

EXTERN l_divs_16_16x16

; 16-bit signed division (xcc sdcccall(1) runtime ABI).
; Exposed as __sdiv16 (xcc's own name) and __xcc_divsint (renamed via
; lib/xcc_rules.1 to sidestep sdcc's stack-based __divsint in the same crt0
; archive).
;
; enter : hl = dividend, de = divisor
; exit  : de = quotient, hl = remainder (sign of dividend)
; uses  : af, bc, de, hl

__sdiv16:
__xcc_divsint:
   call l_divs_16_16x16    ; hl = quotient, de = remainder
   ex de,hl                ; xcc returns de = quotient, hl = remainder
   ret
