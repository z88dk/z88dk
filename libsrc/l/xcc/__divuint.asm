SECTION code_clib
SECTION code_l_xcc

PUBLIC __div16
PUBLIC __xcc_divuint

EXTERN l_divu_16_16x16

; 16-bit unsigned division (xcc sdcccall(1) runtime ABI).
; Exposed as __div16 and __xcc_divuint — call sites emitted as __divuint are
; renamed via lib/xcc_rules.1 to sidestep sdcc's stack-based __divuint in the
; same crt0 archive.
;
; enter : hl = dividend, de = divisor
; exit  : de = quotient, hl = remainder
; uses  : af, bc, de, hl

__div16:
__xcc_divuint:
   call l_divu_16_16x16    ; hl = quotient, de = remainder
   ex de,hl                ; xcc returns de = quotient, hl = remainder
   ret
