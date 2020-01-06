
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; 84 bytes per table

;Unshifted
	defb	'-', '7', '3','\\', 128, '1', '5', '9'		; - 7 3 \ INS 1 5 9
	defb	'^', '8', '4',  12, 127, '2', '6', '0'		; ^ 8 4 BS DEL 2 6 0
	defb	'p', 'y', 'w', ']',  11,  27, 'r', 'i'		; p y w ] UP ESC r i
	defb	'[', 'u', 'e',  12,   9, 'q', 't', 'o'		; [ u e RUB RIGHT q t o
	defb	';', 'h', 's', '@', '/',   6, 'f', 'k'		; ; h s @ / CAPS f k
	defb	':', 'j', 'd',  13, '.', 'a', 'g', 'l'		; : j d RET . a g l
	defb	'n', 'v', 'x', 'm', ',', 'z', 'c', 'b'	 	; n v x m , z c b
	defb	255, 255, 255,   8,  10, 255, ' ', 255		; SHIFT META BASIC LEFT DOWN CTRL SPACE FCTN

; Shifted
	defb	'=','\'', '#', '|', 128, '!', '%', ')'		; - 7 3 \ INS 1 5 9
	defb	'~', '(', '$', 127, 127,'\"', '&', ' '		; ^ 8 4 BS DEL 2 6 0
	defb	'P', 'Y', 'W', '}',  11,  27, 'R', 'I'		; p y w ] UP ESC r i
	defb	'{', 'U', 'E',  12,   9, 'Q', 'T', 'O'		; [ u e RUB RIGHT q t o
	defb	'+', 'H', 'S', '_', '?',   6, 'F', 'K'		; ; h s @ / CAPS f k
	defb	'*', 'J', 'D',  13, '>', 'A', 'G', 'L'		; : j d RET . a g l
	defb	'N', 'V', 'X', 'M', '<', 'Z', 'C', 'B'	 	; n v x m , z c b
	defb	255, 255, 255,   8,  10, 255, ' ', 255		; SHIFT META BASIC LEFT DOWN CTRL SPACE FCTN

; With control
	defb	'-', '7', '3','\\', 128, '1', '5', '9'		; - 7 3 \ INS 1 5 9
	defb	'^', '8', '4',  12, 127, '2', '6', '0'		; ^ 8 4 BS DEL 2 6 0
	defb	 16,  25,  23, ']',  11,  27,  18,   9		; p y w ] UP ESC r i
	defb	'[',  21,   5,  12,   9,  17,  20,  15		; [ u e RUB RIGHT q t o
	defb	';',   8,  19, '@', '/',   6,   6,  11		; ; h s @ / CAPS f k
	defb	':',  10,   4,  13, '.',   1,   7,  12		; : j d RET . a g l
	defb	 14,  22,  24,  13, ',',  26,   3,   2	 	; n v x m , z c b
	defb	255, 255, 255,   8,  10, 255, ' ', 255		; SHIFT META BASIC LEFT DOWN CTRL SPACE FCTN


