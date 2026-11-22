; uint in_Inkey(void)

; Read current state of keyboard

    SECTION code_clib
    PUBLIC  in_Inkey
    PUBLIC  _in_Inkey
    EXTERN  in_keytranstbl
    EXTERN  INKeyMZ2500Init
    EXTERN  INKeyMZ2500Col

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code (the first key down in the matrix's order that has one)
; uses : AF,BC,DE,HL

in_Inkey:
_in_Inkey:
    call    INKeyMZ2500Init
    ld      a, 11
    call    INKeyMZ2500Col              ; the modifiers: SHIFT picks the second table, CTRL the third
    ld      hl, in_keytranstbl
    ld      bc, 96
    bit     2, a
    jr      nz, noshift
    add     hl, bc
noshift:
    bit     4, a
    jr      nz, noctrl
    ld      hl, in_keytranstbl + 192
noctrl:
    ld      e, 0
colloop:
    ld      a, e
    call    INKeyMZ2500Col
    cpl
    ld      d, a
    ld      b, 8
bitloop:
    srl     d
    jr      nc, nextbit
    ld      a, (hl)
    cp      $ff
    jr      nz, found
nextbit:
    inc     hl
    djnz    bitloop
    inc     e
    ld      a, e
    cp      11                          ; (not the modifiers)
    jr      nz, colloop
    ld      hl, 0
    scf
    ret

found:
    ld      l, a
    ld      h, 0
    and     a
    ret
