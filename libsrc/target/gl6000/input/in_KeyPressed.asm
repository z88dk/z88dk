

; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed



; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

in_KeyPressed:
_in_KeyPressed:
    ; Collect the shift/control key status initially
    ; Rshift = 0x80 on row 4
    ; Lshift=  0x04 on row 0
    ; LALT =   0x01 on row 9
    ld      e,0
    ld      a,@11111110
    out     ($40),a
    in      a,($41)
    bit     6,a
    jr      nz,check_rshift
    set     7,e
check_rshift:
    ld      a,@11101111
    out     ($40),a
    in      a,($41)
    rlca
    jr      c,check_ctrl
    set     7,e
check_ctrl:
    ld      a,@11111101
    out     ($40),a
    in      a,($42)
    rrca
    jr      c,check_modifiers
    set     6,e
check_modifiers:
    ld      a,l
    and     @11000000
    cp      e
    jr      z,check_for_key
nokey:
    ld      hl,0
    and     a
    ret

check_for_key:
    ld      e,@11111110
    ld      a,l
rowfind:
    and     7
    jr      z,rotate_done
    scf
    rlc     e
    dec     a
    jr      rowfind
rotate_done:
    ld      a,e
    out     ($40),a
    in      a,($41)
    bit     3,l
    jr      z,rejoin
    in      a,($42)
rejoin:
    cpl
    and     h
    jr      z,nokey
    ld      hl,1
    scf
    ret
