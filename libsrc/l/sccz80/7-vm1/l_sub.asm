;       Z88 Small C+ Run time Library
;
;       KR580VM1: DSUB D subtracts the pair where it already sits, so the
;       whole routine is the exchange and the subtract.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC    l_sub

; HL = DE - HL, carry set on borrow
;
; DE is left holding the original HL, which is what the exchange costs.
; Callers do not keep it: sccz80 reads only the result, and the one library
; caller (lib3d/turn_left, turn_right) reloads DE straight afterwards.
;
; The borrow matters as much as the result - turn_left does `ret nc` on it -
; and DSUB sets CY from the 16 bit subtract, as the byte-wise chain it
; replaces did from its final `sbc a,h`.

.l_sub
    ex de,hl
    sub hl,de
    ret
