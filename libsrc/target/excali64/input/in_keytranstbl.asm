
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

;Unshifted
	defb	'r', 'w', 255, 'e','\t',   6, 'a', 'q'	;r w SHIFT e TAB CAPS a q
	defb	130, 129, 131, ' ', 255, 255, 128, 255	;f3 f2 f4 SPACE CTRL UN F1 UN
	defb	'.', 'm', '/', ',', 'b', 255, 'n', 255	;. m / m b UN n UN
	defb   '\'', 'l',  13, ';', 'j', 'g', 'k', 'h'	; ' l RET ; j g k h
	defb	'4', '2', '5', '3', 127,  27, '1', 255	; 4 2 5 3 DEL ESC 1 INSERT
	defb	'[', 'o', ']', 'p', 'u', 't', 'i', 'y'	; [ o ] p u t i y
	defb	'f', 'x', 'v', 'c', 'd', 's', 'z', 255	; f x v c d s z UN
	defb	'=', '0',  12, '-', '8', '6', '9', '7'	; = 0 BKSP - 8 6 9 7

;Shifted
	defb	'R', 'W', 255, 'E','\t',   6, 'A', 'Q'	;r w SHIFT e TAB CAPS a q
	defb	130, 129, 131, ' ', 255, 255, 128, 255	;f3 f2 f4 SPACE CTRL UN F1 UN
	defb	'>', 'M', '?', '<', 'B', 255, 'N', 255	;. m / m b UN n UN
	defb   '\"', 'L',  13, ':', 'J', 'G', 'K', 'H'	; ' l RET ; j g k h
	defb	'$', '@', '%', '#', 127,  27, '!', 255	; 4 2 5 3 DEL ESC 1 INSERT
	defb	'{', 'O', '}', 'P', 'U', 'T', 'I', 'Y'	; [ o ] p u t i y
	defb	'F', 'X', 'V', 'C', 'D', 'S', 'Z', 255	; f x v c d s z UN
	defb	'+', '0', 127, '_', '*', '^', '(', '&'	; = 0 BKSP - 8 6 9 7

;Control
	defb	 18,  23, 255,  5, '\t',  6,   1,  17	;r w SHIFT e TAB CAPS a q
	defb	130, 129, 131, ' ', 255, 255, 128, 255	;f3 f2 f4 SPACE CTRL UN F1 UN
	defb	'.',  13, '/', ',',   2, 255,  14, 255	;. m / m b UN n UN
	defb   '\'',  12,  13, ';',  10,   7,  11,   8	; ' l RET ; j g k h
	defb	'4', '2', '5', '3', 127,  27, '1', 255	; 4 2 5 3 DEL ESC 1 INSERT
	defb	'[',  15, ']',  16,  21,  20,   9,  25	; [ o ] p u t i y
	defb	  6,  24,  22,   3,   4,  19,  26, 255	; f x v c d s z UN
	defb	'=', '0',  12, '-', '8', '6', '9', '7'	; = 0 BKSP - 8 6 9 7
