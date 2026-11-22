SECTION code_clib
SECTION code_l_xcc

PUBLIC __xcc_shl16

; XCC outlined 16-bit variable left shift. -Os calls this instead of
; repeating the inline shift ladder at every site.
;
; enter : HL = value, B = shift count (low 8 bits)
; exit  : HL = value << count
; uses  : AF, B, HL
;
; A zero count must return early: djnz with B = 0 would run 256 times.

__xcc_shl16:
    ld a,b
    or a
    ret z
xcc_shl16_loop:
    add hl,hl
    djnz xcc_shl16_loop
    ret
