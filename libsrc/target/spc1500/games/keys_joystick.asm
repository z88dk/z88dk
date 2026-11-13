; Samsung SPC-1500 keyboard joystick scan codes
;
; in_KeyPressed scan codes are (key mask << 8) | row, as in_LookupKey makes them
; (the matrix is in input/in_keytranstbl.asm).

    SECTION rodata_clib
    PUBLIC  keys_cursor
    PUBLIC  keys_qaop
    PUBLIC  keys_vi
    PUBLIC  keys_8246

; Entries are RIGHT, LEFT, DOWN, UP, FIRE1, FIRE2, FIRE3, FIRE4.
keys_cursor:
    defw    $0201, $0202, $0204, $0203, $0401, $0000, $0000, $0000 ; the cursor keys (right row 1 bit 1, left row 2, down row 4, up row 3), space (row 1 bit 2)

keys_qaop:
    defw    $0807, $4009, $2001, $4001, $0401, $0000, $0000, $0000 ; P (row 7 bit 3), O (row 9 bit 6), A (row 1 bit 5), Q (row 1 bit 6), space

keys_vi:
    defw    $2009, $2006, $2007, $2008, $2002, $2003, $0000, $0000 ; L (row 9 bit 5), H (row 6 bit 5), J (row 7 bit 5), K (row 8 bit 5), S (row 2 bit 5), D (row 3 bit 5)

keys_8246:
    defw    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000 ; (no keypad)
