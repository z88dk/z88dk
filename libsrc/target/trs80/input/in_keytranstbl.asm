
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl
	defb	'g', 'f', 'e', 'd', 'c', 'b', 'a', '@'	; g, f, e, d, c, b, a, @
	defb	'o', 'n', 'm', 'l', 'k', 'j', 'i', 'h'	; o, n, m, l, k, j, i, h
	defb	'w', 'v', 'u', 't', 's', 'r', 'q', 'p'	; w, v, u, t, s, r, q, p
	defb	255, 255, 255, 255, 255, 'z', 'y', 'x'	; -, -, -, -, -, z, y,x
	defb	'7', '6', '5', '4', '3', '2', '1', '0'	; 7, 6 ,5, 4, 3, 2, 1, 0
	defb	'/', '.', '-', ',', ';', ':', '9', '8'	; /, '.', '-', ',', ;, :, 9, 8
	defb	' ',   9,   8,  10,  11, 255,  12,  13	; ' ', RIGHT, LEFT, DOWN, UP, Break, Clear, RET
	defb	255, 255, 255, 255,   6, 255, 255, 255	; -, F3, F2, F1, CAPS, CTL, R-SHIFT, LSHIFT 

; Shifted
	defb	'G', 'F', 'E', 'D', 'C', 'B', 'A', '`'	; g, f, e, d, c, b, a, @
	defb	'O', 'N', 'M', 'L', 'K', 'J', 'I', 'H'	; o, n, m, l, k, j, i, h
	defb	'W', 'V', 'U', 'T', 'S', 'R', 'Q', 'P'	; w, v, u, t, s, r, q, p
	defb	255, 255, 255, 255, 255, 'Z', 'Y', 'X'	; -, -, -, -, -, z, y,x
	defb	'\'','&', '%', '$', '#', '"', '!', '0'	; 7, 6 ,5, 4, 3, 2, 1, 0
	defb	'?', '>', '=', '<', '+', '*', ')', '('	; /, '.', '-', ',', ;, :, 9, 8
	defb	' ',   9,   8,  10,  11, 255, 127,  13	; ' ', RIGHT, LEFT, DOWN, UP, Break, Clear, RET
	defb	255, 255, 255, 255,   6, 255, 255, 255	; -, F3, F2, F1, CAPS, CTL, R-SHIFT, LSHIFT 

; Control
	defb	  7,   6,   5,   4,   3,   2,   1, '@'	; g, f, e, d, c, b, a, @
	defb	 15,  14,  13,  12,  11,  10,   9,   8	; o, n, m, l, k, j, i, h
	defb	 23,  22,  21,  20,  19,  18,  17,  16	; w, v, u, t, s, r, q, p
	defb	255, 255, 255, 255, 255,  26,  25,  24	; -, -, -, -, -, z, y,x
	defb	'7', '6', '5', '4', '3', '2', '1', '0'	; 7, 6 ,5, 4, 3, 2, 1, 0
	defb	'/', '.', '-', ',', ';', ':', '9', '8'	; /, '.', '-', ',', ;, :, 9, 8
	defb	' ',   9,   8,  10,  11, 255,  12,  13	; ' ', RIGHT, LEFT, DOWN, UP, Break, Clear, RET
	defb	255, 255, 255, 255,   6, 255, 255, 255	; -, F3, F2, F1, CAPS, CTL, R-SHIFT, LSHIFT 
