
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL'
; key represented by FUNC

SECTION rodata_clib
PUBLIC in_keytranstbl
PUBLIC in_keyrowmap

; Mapping between our row numbers and ports + key mask after cpl
.in_keyrowmap
	defb	$e0, @01001111
	defb	$e1, @01101111
	defb	$e3, @01101110		;Don't test shift/ctrl keys
	defb	$e4, @01101111
	defb	$e6, @01111111
	defb	$e8, @01101111
	defb	$ea, @01111111
	defb	$f0, @01101111
	defb	$f2, @01111111

.in_keytranstbl

;
;
; Each table is 72 bytes

;Unshifted
	;E0
	defb	255,  12, 255, 255,  8,  10,    9,  11	; -, BREAK, -, -, LEFT, DOWN, RIGHT, UP
	;E1
	defb	255, 'n', 'f', 255, 'm', '.', ',', 'j'	; -, n, f, -, m, ., ',', j
	;E3
	defb	255, 'h', 'b', 255, 'c', ' ',  27, 255	; -, h, b, SHIFT, c, ' ', ESC, CTRL
	;E4
	defb	255, 't', '4', 255, 'i', 'p', 'o',  13	; -, t, 4, -, i, p, o, RET
	;E6
	defb	255, '6', '5', '7', 'e', 'x', 'w', 'q'	; -, 6, 5, 7, e, x, w, q
	;E8
	defb	255, 'g', 'r', 255, 'k', ';', 'l', ':'	; -, g, r, -, k, ;, l, :
	;EA
	defb	255, 'y', 'v', 'u', 'd', 's', 'a', 'z'	; -, y, v, u, d, s, a, z
	;F0
	defb	255, 131, 129, 255, '8', '0', '9', '-'	; -, F4, F2, -, 8, 0, 9, '-'
	;F2
	defb	255, 132, 130, 133, 128,  '3', '2', '1'	; -, F5, F3, F6, F1, 3, 2, 1

; Shifted
	;E0
	defb	255, 127, 255, 255,  8,  10,    9,  11	; -, BREAK, -, -, LEFT, DOWN, RIGHT, UP
	;E1
	defb	255, 'N', 'F', 255, 'M', '<', '>', 'J'	; -, n, f, -, m, ., ',', j
	;E3
	defb	255, 'H', 'B', 255, 'C', ' ',  27, 255	; -, h, b, SHIFT, c, ' ', ESC, CTRL
	;E4
	defb	255, 'T', '$', 255, 'I', 'P', 'O',  13	; -, t, 4, -, i, p, o, RET
	;E6
	defb	255, '&', '%','\'', 'E', 'X', 'W', 'Q'	; -, 6, 5, 7, e, x, w, q
	;E8
	defb	255, 'G', 'R', 255, 'K', '+', 'L', '*'	; -, g, r, -, k, ;, l, :
	;EA
	defb	255, 'Y', 'V', 'U', 'D', 'S', 'A', 'Z'	; -, y, v, u, d, s, a, z
	;F0
	defb	255, 131, 129, 255, '(', '^', ')', '='	; -, F4, F2, -, 8, 0, 9, '-'
	;F2
	defb	255, 132, 130, 133, 128,  '#','\"', '!'	; -, F5, F3, F6, F1, 3, 2, 1

; Ctrl
	;E0
	defb	255,  12, 255, 255,  8,  10,    9,  11	; -, BREAK, -, -, LEFT, DOWN, RIGHT, UP
	;E1
	defb	255,  14,   6, 255,  13, '.', ',',  10	; -, n, f, -, m, ., ',', j
	;E3
	defb	255,   8,   2, 255,   3, ' ',  27, 255	; -, h, b, SHIFT, c, ' ', ESC, CTRL
	;E4
	defb	255,  19, '4', 255,   9,  16,  15,  13	; -, t, 4, -, i, p, o, RET
	;E6
	defb	255, '6', '5', '7',   5,  24,  23,  17	; -, 6, 5, 7, e, x, w, q
	;E8
	defb	255,   7, 'r', 255,  11, ';',  12, ':'	; -, g, r, -, k, ;, l, :
	;EA
	defb	255,  25,  21,  20,   4,  18,   1,  26	; -, y, v, u, d, s, a, z
	;F0
	defb	255, 131, 129, 255, '8', '0', '9', '-'	; -, F4, F2, -, 8, 0, 9, '-'
	;F2
	defb	255, 132, 130, 133, 128,  '3', '2', '1'	; -, F5, F3, F6, F1, 3, 2, 1

