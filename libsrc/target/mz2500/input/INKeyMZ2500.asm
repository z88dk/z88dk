; Sharp MZ-2500 keyboard: shared code for in_Inkey, in_KeyPressed and in_LookupKey
;
; The keyboard is 12 columns of 8 keys read through the Z80 PIO: the column number and bit 4 are written to port A's data ($E8), the keys are read from
; port B's data ($EA), where a key that is down is a 0 bit.  Column 11 has the modifiers: GRPH bit 0, SLOCK 1, SHIFT 2, KANA 3, CTRL 4.

    SECTION code_clib
    PUBLIC  INKeyMZ2500Init
    PUBLIC  INKeyMZ2500Col

; Port A to output, port B to input
; uses : A
INKeyMZ2500Init:
    ld      a, $0f
    out     ($e9), a
    ld      a, $4f
    out     ($eb), a
    ret

; enter: A = column (0..11)
; exit : A = the keys of the column, a 0 bit for each that is down
; uses : AF, D
INKeyMZ2500Col:
    ld      d, a
    in      a, ($e8)
    and     $e0
    or      $10
    or      d
    out     ($e8), a
    in      a, ($ea)
    ret
