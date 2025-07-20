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

    in      a, (0xb0)
    bit     7, l
    jr      z, nocaps
    and     @00000011
    jr      z,fail
    jr      check_control
nocaps:
    and     @00000011           ;both shift keys
    jr      nz,fail

check_control:
    in      a,(0xb1)
    bit     6,l
    jr      z,noctrl
    and     @00000010
    jr      z,fail
    jr      check_key
noctrl:
    and     @00000010
    jr      nz,fail

check_key:
    ld      a,l
    and     15
    add     $b0
    ld      c,a
    ld      b,0
    in      a,(c)
    and     h       ;check with mask
    jr      z,fail
    ld      hl, 1
    scf
    ret
fail:
    ld      hl, 0
    and     a
    ret


