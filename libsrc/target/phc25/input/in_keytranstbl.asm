
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; Each table 72 bytes
; https://www.oldcomputr.com/wp-content/uploads/2017/01/sanyo_phc_25-8566.jpg

;Unshifted
    defb    '1', 'w', 's', 'x',  11,  12, ':', 255    ;1, w, s, x, UP, BS, ", UN
    defb     27, 'q', 'a', 'z',  10,  13, ':', '/'    ;ESC, q, a, z, DOWN, RET, :, /
    defb    '3', 'r', 'f', 'v',   8, '-', ']', 255    ;3, r, f, v, LEFT, =, }, UN
    defb    '2', 'e', 'd', 'c',   9, '^','\\', ' '    ;2, e, d, c, RIGHT, ~, \, SP
    defb    '5', 'y', 'h', 'n', 130, '0', 'p', 255    ;5, y, h, n, F3, 0, p, UN
    defb    '4', 't', 'g', 'b', 131, '-', '[', 255    ;4, t, g, b, F4, ~, {, UN
    defb    '6', 'u', 'j', 'm', 129, '9', 'o', 255    ;6, u, j, m, F2, 9, o, UN
    defb    '7', 'i', 'k', ',', 128, '8', 'l', '.'    ;7, i, k, ,, F1, 8, l, STOP
    defb    255,   7, 255, 255, 255,   6, 255, 132   ;UN, GRAPH, SHIFT, CTRL, UN, CAPS, UN, UNLABELED

;Shifted
    defb    '!', 'W', 'S', 'X',  11, 127, '+', 255    ;1, w, s, x, UP, BS, ", UN
    defb     27, 'Q', 'A', 'Z',  10,  13, '*', '?'    ;ESC, q, a, z, DOWN, RET, :, /
    defb    '#', 'R', 'F', 'V',   8, '=', '}', 255    ;3, r, f, v, LEFT, =, }, UN
    defb   '\"', 'E', 'D', 'C',   9, '~', '|', ' '    ;2, e, d, c, RIGHT, ~, \, SP
    defb    '%', 'Y', 'H', 'N', 130, '_', 'P', 255    ;5, y, h, n, F3, 0, p, UN
    defb    '$', 'T', 'G', 'B', 131, '=', '{', 255    ;4, t, g, b, F4, ~, {, UN
    defb    '&', 'U', 'J', 'M', 129, ')', 'O', 255    ;6, u, j, m, F2, 9, o, UN
    defb   '\'', 'I', 'K', '<', 128, '(', 'L', '>'    ;7, i, k, ,, F1, 8, l, '.'
    defb    255,   7, 255, 255, 255,   6, 255, 132   ;UN, GRAPH, SHIFT, CTRL, UN, CAPS, UN, UNLABELED

;Control
    defb    '1',  23,  19,  24,  11,   8, ':', 255    ;1, w, s, x, UP, BS, ", UN
    defb     27,  17,   1,  26,  10,  13, ':', '/'    ;ESC, q, a, z, DOWN, RET, :, /
    defb    '3',  18,   6,  22,   8, '-', ']', 255    ;3, r, f, v, LEFT, =, }, UN
    defb    '2',   5,   4,   3,   9, '^','\\', ' '    ;2, e, d, c, RIGHT, ~, \, SP
    defb    '5',  25,   8,  14, 130, '0',  16, 255    ;5, y, h, n, F3, 0, p, UN
    defb    '4',  20,   7,   2, 131, '-', '[', 255    ;4, t, g, b, F4, ~, {, UN
    defb    '6',  21,  10,  13, 129, '9',  15, 255    ;6, u, j, m, F2, 9, o, UN
    defb    '7',   9,  11, ',', 128, '8',  12, '.'    ;7, i, k, ,, F1, 8, l, STOP
    defb    255,   7, 255, 255, 255,   6, 255, 132   ;UN, GRAPH, SHIFT, CTRL, UN, CAPS, UN, UNLABELED
