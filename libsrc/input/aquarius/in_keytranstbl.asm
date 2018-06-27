
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl
	; 48 bytes per table
	defb	'.', ';',  13, ':',  12, '='	; ., ;, RET, :, BS, =
	defb	',', 'l', 'p', '0', '/', '-'	; ',', L, P, 0, /, -
	defb	'j', 'n', 'm', 'k', 'o', '9'	; j, n, m, j, o, 9
	defb	'b', 'h', 'u', '7', 'i', '8'	; b, h, u, 7, i, 8
	defb	'f', 'c', 'v', 'g', 'y', '6'	; f, c, v, g, y, 6
	defb	'x', 'd', 'r', '4', 't', '5'	; x, d, r, 4, t, 5
	defb	'a', ' ', 'z', 's', 'e', '3'	; a, SPC, z, s, e, 3
	defb	255, 255, 'q', '1', 'w', '2'	; CTL, SHIFT, q, 1, w, 2


; Shifted
	defb	'>', '@',  13, '*', 127, '+'	; ., ;, RET, :, BS, =
	defb	'<', 'L', 'P', '?', '^', '_'	; ',', L, P, 0, /, -
	defb	'J', 'N', 'M', 'K', 'O', ')'	; j, n, m, j, o, 9
	defb	'B', 'H', 'U', '\'','i', '('	; b, h, u, 7, i, 8
	defb	'F', 'C', 'V', 'G', 'Y', '&'	; f, c, v, g, y, 6
	defb	'X', 'D', 'R', '$', 'T', '%'	; x, d, r, 4, t, 5
	defb	'A', ' ', 'Z', 'S', 'E', '#'	; a, SPC, z, s, e, 3
	defb	255, 255, 'Q', '!', 'W','\"'	; CTL, SHIFT, q, 1, w, 2

; Control
	defb	'.', ';',  13, ':',  12, '='	; ., ;, RET, :, BS, =
	defb	',',  12,  16, '0', '/', '-'	; ',', L, P, 0, /, -
	defb	 10,  14,  13,  11,  15, '9'	; j, n, m, j, o, 9
	defb	  2,   8,  21, '7',   9, '8'	; b, h, u, 7, i, 8
	defb	  6,   3,  22,   7,  25, '6'	; f, c, v, g, y, 6
	defb	 24,   4,  18, '4',  20, '5'	; x, d, r, 4, t, 5
	defb	  1, ' ',  26,  19,   5, '3'	; a, SPC, z, s, e, 3
	defb	255, 255,  17, '1',  23, '2'	; CTL, SHIFT, q, 1, w, 2
