; uint in_Inkey(void)
; 10.2025 suborb

    ; Read current state of keyboard

    SECTION code_clib
    PUBLIC  in_Inkey
    PUBLIC  _in_Inkey
    EXTERN  in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL


in_Inkey:
_in_Inkey:
    ld      de,0
    in      a,($80)
    cpl 
    and     @01111111
    jr      nz,gotkey
    ld      e,8
    in      a,($81)
    cpl
    and     a
    jr      nz,gotkey
    ld      e,16
    in      a,($82)
    cpl
    and     @01111111
    jr      nz,gotkey
    ld      e,24
    in      a,($83)
    cpl
    and     a
    jr      nz,gotkey
    ld      e,32
    in      a,($84)
    cpl
    and     @01111111
    jr      nz,gotkey
    ld      e,40
    in      a,($85)
    cpl
    and     @01111111
    jr      nz,gotkey
    ld      e,48
    in      a,($86)
    cpl
    and     @01111111
    jr      nz,gotkey
    ld      e,56
    in      a,($87)
    cpl
    and     a
    jr      nz,gotkey
    in      a,($88)
    cpl
    and     @00100000
    jr      nz,gotkey
nokey:
    ld      hl, 0
    scf
    ret

gotkey:
    ; a = key pressed
    ; e = offset
    ld      c, 8
hitkey_loop:
    rrca
    jr      c, doneinc
    inc     e
    dec     c
    jr      nz, hitkey_loop
doneinc:

	; Check for shift and control
    in      a, ($88)
    ld      bc, 72*2
    bit     3, a                        ; CTRL
    jr      z, got_modifier
    ld      bc, 72
    bit     2, a                        ;SHIFT
    jr      z, got_modifier
    ld      bc, 0
got_modifier:
    ld      hl, in_keytranstbl
    add     hl, bc
    add     hl, de
    ld      a, (hl)
    cp      255
    jr      z, nokey
    ld      l, a
    ld      h, 0
    and     a
    ret


