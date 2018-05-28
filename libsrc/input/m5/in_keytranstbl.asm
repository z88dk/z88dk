
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; Each table 64  bytes

;Unshifted
	defb	255, 255, 255, 255, 255, 255, ' ',  13	; Ctrl, Func, Lshift, Rshift, -, -, SPC, Return
	defb	'1', '2', '3', '4', '5', '6', '7', '8'	; 1, 2, 3, 4, 5, 6, 7, 8
	defb	'q', 'w', 'e', 'r', 't', 'y', 'u', 'i'	; q, w, e, r, t, y, u, i
	defb	'a', 's', 'd', 'f', 'g', 'h', 'j', 'k'	; a, s, d, f, g, h, j, k
	defb	'z', 'x', 'c', 'v', 'b', 'n', 'm', ','	; z, x, c, v, b, n, m, ','
	defb	'9', '0', '-', '^', '.', '/', '~', '\\'	; 9, 0, '-', ^, '.', /, ~, \
	defb	'o', 'p', '@', '[', 'l', ';', ':', ']'	; o, p, @, [, l, ;. :, ]
	defb	255, 255, 255, 255, 255, 255, 255,  12	; -, -, -, -, -, -, -, RESET

;Shifted
	defb	255, 255, 255, 255, 255, 255, ' ',  13	; Ctrl, Func, Lshift, Rshift, -, -, SPC, Return
	defb	'!','\"', '#', '$', '%', '&','\'', '('	; 1, 2, 3, 4, 5, 6, 7, 8
	defb	'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I'	; q, w, e, r, t, y, u, i
	defb	'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K'	; a, s, d, f, g, h, j, k
	defb	'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<'	; z, x, c, v, b, n, m, ','
	defb	')', '0', '=', '~', '>', '?', '_',  '|'	; 9, 0, '-', ^, '.', /, ~, \
	defb	'O', 'P', '`', '{', 'L', '+', '*', '}'	; o, p, @, [, l, ;. :, ]
	defb	255, 255, 255, 255, 255, 255, 255, 127	; -, -, -, -, -, -, -, RESET

;Control
	defb	255, 255, 255, 255, 255, 255, ' ',  13	; Ctrl, Func, Lshift, Rshift, -, -, SPC, Return
	defb	'!','\"', '#', '$', '%', '&','\'', '('	; 1, 2, 3, 4, 5, 6, 7, 8
	defb	 17, 'W',   5,  18,  20,  24,  21,   9	; q, w, e, r, t, y, u, i
	defb	  1,  19,   4,   6,   7,   8,  10,  11	; a, s, d, f, g, h, j, k
	defb	 26,  23,   3,  22,   2,  14,  13, '<'	; z, x, c, v, b, n, m, ','
	defb	')', '0', '=', '~', '>', '?', '_',  '|'	; 9, 0, '-', ^, '.', /, ~, \
	defb	 15,  16, '`', '{',  12, '+', '*', '}'	; o, p, @, [, l, ;. :, ]
	defb	255, 255, 255, 255, 255, 255, 255,  12	; -, -, -, -, -, -, -, RESET

