; uint in_Inkey(void)
;
; Read the current state of the PC-8001 keyboard matrix. Ten rows are
; read from ports $00 - $09 (active low). Row 8 also holds the modifier
; keys: bit 6 = SHIFT, bit 7 = CTRL.

    SECTION code_clib
    PUBLIC  in_Inkey
    PUBLIC  _in_Inkey
    EXTERN  in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

in_Inkey:
_in_Inkey:
    ld      de, 0                       ;e = row * 8
    ld      c, 0
inkey_row:
    ld      b, 0
    in      a, (c)
    cpl
    ld      b, a
    ld      a, c
    cp      8
    ld      a, b
    jr      nz, not_modifier_row
    and     @00001111                   ;SHIFT, CTRL, GRPH and KANA are not keys
not_modifier_row:
    and     a
    jr      nz, gotkey
    ld      a, e
    add     8
    ld      e, a
    inc     c
    ld      a, c
    cp      10
    jr      nz, inkey_row
nokey:
    ld      hl, 0
    scf
    ret

gotkey:
    ; a = keys pressed in the row, e = offset of the row
find_bit:
    rrca
    jr      c, got_bit
    inc     e
    jr      find_bit
got_bit:
    ; e = key number, now pick the table from the modifiers
    ld      bc, 8                       ;b = 0 so the port is just $08
    in      a, (c)
    cpl
    ld      bc, 80*2                    ;CTRL
    bit     7, a
    jr      nz, got_modifier
    ld      bc, 80                      ;SHIFT
    bit     6, a
    jr      nz, got_modifier
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
