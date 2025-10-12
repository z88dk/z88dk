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
    in      a,($88)                     ;modifier row
    cpl
    and     @00001100                 ;shift + ctrl mask
    bit     7,l
    jr      z,nocaps
    bit     2,a
    jr      z,fail
    res     2,a
nocaps:
    bit     6,l
    jr      z,noctrl
    bit     3,a
    jr      z,fail
    res     2,a

noctrl:
    and     a                           ;If we have any modifiers set that we don't want, we fail
    jr      nz, fail
    ld      a, l
    and     15
    add     $80
    ld      c, a
    ld      b, $0
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


