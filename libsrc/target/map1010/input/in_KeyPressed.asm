; uint in_KeyPressed(uint scancode)

    SECTION code_clib
    PUBLIC  in_KeyPressed
    PUBLIC  _in_KeyPressed

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

in_KeyPressed:
_in_KeyPressed:
    // Check for modifiers
    ld      c,0         ;The modifiers we read
    ld      a,($7852)   ;control
    rra
    ccf
    rl      c
    ld      a,($7850)   ;lshift
    rra
    ccf
    rl      c
    ld      a,($7851)   ;rshift
    rra
    ccf
    rl      c
    ld      a,c
    bit     7,h                     ;Is shift needed?
    jr      z,nocaps
    and     @00000011
    jr      z,fail
    ld      a,c                     ;Just ctrl to check now
    and     @00000100
nocaps:
    bit     6,h                     ;Is control needed?
    jr      z,noctrl
    bit     2,a
    jr      z,fail
    res     2,a

noctrl:
    and     a                       ;We should have swallowed all modifiers if we match
    jr      nz,fail

    ld      h, $78       ;first keyboard row
    ld      a,(hl)
    and     a
    jr      nz,fail
    ld      hl, 1
    scf
    ret
fail:
    ld      hl, 0
    and     a
    ret


