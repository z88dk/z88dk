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
; used  : AF,BC,DE,HL

in_KeyPressed:
_in_KeyPressed:
    ; Read modifiers
    ld      a,l
    and     @11000000
    ld      c,a
    ld      a, ($3800)
    cpl
    and     c
    cp      c
    jr      nz,fail

    ld      a,l 
    and     @00000111
    ld      e,a
    ld      d,0
    ld      c,h
    ld      hl,$3800
    add     hl,de
    ld      a,(hl)
    cpl
    and     c
    cp      c
    jr      nz,fail
    ld      hl,1
    scf
    ret

fail:
    ld      hl,0
    and     a
    ret


