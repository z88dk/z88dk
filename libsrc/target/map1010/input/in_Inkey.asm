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
    ld      de,$7800
    ld      hl,in_keytranstbl
    ld      b,93
loop1:
    ld      a,(hl)
    inc     a
    jr      z,skip_read
    ld      a,(de)
    and     a
    jr      z,gotkey
skip_read:
    inc     hl
    inc     de
    djnz    loop1
nokey:
    ld      hl, 0
    scf
    ret
    
gotkey:
    ld      d,0


	; Check for shift and control
    ld      a,($7852)               ;Control
    ld      bc, 96*2
    and     a
    jr      z,got_modifier
    ld      bc, 96
    ld      a,($7850)               ;Lshift
    and     a
    jr      z,got_modifier
    ld      a,($7851)               ;Rshift
    and     a
    jr      z,got_modifier
    ld      bc, 0
got_modifier:
    ld      hl, in_keytranstbl
    add     hl, bc
    add     hl, de
    ld      a, (hl)
    cp      255
    jr      z, nokey
    cp      192
    jr      c,not_keypad
    sub     192
not_keypad:
    ld      l, a
    ld      h, 0
    and     a
    ret


