
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; Each table 80 bytes

;Unshifted
	defb	255, 255, 255, 255, 255, 255, 255, 255	; -, GRAPH, -, BREAK, -, CTRL, SHIFT, -
	defb	'1', 'q', 'a', 'c',  13, ' ', 255, 255	; 1, q, a, c, RET, SP, HOME, ^
	defb	'2', 'w', 's', 'v', ']', 'z', 255,   6	; 2, w, s, v, ], z, -, CAPS
	defb	'3', 'e', 'd', 'b', '[',  27, 255,  12	; 3, e, d, b, [, ESC, -, DEL
	defb	'4', 'r', 'f', 'n','\\',   9, 255, 255	; 4, r, f, n, \, RIGHT, -, -
	defb	'5', 't', 'g', 'm', 255,   8, 128, 255	; 5, t, g, n, -, LEFT, F1, -
	defb	'6', 'y', 'h', ',', 'x', '@', 129, 255	; 6, y, h, ',', x, @, F2, -
	defb	'7', 'u', 'j', '.', 'p',  11, 130, 255	; 7, u, j, '.', p, UP, F3, -
	defb	'8', 'i', 'k', '/', ':',  10, 131, 255	; 8, i, k, /, :, DOWN, F4, -
	defb	'9', 'o', 'l', ';', '0', '-', 132, 255	; 9, o, l, ;, 0, '-', F5, IPL

;Shifted
	defb	255, 255, 255, 255, 255, 255, 255, 255	; -, GRAPH, -, BREAK, -, CTRL, SHIFT, -
	defb	'!', 'Q', 'A', 'C',  13, ' ', 255, 255	; 1, q, a, c, RET, SP, HOME, ^
	defb	'\"','W', 'S', 'V', '}', 'Z', 255,   6	; 2, w, s, v, ], z, -, CAPS
	defb	'#', 'E', 'D', 'B', '{',  27, 255, 127	; 3, e, d, b, [, ESC, -, DEL
	defb	'$', 'R', 'F', 'N', '|',   9, 255, 255	; 4, r, f, n, \, RIGHT, -, -
	defb	'%', 'T', 'G', 'M', 255,   8, 128, 255	; 5, t, g, n, -, LEFT, F1, -
	defb	'&', 'Y', 'H', '<', 'X', '`', 129, 255	; 6, y, h, ',', x, @, F2, -
	defb	'\'','U', 'J', '>', 'P',  11, 130, 255	; 7, u, j, '.', p, UP, F3, -
	defb	'(', 'I', 'K', '?', '*',  10, 131, 255	; 8, i, k, /, :, DOWN, F4, -
	defb	')', 'O', 'L', '+', '_', '=', 132, 255	; 9, o, l, ;, 0, '-', F5, IPL

;Control
	defb	255, 255, 255, 255, 255, 255, 255, 255	; -, GRAPH, -, BREAK, -, CTRL, SHIFT, -
	defb	'1',  17,   1,   3,  13, ' ', 255, 255	; 1, q, a, c, RET, SP, HOME, ^
	defb	'2',  23,  19,  22, ']',  26, 255,   6	; 2, w, s, v, ], z, -, CAPS
	defb	'3',   5,   4,   2, '[',  27, 255,  12	; 3, e, d, b, [, ESC, -, DEL
	defb	'4',  18,   6,  14,'\\',   9, 255, 255	; 4, r, f, n, \, RIGHT, -, -
	defb	'5',  20,   7,  13, 255,   8, 128, 255	; 5, t, g, n, -, LEFT, F1, -
	defb	'6',  25,   8, ',',  24, '@', 129, 255	; 6, y, h, ',', x, @, F2, -
	defb	'7',  21,  10, '.',  16,  11, 130, 255	; 7, u, j, '.', p, UP, F3, -
	defb	'8',   9,  11, '/', ':',  10, 131, 255	; 8, i, k, /, :, DOWN, F4, -
	defb	'9',  15,  12, ';', '0', '-', 132, 255	; 9, o, l, ;, 0, '-', F5, IPL
