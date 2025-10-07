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
;

    defb    '1', 'w', 's', 'x',  11,   8, ':', 255    ;1, w, s, x, UP, BS, ", UN 80
    defb     27, 'q', 'a', 'z',  10,  13, ':', '/'    ;ESC, q, a, z, DOWN, RET, :, / 81
    defb    '3', 'r', 'f', 'v',   8, '-', ']', 255    ;3, r, f, v, LEFT, =, }, UN 82
    defb    '2', 'e', 'd', 'c',   9, '^','\\', ' '    ;2, e, d, c, RIGHT, ~, \, SP 83
    defb    '5', 'y', 'h', 'n', 130, '0', 'p', 255    ;5, y, h, n, F3, 0, p, UN 84
    defb    '4', 't', 'g', 'b', 131, '-', '[', 255    ;4, t, g, b, F4, ~, {, UN 85 
    defb    '6', 'u', 'j', 'm', 129, '9', 'o', 255    ;6, u, j, m, F2, 9, o, UN 86
    defb    '7', 'i', 'k', ',', 128, '8', 'l', '.'    ;7, i, k, ,, F1, 8, l, STOP 87

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


