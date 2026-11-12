; Sharp MZ-800 keyboard joystick scan codes
;
; in_KeyPressed scan codes are (key mask << 8) | strobe, as in_LookupKey makes them (the matrix is in input/in_keytranstbl.asm).

    SECTION rodata_clib
    PUBLIC  keys_cursor
    PUBLIC  keys_qaop
    PUBLIC  keys_vi
    PUBLIC  keys_8246

; Entries are RIGHT, LEFT, DOWN, UP, FIRE1, FIRE2, FIRE3, FIRE4.
keys_cursor:
    defw    $0807, $0407, $1007, $2007, $1006, $0000, $0000, $0000 ; the cursor keys (strobe 7), space (strobe 6 bit 4)

keys_qaop:
    defw    $0103, $0203, $8004, $8002, $1006, $0000, $0000, $0000 ; P (strobe 3 bit 0), O, A (strobe 4 bit 7), Q (strobe 2 bit 7), space

keys_vi:
    defw    $1003, $0104, $4003, $2003, $2002, $1004, $0000, $0000 ; L (strobe 3 bit 4), H (strobe 4 bit 0), J (strobe 3 bit 6), K (strobe 3 bit 5), S (strobe 2 bit 5), D (strobe 4 bit 4)

keys_8246:
    defw    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; (no keypad)
