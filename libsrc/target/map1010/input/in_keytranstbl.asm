
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl


; 96 bytes per table
; https://takeda-toshiya.up.seesaa.net/image/SEIKO_MAP-1010_keyboard.JPG
;
; Note keypad keys are +192

;Unshifted
    defb    'z', 'x', 'c', 'v',     'b',     'n',     ' ',     'm'   ;z, x, c, v,  b, n, SP, m
    defb    ',', '.', '/', '_', 192+'0', 192+'-', 192+'+',     13    ;, , ., /, \ KP0, KP-, KP+, KPret+RETURN
    defb    'a', 's', 'd', 'f',     'g',     'h',     'j',     'k'   ;a, s, d, f, g, h, j, k
    defb    'l', ';', ':', ']', 192+'1', 192+'2', 192+'3', 192+'='   ;l, ;, :, ], KP1, KP2, KP3, KP=
    defb    'q', 'w', 'e', 'r',     't',     'y',     'u',     'i'   ;q, w, e, r, t, y, u, i
    defb    'o', 'p', '@', '[', 192+'4', 192+'5', 192+'6', 192+'*'   ;o, p, \, [ KP4, KP5, KP6, KP*

    defb    255, '3', '4', '5',     '6',     '7',     '8',     '9'   ;UN 3, 4, 5, 6, 7, 8, 9
    defb    '0', '-', '^', '_',      12, 192+'7', 192+'8', 192+'9'   ;0, -, =, ~, BS, KP7, KP8, KP9
    defb    '2', 255, '1',  27,    128+1,   128+2,   128+3,   128+4  ;2, UN, 1, ESC, F1, F2, F3, F4
    defb    255,   8,  9,  11,      10,     255,     255, 128+'/'   ;UN, LEFT, RIGHT, UP, DOWN, UN, UN KP/
    defb    255, 255, 255,   7,     255,     255,     255,    255    ;LSHIFT, RSHIFT, CTRL, GRAPH, UN, UN, UN, UN
    defb    255, 255, 255, 255,       6,     255,     255,    255    ;UN, UN, UN, UN, CAPS, UN, UN, UN


;Shifted
    defb    'Z', 'X', 'C', 'V',     'B',     'N',     ' ',     'M'   ;z, x, c, v,  b, n, SP, m
    defb    '<', '>', '?', '_', 192+'0', 192+'-', 192+'+',     13    ;, , ., /, \ KP0, KP-, KP+, KPret+RETURN
    defb    'A', 'S', 'D', 'F',     'G',     'H',     'J',     'K'   ;a, s, d, f, g, h, j, k
    defb    'L', '+', '*', '}', 192+'1', 192+'2', 192+'3', 192+'='   ;l, ;, :, ], KP1, KP2, KP3, KP=
    defb    'Q', 'W', 'E', 'R',     'T',     'Y',     'U',     'I'   ;q, w, e, r, t, y, u, i
    defb    'O', 'P', '`', '{', 192+'4', 192+'5', 192+'6', 192+'*'   ;o, p, \, [ KP4, KP5, KP6, KP*
    defb    255, '#', '$', '%',     '&',    '\'',     '(',     ')'   ;UN 3, 4, 5, 6, 7, 8, 9
    defb    '0', '=', '~', '|',     127, 192+'7', 192+'8', 192+'9'   ;0, -, =, ~, BS, KP7, KP8, KP9
    defb   '\"', 255, '!',  27,    128+1,   128+2,   128+3,   128+4  ;2, UN, 1, ESC, F1, F2, F3, F4
    defb    255,   8,  9,  11,      10,     255,     255, 128+'/'   ;UN, LEFT, RIGHT, UP, DOWN, UN, UN KP/
    defb    255, 255, 255,   7,     255,     255,     255,    255    ;LSHIFT, RSHIFT, CTRL, GRAPH, UN, UN, UN, UN
    defb    255, 255, 255, 255,       6,     255,     255,    255    ;UN, UN, UN, UN, CAPS, UN, UN, UN


;Control
    defb     26,  24,   3,  22,       2,      14,     ' ',     13    ;z, x, c, v,  b, n, SP, m
    defb    ',', '.', '/', '_', 192+'0', 192+'-', 192+'+',     13    ;, , ., /, \ KP0, KP-, KP+, KPret+RETURN
    defb      1,  19,   4,   6,       7,       8,      10,      11   ;a, s, d, f, g, h, j, k
    defb     12, ';', ':', ']', 192+'1', 192+'2', 192+'3', 192+'='   ;l, ;, :, ], KP1, KP2, KP3, KP=
    defb     17,  23,   5,  18,      20,      25,      21,       9   ;q, w, e, r, t, y, u, i
    defb     15,  16, '@', '[', 192+'4', 192+'5', 192+'6', 192+'*'   ;o, p, \, [ KP4, KP5, KP6, KP*

    defb    255, '3', '4', '5',     '6',     '7',     '8',     '9'   ;UN 3, 4, 5, 6, 7, 8, 9
    defb    '0', '-', '^', '_',      12, 192+'7', 192+'8', 192+'9'   ;0, -, =, ~, BS, KP7, KP8, KP9
    defb    '2', 255, '1',  27,    128+1,   128+2,   128+3,   128+4  ;2, UN, 1, ESC, F1, F2, F3, F4
    defb    255,   8,  9,  11,      10,     255,     255, 128+'/'   ;UN, LEFT, RIGHT, UP, DOWN, UN, UN KP/
    defb    255, 255, 255,   7,     255,     255,     255,    255    ;LSHIFT, RSHIFT, CTRL, GRAPH, UN, UN, UN, UN
    defb    255, 255, 255, 255,       6,     255,     255,    255    ;UN, UN, UN, UN, CAPS, UN, UN, UN
