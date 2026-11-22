; uint in_KeyPressed(uint scancode)

    SECTION code_clib
    PUBLIC  in_KeyPressed
    PUBLIC  _in_KeyPressed
    EXTERN  INKeyMZ2500Init
    EXTERN  INKeyMZ2500Col

; Determines if a key is pressed using the scan code returned by in_LookupKey.

; enter : l = column (bits 3..0) + flags: bit 7 SHIFT needs to be down, bit 6 CTRL needs to be down
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; The modifiers must be as the flags say (neither down if there are none), except for the keys of column 11 (the modifiers themselves).
; used  : AF,BC,DE,HL

in_KeyPressed:
_in_KeyPressed:
    call    INKeyMZ2500Init
    ld      a, l
    and     15
    cp      11
    jr      z, read                     ; (a modifier: whatever else is down)
    ld      a, 11
    call    INKeyMZ2500Col
    cpl
    ld      c, 0                        ; the modifiers down: bit 7 SHIFT, bit 6 CTRL
    bit     2, a
    jr      z, nshift
    set     7, c
nshift:
    bit     4, a
    jr      z, nctrl
    set     6, c
nctrl:
    ld      a, l
    and     $c0
    cp      c
    jr      nz, fail
read:
    ld      a, l
    and     15
    call    INKeyMZ2500Col
    and     h
    jr      nz, fail                    ; (a 0 bit is a key down)
    ld      hl, 1
    scf
    ret

fail:
    ld      hl, 0
    and     a
    ret
