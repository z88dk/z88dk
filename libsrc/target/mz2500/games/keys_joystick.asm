; Sharp MZ-2500 keyboard joystick scan codes
;
; in_KeyPressed scan codes are (key bit << 8) | column.  The keyboard matrix
; is defined by the column tables in input/in_keytranstbl.asm.

    SECTION rodata_clib
    PUBLIC  keys_cursor
    PUBLIC  keys_qaop
    PUBLIC  keys_vi
    PUBLIC  keys_8246

; Entries are RIGHT, LEFT, DOWN, UP, FIRE1, FIRE2, FIRE3, FIRE4.
keys_cursor:
    defw    $4003, $2003, $1003, $0803, $0203, $0000, $0000, $0000 ; cursor, space

keys_qaop:
    defw    $8005, $0206, $0204, $0106, $2005, $4005, $0000, $0000 ; O, Q, A, P, M, N

keys_vi:
    defw    $1005, $0105, $0405, $0805, $0806, $1004, $0000, $0000 ; L, H, J, K, S, D

keys_8246:
    defw    $4002, $1002, $0402, $0401, $0102, $2002, $0000, $0000 ; keypad 6, 4, 2, 8, 0, 5
