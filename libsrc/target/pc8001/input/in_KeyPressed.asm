; uint in_KeyPressed(uint scancode)

    SECTION code_clib
    PUBLIC  in_KeyPressed
    PUBLIC  _in_KeyPressed

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row (bit 7 = SHIFT needed, bit 6 = CTRL needed)
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

in_KeyPressed:
_in_KeyPressed:
    push    hl
    ld      bc, 8                       ;modifier row, b = 0 so the port is just $08
    in      a, (c)
    pop     hl
    cpl
    and     @11000000                   ;CTRL + SHIFT
    bit     7, l
    jr      z, noshift
    bit     6, a                        ;SHIFT wanted, is it down?
    jr      z, fail
    res     6, a
noshift:
    bit     6, l
    jr      z, noctrl
    bit     7, a                        ;CTRL wanted, is it down?
    jr      z, fail
    res     7, a
noctrl:
    and     a                           ;Any modifier left that we didn't want fails
    jr      nz, fail
    ld      a, l
    and     15
    ld      c, a
    ld      b, 0
    in      a, (c)
    cpl
    and     h                           ;Check with mask
    jr      z, fail
    ld      hl, 1
    scf
    ret
fail:
    ld      hl, 0
    and     a
    ret
