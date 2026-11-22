; uint in_Inkey(void)

; Read current state of keyboard

    SECTION code_clib
    PUBLIC  in_Inkey
    PUBLIC  _in_Inkey
    EXTERN  in_keytranstbl
    EXTERN  INKeyMZ800Init
    EXTERN  INKeyMZ800Col

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code (the first key down in the matrix's order that has one)
; uses : AF,BC,DE,HL

in_Inkey:
_in_Inkey:
    call    INKeyMZ800Init
    ld      a, 8
    call    INKeyMZ800Col               ; the modifiers: SHIFT (bit 0) picks the second table, CTRL (bit 6) the third
    ld      hl, in_keytranstbl
    ld      bc, 80
    bit     0, a
    jr      nz, noshift
    add     hl, bc
noshift:
    bit     6, a
    jr      nz, noctrl
    ld      hl, in_keytranstbl + 160
noctrl:
    ld      e, 0
colloop:
    ld      a, e
    call    INKeyMZ800Col
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
    cp      10
    jr      nz, colloop
    ld      hl, 0
    scf
    ret

found:
    ld      l, a
    ld      h, 0
    and     a
    ret
