
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; 48 bytes per table

;Unshifted
	defb	'r', 'q', 'e', 255, 'w', 't'	; R, Q, E, -, W, T
	defb	'f', 'a', 'd', 255, 's', 'g'	; F, A, D, CTRL, S, G
	defb	'v', 'z', 'c', 255, 'x', 'b'	; V, Z, C, SHIFT, X, B
	defb	'4', '1', '3', 255, '2', '5'	; 4, 1, 3, -, 2, 5
	defb	'm', ' ', ',', 255, '.', 'n'	; M, SPACE, ',', -, '.', N
	defb	'7', '0', '8', '-', '9', '6'	; 7, 0, 8, '-', 9, 6
	defb	'u', 'p', 'i',  13, 'o', 'y'	; u, p, i, return, o, y
	defb	'j', ';', 'k', ':', 'l', 'h'	; j, ;, k, :, l, h

;Shifted
	defb	'R', 'Q', 'E', 255, 'W', 'T'	; R, Q, E, -, W, T
	defb	'F', 'A', 'D', 255, 'S', 'G'	; F, A, D, CTRL, S, G
	defb	'V', 'Z', 'C', 255, 'X', 'B'	; V, Z, C, SHIFT, X, B
	defb	'$', '!', '#', 255, '\"','%'	; 4, 1, 3, -, 2, 5
	defb	'M', ' ', '<', 255, '>', 'N'	; M, SPACE, ',', -, '.', N
	defb	'\'','@', '(', '=', ')', '&'	; 7, 0, 8, '-', 9, 6
	defb	'U', 'P', 'I',  13, 'O', 'Y'	; u, p, i, return, o, y
	defb	'J', '+', 'K', '*', 'L', 'H'	; j, ;, k, :, l, h

;Control
	defb	 18,  17,   5, 255,  23,  20	; R, Q, E, -, W, T
	defb	  6,   1,   4, 255,  19,   7	; F, A, D, CTRL, S, G
	defb	 22,  26,   3, 255,  24,   2	; V, Z, C, SHIFT, X, B
	defb	'$', '!', '#', 255, '\"','%'	; 4, 1, 3, -, 2, 5
	defb	  8,  10,   9, 255,  11,  14	; M, SPACE, ',', -, '.', N
	defb	'\'','@', '(', '=', ')', '&'	; 7, 0, 8, '-', 9, 6
	defb	 21,  16,   9,  13,  15,  25	; u, p, i, return, o, y
	defb	 10,  12,  11, '*',  12,  13	; j, ;, k, :, l, h

;Shift + Control
	defb	'R', 'Q', 'E', 255, 'W', 'T'	; R, Q, E, -, W, T
	defb	'F', 'A', 'D', 255, 'S', 'G'	; F, A, D, CTRL, S, G
	defb	'V', 'Z', 'C', 255, 'X', 'B'	; V, Z, C, SHIFT, X, B
	defb	'$', '!', '#', 255, '\"','%'	; 4, 1, 3, -, 2, 5
	defb	'\\',' ', '<', 255, '>', '^'	; M, SPACE, ',', -, '.', N
	defb	'\'','@', '(', '=', ')', '&'	; 7, 0, 8, '-', 9, 6
	defb	'{', ']', '}',  13, '[', 'Y'	; u, p, i, return, o, y
	defb	'J', 127, '/', '*', '?', 'H'	; j, ;, k, :, l, h



