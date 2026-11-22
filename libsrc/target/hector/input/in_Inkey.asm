; uint in_Inkey(void)

; Read current state of keyboard but only return
; keypress if a single key is pressed.

    SECTION code_clib
    PUBLIC  in_Inkey
    PUBLIC  _in_Inkey
    EXTERN  in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

in_Inkey:
_in_Inkey:

    ld      de, 0
    ld      hl,$3800
    ld      a,(hl)
    cpl
    and     @00111111
    jr      nz,gotkey
    inc     hl
    ld      e,8
    ld      b,7
readloop:
    ld      a,(hl)
    cpl
    and     a
    jr      nz,gotkey
    ld      a,e
    add     8
    ld      e,a
    inc     hl
    djnz    readloop
nokey:
    ld      hl,0
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

    ; check for shift/func etc
    ld      a,($3800)
    cpl
    ld      bc, 56
    rlca
    jr      c,done
    ld      c,112
    rlca
    jr      c,done
    ld      c,0
done:
    ld      hl,in_keytranstbl
    add     hl,bc
    add     hl,de
    ld      a, (hl)
    cp      255
    jr      z, nokey
    ld      l, a
    ld      h, 0
    and     a
    ret


