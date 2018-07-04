
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; Each table 80 bytes

;Unshifted
	defb	255, 255, 255, 255,  27	; Shift, ShiftLock, Control, Graphic, Stop
	defb	255, 255, ' ', 255, 255	; Sel, Skip, ' ', Repeat, Clear
	defb	'1', 'q', 'a', 'z', 'x'	; 1, q, a, z, x
	defb	'2', 'w', 's', 'd', 'c'	; 2, w, s, d, c
	defb	'3', '4', 'e', 'r', 'f'	; 3, 4, e, r, f
	defb	'5', 't', 'g', 'v', 'b'	; 5, t, g, v, b
	defb	'6', 'y', 'h', 'n', 'm'	; 6, y, h, n, m
	defb	'7', 'u', 'j', 'i', 'k'	; 7, u, j, i, k
	defb	'8', '9', 'o', 'l', ','	; 8, 9, o, l, ','
	defb	'0', 'p', ';', '.', '/'	; 0, p, ;, '.', '/'
	defb	':', '[', ']', '@','\\'	; :, [, ], @, \
	defb	'-', '^',  10,  13, '_'	; -, ^, LF, RET, _ 
	; keypad below
	defb	255, '-', '/', '*', '+'
	defb	'7', '8', '4', '1', '0'
	defb	'9', '6', '5', '2', '.'
	defb	'3', '=', 255, 255, 255

;Shifted
	defb	255, 255, 255, 255,  27	; Shift, ShiftLock, Control, Graphic, Stop
	defb	255, 255, ' ', 255, 255	; Sel, Skip, ' ', Repeat, Clear
	defb	'!', 'Q', 'A', 'Z', 'X'	; 1, q, a, z, x
	defb	'\"','W', 'S', 'D', 'C'	; 2, w, s, d, c
	defb	'#', '$', 'E', 'R', 'F'	; 3, 4, e, r, f
	defb	'%', 'T', 'G', 'V', 'B'	; 5, t, g, v, b
	defb	'&', 'Y', 'H', 'N', 'M'	; 6, y, h, n, m
	defb	'\'','U', 'J', 'I', 'K'	; 7, u, j, i, k
	defb	'(', ')', 'O', 'L', '<'	; 8, 9, o, l, ','
	defb	'0', 'P', '+', '>', '?'	; 0, p, ;, '.', '/'
	defb	'*', '{', '}', '`', '|'	; :, [, ], @, \
	defb	'=', '~',  10,  13, 12	; -, ^, LF, RET, _RUB
	; keypad below
	defb	255, '-', '/', '*', '+'
	defb	'7', '8', '4', '1', '0'
	defb	'9', '6', '5', '2', '.'
	defb	'3', '=', 255, 255, 255

;Control
	defb	255, 255, 255, 255,  27	; Shift, ShiftLock, Control, Graphic, Stop
	defb	255, 255, ' ', 255, 255	; Sel, Skip, ' ', Repeat, Clear
	defb	'1',  17,   1,  26,  24	; 1, q, a, z, x
	defb	'2',  23,  19,   4,   3	; 2, w, s, d, c
	defb	'3', '4',   5,  18,   6	; 3, 4, e, r, f
	defb	'5',  20,   7,  22,   2	; 5, t, g, v, b
	defb	'6',  25,   8,  14,  13	; 6, y, h, n, m
	defb	'7',  21,  10,   9,  11	; 7, u, j, i, k
	defb	'8', '9',  15,  12, ','	; 8, 9, o, l, ','
	defb	'0',  16, ';', '.', '/'	; 0, p, ;, '.', '/'
	defb	':', '[', ']', '@','\\'	; :, [, ], @, \
	defb	'-', '^',  10,  13, 127	; -, ^, LF, RET, _ 
	; keypad below
	defb	255, '-', '/', '*', '+'
	defb	'7',  11,   8, '1', '0'
	defb	'9',   9, '5',  10, '.'
	defb	'3', '=', 255, 255, 255



