
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; Each table 64 bytes

;Unshifted
	defb	'y',  11, 's', 255, 'e',   6, 'w', 255	; y UP s LSHIFT e UPPER w CTR
	defb	'd', '3', 'x', '2', 'q', '1', 'a',  10	; d 3 x 2 q 1 a DOWN
	defb	'c', 255, 'f', 255, 'r', 255, 't', '7'	; c - f - r - t 7
	defb	'h', ' ', 'b', '6', 'g', '5', 'v', '4'	; h SP b 6 g 5 v 4
	defb	'n', '8', 'z', '+', 'u', '0', 'j', 255	; n 8 z + u 0 j HOME
	defb	'l', '-', 'k', '.', 'm', '9', 'i', ','	; l - k . m 9 i ,
	defb	'_', '*', 'p', 131, 'o',  12, 255,  13	; = * p F3 o BS - RET
	defb	255,   8, '<', ']','\'',   9, '[',  27	; - LEFT F4 F5 F6 RIGHT F7 ESC
; Shifted
	defb	'Y',  11, 'S', 255, 'E', 255, 'W', 255	; y UP s LSHIFT e UPPER w CTR
	defb	'D', '#', 'X','\"', 'Q', '!', 'A',  10	; d 3 x 2 q 1 a DOWN
	defb	'C', 255, 'F', 255, 'R', 255, 'T', '/'	; c - f - r - t 7
	defb	'H', ' ', 'B', '&', 'G', '%', 'V', '$'	; h SP b 6 g 5 v 4
	defb	'N', '(', 'Z', '?', 'U', '=', 'J', 255	; n 8 z + u 0 j HOME
	defb	'L', '|', 'K', ':', 'M', ')', 'I', ';'	; l - k . m 9 i ,
	defb	'\\','~', 'P', 131, 'O', 127, 255,  13	; = * p F3 o BS - RET
	defb	255,   8, '>', '}', '@',   9, '{',  27	; - LEFT F4 F5 F6 RIGHT F7 ESC

;Control
	defb	 25,  11,  19, 255,   5,   6,  23, 255	; y UP s LSHIFT e UPPER w CTR
	defb	  4, '3',  24, '2',  17, '1',   1,  10	; d 3 x 2 q 1 a DOWN
	defb	  3, 255,   6, 255,  18, 255,  20, '7'	; c - f - r - t 7
	defb	  8, ' ',   2, '6',   7, '5',  22, '4'	; h SP b 6 g 5 v 4
	defb	 14, '8',  26, '+',  21, '0',  10, 255	; n 8 z + u 0 j HOME
	defb	 12, '-',  11, '.',  13, '9',   9, ','	; l - k . m 9 i ,
	defb	'_', '*',  16, 131,  15,  12, 255,  13	; = * p F3 o BS - RET
	defb	255,   8, '<', ']','\'',   9, '[',  27	; - LEFT F4 F5 F6 RIGHT F7 ESC
