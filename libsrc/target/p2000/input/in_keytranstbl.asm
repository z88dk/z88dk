; Based on the code mapping used by MAME
; This table translates key presses into ascii codes.


    SECTION rodata_clib
    PUBLIC  in_keytranstbl
    PUBLIC  _in_keytranstbl

in_keytranstbl:
_in_keytranstbl:

   ; --- UNSHIFTED (Row 0 to 8) ---

    defb    28,  '6', 29,  'q', '3', '5', '7', '4'  ; Port 0: Left, 6, Up, q, 3, 5, 7, 4
    defb    9,   'h', 'z', 's', 'd', 'g', 'j', 'f'  ; Port 1: Tab, h, z, s, d, g, j, f
    defb    '.', ' ', 1,   '0', '#', 30,  ',', 31   ; Port 2: Pad ., Space, Pad 00, Pad 0, #, Down, ,, Right
    defb    255, 'n', '<', 'x', 'c', 'b', 'm', 'v'  ; Port 3: SHIFT LOCK, n, <, x, c, b, m, v
    defb    27,  'y', 'a', 'w', 'e', 't', 'u', 'r'  ; Port 4: Code(Esc), y, a, w, e, t, u, r
    defb    2,   '9', '+', '-', 8,   '0', '1', '-'  ; Port 5: Clrln, 9, *, /, BS, 0, 1, -
    defb    '9', 'o', '8', '7', 13,  'p', '8', '@'  ; Port 6: Pad9, o, Pad8, Pad7, Enter, p, 8, @
    defb    '3', '.', '2', '1', 4,   '/', 'k', '2'  ; Port 7: Pad3, ., Pad2, Pad1, ->/<- , /, k, 2
    defb    '6', 'l', '5', '4', 5,   ';', 'i', ':'  ; Port 8: Pad6, l, Pad5, Pad4, 1/4, ;, i, '

   ; --- SHIFTED (Row 0 to 8) ---

    defb    0,   '&', 0,   'Q', 156, '%', 39,  '$'  ; Port 0: (156 is Pound sign)
    defb    9,   'H', 'Z', 'S', 'D', 'G', 'J', 'F'  ; Port 1
    defb    ',', ' ', 0,   '0', 0,   0,   ',', 0    ; Port 2
    defb    255, 'N', '>', 'X', 'C', 'B', 'M', 'V'  ; Port 3
    defb    27,  'Y', 'A', 'W', 'E', 'T', 'U', 'R'  ; Port 4
    defb    0,   ')', '*', '/', 8,   '=', '!', '_'  ; Port 5
    defb    '9', 'O', '8', '7', 13,  'P', '(', '^'  ; Port 6
    defb    '3', '.', '2', '1', 0,   '?', 'K', '"'  ; Port 7
    defb    '6', 'L', '5', '4', 0,   '+', 'I', '*'  ; Port 8