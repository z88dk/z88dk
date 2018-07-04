
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl
	defb	255, 255,  10,   9,   8, 255, 255, 255	; INSERT, CTRL, DOWN, RIGHT, LEFT, SHIFT, -, HOME
	defb	'a',  11,  13, 255,   6,  32, 'q', 255	; a, UP, RET, -, CAPS, ' ', 'q', RUN/STOP
	defb	'z', ':', '1', 'b', 'v', 'c', 'x', 'w'	; z, :, 1, b, v, c, x, w
	defb	';', '2', '6', '5', '4', '3', 'e', 's'	; ;, 2, 6, 5, 4, 3, e, s
	defb	'p', 'o', 'i', 'u', 'g', 'f', '|', '_'	; p, o, i, u, g, f, |, -
	defb	'9', '8', '7', ',', 255, '[', '0', 255  ; 9, 8, 7, ',', slash, ], 0
	defb	'd', 255, '<', 'y', 't', 'r', '+', '?'	; d, prt, <, y, t, r, +, '?'
	defb	'm', 'l', 'k', 'h', 'j', 'n',  12, '='	; m, l, k, h, j, n, bs, =

   ; the following are SHIFTed
	defb	255, 255,  10,   9,   8, 255, 255, 255	; INSERT, CTRL, DOWN, RIGHT, LEFT, SHIFT, -, HOME
	defb	'A',  11,  13, 255,   6,  32, 'Q', 255	; a, UP, RET, -, CAPS, ' ', 'q', RUN/STOP
	defb	'Z', '*', '#', 'B', 'V', 'C', 'X', 'W'	; z, :, 1, b, v, c, x, w
	defb	'@', '!', '%', '$',  96, '\"','E', 'S'	; ;, 2, 6, 5, 4, 3, e, s
	defb	'P', 'O', 'I', 'U', 'G', 'F', '/', '*'	; p, o, i, u, g, f, |, _
	defb	'(', '/', '-', ',', 255, ']', ')', 255  ; 9, 8, 7, ',', slash, ], 0
	defb	'D', 255, '>', 'Y', 'T', 'R', '.', '-'	; d, prt, <, y, t, r, +, '?'
	defb	'M', 'L', 'K', 'H', 'J', 'N', 127, '^'	; m, l, k, h, j, n, bs, =

   ; the following are ("CTRL" key)
	defb	255, 255,  10,   9,   8, 255, 255, 255	; INSERT, CTRL, DOWN, RIGHT, LEFT, SHIFT, -, HOME
	defb	  1,  11,  13, 255,   6,  32,  17, 255	; a, UP, RET, -, CAPS, ' ', 'q', RUN/STOP
	defb	 26, ':', '1',   2,  22,   3,  24,  23	; z, :, 1, b, v, c, x, w
	defb	';', '2', '6', '5', '4', '3',   5,  19	; ;, 2, 6, 5, 4, 3, e, s
	defb	 16,  15,   9,  21,   7,   6, '|', '_'	; p, o, i, u, g, f, |, -
	defb	'9', '8', '7', ',', 255, '[', '0', 255  ; 9, 8, 7, ',', slash, ], 0
	defb	  4, 255, '<',  25,  20,  18, '+', '?'	; d, prt, <, y, t, r, +, '?'
	defb	 13,  12,  11,   8,  10,  14,  12, '='	; m, l, k, h, j, n, bs, =

