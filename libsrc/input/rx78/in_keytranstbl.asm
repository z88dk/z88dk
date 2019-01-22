
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; Each table 72 bytes

;Unshifted
	defb	'7', '6', '5', '4', '3', '2', '1', '0'	; 7, 6, 5, 4, 3, 2, 1, 0
	defb	'/', '.', '-', ',', ';', ':', '9', '8' 	; /, ., _, ',', ;, :, 9, 8
	defb	'g', 'f', 'e', 'd', 'c', 'b', 'a', '@'	; g, f, e, d, c, b, a, @
	defb	'o', 'n', 'm', 'l', 'k', 'j', 'i', 'h'	; o, n, m, l, k, j, i, h
	defb	'w', 'v', 'u', 't', 's', 'r', 'q', 'p'	; w, v, u, t, s, r, q, p
	defb	  9,  11, ']','\\', '[', 'z', 'y', 'x'	; RIGHTARR, UPARR, ], \, [, z, y, x
	defb	 12, 255, 255,   8,   9,  11,  10, ' '	; DEL, -, CLR, LEFt, RIGHT, UP, DOWN, SPC
	defb	  6, 255,  13, 255,  27, 255, 255, 255	; CAPS, -, RET, -, STOP, -, -, -
	defb	255, 255, 255, 255, 255, 255, 255, 255	; -, -, -, -, -, SHIFT, -, CTRL

; Shift
	defb 	'\'','&', '%', '$', '#', '"', '!', '_'	; 7, 6, 5, 4, 3, 2, 1, 0
	defb	'?', '>', '=', '<', '+', '*', ')', '(' 	; /, ., _, ',', ;, :, 9, 8
	defb	'G', 'F', 'E', 'D', 'C', 'B', 'A', '`'	; g, f, e, d, c, b, a, @
	defb	'O', 'N', 'M', 'L', 'K', 'J', 'I', 'H'	; o, n, m, l, k, j, i, h
	defb	'W', 'V', 'U', 'T', 'S', 'R', 'Q', 'P'	; w, v, u, t, s, r, q, p
	defb	  9,  11, '}', '|', '{', 'Z', 'Y', 'X'	; RIGHTARR, UPARR, ], \, [, z, y, x
	defb	127, 255, 255,   8,  10,  11,   9, ' '	; DEL, -, CLR, LEFt, RIGHT, UP, DOWN, SPC
	defb	  6, 255,  13, 255,  27, 255, 255, 255	; CAPS, -, RET, -, STOP, -, -, -
	defb	255, 255, 255, 255, 255, 255, 255, 255	; -, -, -, -, -, SHIFT, -, CTRL

; Ctrl
	defb	'7', '6', '5', '4', '3', '2', '1', '0'	; 7, 6, 5, 4, 3, 2, 1, 0
	defb	'/', '.', '-', ',', ';', ':', '9', '8' 	; /, ., _, ',', ;, :, 9, 8
	defb	  7,   6,   5,   4,   3,   2,   1,  0	; g, f, e, d, c, b, a, @
	defb	 15,  14,  13,  12,  11,  10,   9,  8	; o, n, m, l, k, j, i, h
	defb	 23,  22,  21,  20,  19,  18,  17,  16	; w, v, u, t, s, r, q, p
	defb	  9,  11, ']','\\', '[',  26,  25,  24	; RIGHTARR, UPARR, ], \, [, z, y, x
	defb	 12, 255, 255,   8,  10,  11,   9, ' '	; DEL, -, CLR, LEFt, RIGHT, UP, DOWN, SPC
	defb	  6, 255,  13, 255,  27, 255, 255, 255	; CAPS, -, RET, -, STOP, -, -, -
	defb	255, 255, 255, 255, 255, 255, 255, 255	; -, -, -, -, -, SHIFT, -, CTRL
