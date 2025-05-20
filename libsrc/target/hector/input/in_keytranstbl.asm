
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL'

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

;
;

;Unshifted - bit 0....bit 7
	defb	 '*', ' ',  13,   9,   8,   6, 255, 255	;* SP RET TAB BKSPC CAPS CTRL SHIFT
	defb	 '2', '1', '0', '/', '.', '-', '-', '+'	; 2 1 0 / . - - +
	defb	 255, '9', '8', '7', '6', '5', '4', '3'	;UN 9 8 7 6 5 4 3 
	defb	 'b', 'a', 255, '?', 255, '=', 255, ';' ;b a UN ? UN = UN ;
	defb	 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c'	;j i h g f e d c
	defb	 'r', 'q', 'p', 'o', 'n', 'm', 'l', 'k'	;r a p o n m l k
	defb	 'z', 'y', 'x', 'w', 'v', 'u', 't', 's'	;z y x w v u t s

;Shifted
	defb	 '*', ' ',  13,   9, 127,   6, 255, 255	;* SP RET TAB BKSPC CAPS CTRL SHIFT
	defb	'\"', '>', '<', '@', '&', '%', '_', '^'	; 2 1 0 / . - - +
	defb	 255, ')', '(', ':', '!', '%', '$','\''	;UN 9 8 7 6 5 4 3 
	defb	 'B', 'A', 255, '?', 255, '=', 255, ';' ;b a UN ? UN = UN ;
	defb	 'J', 'I', 'H', 'G', 'F', 'E', 'D', 'C'	;j i h g f e d c
	defb	 'R', 'Q', 'P', 'O', 'N', 'M', 'L', 'K'	;r a p o n m l k
	defb	 'Z', 'Y', 'X', 'W', 'V', 'U', 'T', 'S'	;z y x w v u t s

; Control
	defb	 '*', ' ',  13,   9,   8,   6, 255, 255	;* SP RET TAB BKSPC CAPS CTRL SHIFT
	defb	 '2', '1', '0', '/', '.', '-', '-', '+'	; 2 1 0 / . - - +
	defb	 255, '9', '8', '7', '6', '5', '4', '3'	;UN 9 8 7 6 5 4 3 
	defb	   2,   1, 255, '?', 255, '=', 255, ';' ;b a UN ? UN = UN ;
	defb	  10,   9,   8,   7,   6,   5,   4,  3	;j i h g f e d c
	defb	  18,  17,  16,  15,  14,  13,  12,  11	;r a p o n m l k
	defb	  26,  25,  24,  23,  22,  21,  20,  19	;z y x w v u t s
