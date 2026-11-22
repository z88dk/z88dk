; Samsung SPC-1500 keyboard: shared code for in_Inkey, in_KeyPressed and
; in_LookupKey
;
; 10 rows of 8 keys, each read at I/O port $1900 + the row (the high byte of the
; 16 bit port address is $19), a key down reading as a 1.  Row 0 has the
; modifiers: SHIFT bit 1,
; CTRL bit 2 (and Break bit 4, Graph bit 6).

    SECTION code_clib
    PUBLIC  INKeySPC1500Init
    PUBLIC  INKeySPC1500Col

; Nothing to set up
INKeySPC1500Init:
    ret

; enter: A = row (0..9)
; exit : A = the keys of the row, a 1 bit for each that is down
; uses : AF, BC
INKeySPC1500Col:
    ld      bc, $1900
    ld      c, a
    in      a, (c)
    ret
