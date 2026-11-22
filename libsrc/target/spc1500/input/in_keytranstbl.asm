; Samsung SPC-1500 keyboard: the codes for in_Inkey and in_LookupKey
;
; Three tables of 80 (10 rows of 8 keys: row n is read at I/O port
; $1900 + n and a key down is a 1 bit): unshifted, SHIFT, CTRL.  255 = no
; code.  Made by tools/spc1500_keys.py from MAME's matrix
; (samsung/spc1500.cpp).  Cursor keys 11 up, 10 down, 8 left, 9 right,
; RETURN 13, ESC 27, Backspace 12 (z88dk's DEL; shifted 127), F1-F5 128-132.
; The modifiers are in row 0: SHIFT bit 1, CTRL bit 2, Break bit 4, Graph
; bit 6.  No code: Caps, Tab, Home, Del/Ins, Hangul, Graph, Break.

    SECTION rodata_clib
    PUBLIC  in_keytranstbl

in_keytranstbl:
 ; Unshifted
    defb    255, 255, 255, 255, 255, '\\', 255, 255    ; 0: - Shift Ctrl - Break \\| Graph -
    defb    '=', 9, 32, 13, 'c', 'a', 'q', '1'    ; 1: =+ Right Space Return C A Q 1!
    defb    255, 8, 'z', ']', 'v', 's', 'w', '2'    ; 2: Caps Left Z ]} V S W 2@
    defb    12, 11, 27, '`', 'b', 'd', 'e', '3'    ; 3: Backspace UTF8_UP ESC `~ B D E 3#
    defb    255, 10, 255, 255, 'n', 'f', 'r', '4'    ; 4: DelIns Down Tab Home N F R 4$
    defb    255, 128, 255, 255, 'm', 'g', 't', '5'    ; 5: - F1 - - M G T 5%
    defb    255, 129, '[', 'x', ',', 'h', 'y', '6'    ; 6: - F2 [{ X ,< H Y 6^
    defb    255, 130, 255, 'p', '.', 'j', 'u', '7'    ; 7: - F3 - P .> J U 7&
    defb    255, 131, 255, 39, '/', 'k', 'i', '8'    ; 8: - F4 - \'\ /? K I 8*
    defb    255, 132, '-', '0', ';', 'l', 'o', '9'    ; 9: Hangul F5 -_ 0) ;: L O 9(

 ; SHIFT
    defb    255, 255, 255, 255, 255, '|', 255, 255    ; 0: - Shift Ctrl - Break \\| Graph -
    defb    '+', 9, 32, 13, 'C', 'A', 'Q', '!'    ; 1: =+ Right Space Return C A Q 1!
    defb    255, 8, 'Z', '}', 'V', 'S', 'W', '@'    ; 2: Caps Left Z ]} V S W 2@
    defb    127, 11, 27, '~', 'B', 'D', 'E', '#'    ; 3: Backspace UTF8_UP ESC `~ B D E 3#
    defb    255, 10, 255, 255, 'N', 'F', 'R', '$'    ; 4: DelIns Down Tab Home N F R 4$
    defb    255, 128, 255, 255, 'M', 'G', 'T', '%'    ; 5: - F1 - - M G T 5%
    defb    255, 129, '{', 'X', '<', 'H', 'Y', '^'    ; 6: - F2 [{ X ,< H Y 6^
    defb    255, 130, 255, 'P', '>', 'J', 'U', '&'    ; 7: - F3 - P .> J U 7&
    defb    255, 131, 255, 34, '?', 'K', 'I', '*'    ; 8: - F4 - \'\ /? K I 8*
    defb    255, 132, '_', ')', ':', 'L', 'O', '('    ; 9: Hangul F5 -_ 0) ;: L O 9(

 ; CTRL
    defb    255, 255, 255, 255, 255, 255, 255, 255    ; 0: - Shift Ctrl - Break \\| Graph -
    defb    255, 9, 32, 13, 3, 1, 17, 255    ; 1: =+ Right Space Return C A Q 1!
    defb    255, 8, 26, 255, 22, 19, 23, 255    ; 2: Caps Left Z ]} V S W 2@
    defb    12, 11, 27, 255, 2, 4, 5, 255    ; 3: Backspace UTF8_UP ESC `~ B D E 3#
    defb    255, 10, 255, 255, 14, 6, 18, 255    ; 4: DelIns Down Tab Home N F R 4$
    defb    255, 128, 255, 255, 13, 7, 20, 255    ; 5: - F1 - - M G T 5%
    defb    255, 129, 255, 24, 255, 8, 25, 255    ; 6: - F2 [{ X ,< H Y 6^
    defb    255, 130, 255, 16, 255, 10, 21, 255    ; 7: - F3 - P .> J U 7&
    defb    255, 131, 255, 255, 255, 11, 9, 255    ; 8: - F4 - \'\ /? K I 8*
    defb    255, 132, 255, 255, 255, 12, 15, 255    ; 9: Hangul F5 -_ 0) ;: L O 9(

