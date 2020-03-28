
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; Each table 96 bytes

;Unshifted

	;XB -> X0, reverse orderd so we don't pick up keypad codes first of all
	defb	128, 129, 130, 131, 132, 133, 255, 255		; F1, F2, F3, F4, F5, F6, -, -
	defb	 27, 255, 255,  13,   7, 255,  12, 255		; ESC, CLRHOME, GRAPH, ENTER, TAB, SHIFT, INS DEL, -
	defb	255, 255, 255,   6,  11,   8,   9,  10		; -, -, CTRL, LOCK, UP, LEFT, RIGHT, DOWN
	defb	';', '/', '.', ',','\\', ' ', 255, 255		; ; / . , \ SP - -
	defb	':', ']', '[', '@', '^', '-', '9', '8'		; :, ], [, @, %, '-', 9, 8
	defb	'7', '6', '5', '4', '3', '2', '1', '0'		; 7, 6, 5, 4, 3, 2, 1, 0
	defb	255, 255, 255, 255, 255, 'z', 'y', 'x'		; -, -, -, -, -, z, y, x
	defb	'w', 'v', 'u', 't', 's', 'r', 'q', 'p'		; w, v, u, t, s, r, q, p
	defb	'o', 'n', 'm', 'l', 'k', 'j', 'i', 'h'		; o, n, m, l, k, j, i, h
	defb	'g', 'f', 'e', 'd', 'c', 'b', 'a', 255		; g, f, e, d, c, b, a, -
	defb	255, '+', '=', '-', 255, '.', '9', '8'		; Keypad
	defb	'7', '6', '5', '4', '3', '2', '1', '0'		; Keypad

;Shifted
	defb	128, 129, 130, 131, 132, 133, 255, 255		; F1, F2, F3, F4, F5, F6, -, -
	defb	 27, 255, 255,  13,   7, 255, 127, 255		; ESC, CLRHOME, GRAPH, ENTER, TAB, SHIFT, INS DEL, -
	defb	255, 255, 255,   6,  11,   8,   9,  10		; -, -, CTRL, LOCK, UP, LEFT, RIGHT, DOWN
	defb	'+', '?', '>', '<', '|', ' ', 255, 255		; ; / . , \ SP - -
	defb	'*', '}', '{', '`', '~', '=', ')', '('		; :, ], [, @, %, '-', 9, 0
	defb	'\'','&', '%', '$', '#','\"', '!', '_'		; 7, 6, 5, 4, 3, 2, 1, 0
	defb	255, 255, 255, 255, 255, 'Z', 'Y', 'X'		; -, -, -, -, -, z, y, x
	defb	'W', 'V', 'U', 'T', 'S', 'R', 'Q', 'P'		; w, v, u, t, s, r, q, p
	defb	'O', 'N', 'M', 'L', 'K', 'J', 'I', 'H'		; o, n, m, l, k, j, i, h
	defb	'G', 'F', 'E', 'D', 'C', 'B', 'A', 255		; g, f, e, d, c, b, a, -
	defb	255, '+', '=', '-', 255, '.', '9', '8'		; Keypad
	defb	'7', '6', '5', '4', '3', '2', '1', '0'		; Keypad

; Control
	defb	128, 129, 130, 131, 132, 133, 255, 255		; F1, F2, F3, F4, F5, F6, -, -
	defb	 27, 255, 255,  13,   7, 255,  12, 255		; ESC, CLRHOME, GRAPH, ENTER, TAB, SHIFT, INS DEL, -
	defb	255, 255, 255,   6,  11,   8,   9,  10		; -, -, CTRL, LOCK, UP, LEFT, RIGHT, DOWN
	defb	';', '/', '.', ',','\\', ' ', 255, 255		; ; / . , \ SP - -
	defb	':', ']', '[',   0, '^', '-', '9', '8'		; :, ], [, @, %, '-', 9, 0
	defb	'7', '6', '5', '4', '3', '2', '1', '0'		; 7, 6, 5, 4, 3, 2, 1, 0
	defb	255, 255, 255, 255, 255,  26,  25,  24		; -, -, -, -, -, z, y, x
	defb	 23,  22,  21,  20,  19,  18,  17,  16		; w, v, u, t, s, r, q, p
	defb	 15,  14,  13,  12,  11,  10,   9,   8		; o, n, m, l, k, j, i, h
	defb	  7,   6,   5,   4,   3,   2,   1, 255		; g, f, e, d, c, b, a, -
	defb	255, '+', '=', '-', 255, '.', '9', '8'		; Keypad
	defb	'7', '6', '5', '4', '3', '2', '1', '0'		; Keypad
