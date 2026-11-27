; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.
;
; Keys are numbered row * 8 + bit, for rows 0 - 9 (ports $00 - $09).
; Each table is 80 bytes. 255 marks a key with no code.
; Cursor keys follow the keyboard: SHIFT + UP is down, SHIFT + RIGHT is left.
; Function keys are 128 - 132 (F1 - F5) and 133 - 137 (SHIFT + F1 - F5)

    SECTION rodata_clib
    PUBLIC  in_keytranstbl

in_keytranstbl:

; Unshifted
    defb    '0', '1', '2', '3', '4', '5', '6', '7'    ; row 0: 0 1 2 3 4 5 6 7 (numpad)
    defb    '8', '9', '*', '+', '=', ',', '.', 13    ; row 1: 8 9 * + = , . RETURN (numpad)
    defb    '@', 'a', 'b', 'c', 'd', 'e', 'f', 'g'    ; row 2: @ a-g
    defb    'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o'    ; row 3: h-o
    defb    'p', 'q', 'r', 's', 't', 'u', 'v', 'w'    ; row 4: p-w
    defb    'x', 'y', 'z', '[', '\\', ']', '^', '-'    ; row 5: x y z [ yen ] ^ -
    defb    '0', '1', '2', '3', '4', '5', '6', '7'    ; row 6: 0-7
    defb    '8', '9', ':', ';', ',', '.', '/', '_'    ; row 7: 8 9 : ; , . / _
    defb    12, 11, 9, 8, 255, 255, 255, 255    ; row 8: HOME UP RIGHT DEL GRPH KANA SHIFT CTRL
    defb    3, 128, 129, 130, 131, 132, ' ', 27    ; row 9: STOP F1-F5 SPACE ESC

; Shifted
    defb    '0', '1', '2', '3', '4', '5', '6', '7'    ; row 0: 0 1 2 3 4 5 6 7 (numpad)
    defb    '8', '9', '*', '+', '=', ',', '.', 13    ; row 1: 8 9 * + = , . RETURN (numpad)
    defb    '`', 'A', 'B', 'C', 'D', 'E', 'F', 'G'    ; row 2: @ a-g
    defb    'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O'    ; row 3: h-o
    defb    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W'    ; row 4: p-w
    defb    'X', 'Y', 'Z', '{', '|', '}', '~', '='    ; row 5: x y z [ yen ] ^ -
    defb    '0', '!', '"', '#', '$', '%', '&', '\''    ; row 6: 0-7
    defb    '(', ')', '*', '+', '<', '>', '?', '_'    ; row 7: 8 9 : ; , . / _
    defb    12, 10, 8, 255, 255, 255, 255, 255    ; row 8: HOME UP RIGHT DEL GRPH KANA SHIFT CTRL
    defb    3, 133, 134, 135, 136, 137, ' ', 27    ; row 9: STOP F1-F5 SPACE ESC

; Control
    defb    '0', '1', '2', '3', '4', '5', '6', '7'    ; row 0: 0 1 2 3 4 5 6 7 (numpad)
    defb    '8', '9', '*', '+', '=', ',', '.', 13    ; row 1: 8 9 * + = , . RETURN (numpad)
    defb    255, 1, 2, 3, 4, 5, 6, 7    ; row 2: @ a-g
    defb    8, 9, 10, 11, 12, 13, 14, 15    ; row 3: h-o
    defb    16, 17, 18, 19, 20, 21, 22, 23    ; row 4: p-w
    defb    24, 25, 26, '[', '\\', ']', '^', '-'    ; row 5: x y z [ yen ] ^ -
    defb    '0', '1', '2', '3', '4', '5', '6', '7'    ; row 6: 0-7
    defb    '8', '9', ':', ';', ',', '.', '/', '_'    ; row 7: 8 9 : ; , . / _
    defb    12, 11, 9, 8, 255, 255, 255, 255    ; row 8: HOME UP RIGHT DEL GRPH KANA SHIFT CTRL
    defb    3, 128, 129, 130, 131, 132, ' ', 27    ; row 9: STOP F1-F5 SPACE ESC
