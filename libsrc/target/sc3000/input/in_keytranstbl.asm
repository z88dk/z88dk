
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key
; http://www43.tok2.com/home/cmpslv/Sc3000/EnrSC.htm

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; First 4 from port 0xdd, then 8 from 0xdc
; 84 bytes per table

;Unshifted
	defb	255, 255, 255, '8'				; -, -, -, 8
	defb	'i', 'k', ',', 255, 'z', 'a', 'q', '1'		; I, K, ., ??, Z, A, Q, 1
	defb	255, 255, 255, '9'				; -, -, -, 9
	defb	'o', 'l', '.', ' ', 'x', 's', 'w', '2'		; O, L, ., SPACE, X, S, W, 2
	defb	255, 255, 255, '0'				; -, -, -, 0
	defb	'p', ';', '/', 255, 'c', 'd', 'e', '3'		; p, ;, /, HOME/CLR, C, D, E, 3
	defb	255, 255, 255, '-'				; -, -, -, '-'
	defb	'@', ':', 255,  12, 'v', 'f', 'r', '4'		; @, :, ??, INS/DEL, V, F, R, 4
	defb	255, 255, 255, '^'				; -, -, -, ^
	defb	'[', ']',  10, 255, 'b', 'g', 't', '5'		; [, ], CURDOWN, -, b, g, t, 5
	defb	255, 255, 255, '|'				; FUNC, -, -, |
	defb	255,  13,   8, 255, 'n', 'h', 'y', '6'		; -, CR, CURLEFT, -, N, H, Y, 6
	defb	255, 255, 255, 255				; SHIFT, CTRL, GRAPH, BREAK
	defb	255,  11,   9, 255, 'm', 'j', 'u', '7'		; -, CURUP, CURRIGHT, -, M, J, U, 7
	; J2-2, J2-1, J2-Right, J2-Left
	; J2-Down, J2-UP, J1-2, J1-1, J1-Right, J1-Left, J1-Down, J1-Up

; Shifted
	defb	255, 255, 255, '('				; -, -, -, 8
	defb	'I', 'K', '<', 255, 'Z', 'A', 'Q', '!'		; I, K, ., ??, Z, A, Q, 1
	defb	255, 255, 255, ')'				; -, -, -, 9
	defb	'O', 'L', '>', ' ', 'X', 'S', 'W', '\"'		; O, L, ., SPACE, X, S, W, 2
	defb	255, 255, 255, '0'				; -, -, -, 0
	defb	'P', '+', '?', 255, 'C', 'D', 'E', '#'		; p, ;, /, HOME/CLR, C, D, E, 3
	defb	255, 255, 255, '='				; -, -, -, '-'
	defb	'`', '*', 255, 127, 'V', 'F', 'R', '$'		; @, :, ??, INS/DEL, V, F, R, 4
	defb	255, 255, 255, '~'				; -, -, -, ^
	defb	'{', '}',  10, 255, 'B', 'G', 'T', '%'		; [, ], CURDOWN, -, b, g, t, 5
	defb	255, 255, 255, '\\'				; FUNC, -, -, |
	defb	255,  13,   8, 255, 'N', 'H', 'Y', '&'		; -, CR, CURLEFT, -, N, H, Y, 6
	defb	255, 255, 255, 255				; SHIFT, CTRL, GRAPH, BREAK
	defb	255,  11,   9, 255, 'M', 'J', 'U', '\''		; -, CURUP, CURRIGHT, -, M, J, U, 7

; With control
	defb	255, 255, 255, '('				; -, -, -, 8
	defb	  9,  11, '<', 255,  26,   1,  17,  27		; I, K, ., ??, Z, A, Q, 1
	defb	255, 255, 255, ')'				; -, -, -, 9
	defb	 15,  12, '>', ' ',  24,  19,  23,  28 		; O, L, ., SPACE, X, S, W, 2
	defb	255, 255, 255, '0'				; -, -, -, 0
	defb	 16, '+', '?', 255,   3,   4,   5,  29		; p, ;, /, HOME/CLR, C, D, E, 3
	defb	255, 255, 255, '='				; -, -, -, '-'
	defb	'`', '*', 255, 127,  22,   6,  18,  30		; @, :, ??, INS/DEL, V, F, R, 4
	defb	255, 255, 255, '~'				; -, -, -, ^
	defb	'[', ']',  10, 255,   2,   7,  20,  31		; [, ], CURDOWN, -, b, g, t, 5
	defb	255, 255, 255, '|'				; FUNC, -, -, |
	defb	255,  13,   8, 255,  14,   8,  25, '&'		; -, CR, CURLEFT, -, N, H, Y, 6
	defb	255, 255, 255, 255				; SHIFT, CTRL, GRAPH, BREAK
	defb	255,  11,   9, 255,  13,  10,  21, '\''		; -, CURUP, CURRIGHT, -, M, J, U, 7


