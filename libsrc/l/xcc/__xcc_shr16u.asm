SECTION code_clib
SECTION code_l_xcc

PUBLIC __xcc_shr16u

; XCC outlined 16-bit variable logical right shift.
;
; enter : HL = value, B = shift count (low 8 bits)
; exit  : HL = value >> count, zero filled
; uses  : AF, B, HL
;
; A zero count must return early: djnz with B = 0 would run 256 times.

__xcc_shr16u:
    ld a,b
    or a
    ret z
xcc_shr16u_loop:
    srl h
    rr l
    djnz xcc_shr16u_loop
    ret
