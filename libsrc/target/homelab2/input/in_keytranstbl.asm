
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl


; Homelab 2 table
.in_keytranstbl
	; Line 0 contains shift
	defb	' ',  11,  8,   9,  10,   13,  7,  27	; SP UP LEFT RIGHT HOME ENTER TAB RUN/BRK
	defb	'0', '1', '2', '3', '4', '5', '6', '7'	; 0 1 2 3 4 5 6 7
	defb	'8', '9', ':', ';', ',', '=', '.', '/'	; 8 9 : ; , = . /
	defb	'@', 'a', 'b', 'c', 'd', 'e', 'f', 'g'	; @ a b c d e f g
	defb	'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o'	; h i j k l m n o
	defb	'p', 'q', 'r', 's', 't', 'u', 'v', 'w'	; p q r s t u v w
	defb	'x', 'y', 'z', '[','\\', ']','\"', 255	; x y z [ \ ] " ALT

;Shifted
	defb	' ',  10,  9,   8,  11,   13,  7,  27	; SP UP LEFT RIGHT HOME ENTER TAB RUN/BRK
	defb	 12, '!', '2', '#', '$', '%', '&', '\''	; 0 1 2 3 4 5 6 7
	defb	'(', ')', '*', '+', '<', '-', '>', '?'	; 8 9 : ; , = . /
	defb	'@', 'A', 'B', 'C', 'D', 'E', 'F', 'G'	; @ a b c d e f g
	defb	'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O'	; h i j k l m n o
	defb	'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W'	; p q r s t u v w
	defb	'X', 'Y', 'Z', '{', '|', '}','\'', 255	; x y z [ \ ] " ALT

;Control
	defb	' ',  11,  8,   9,  10,   13,  7,  27	; SP UP LEFT RIGHT HOME ENTER TAB RUN/BRK
	defb	'0', '1', '2', '3', '4', '5', '6', '7'	; 0 1 2 3 4 5 6 7
	defb	'8', '9', ':', ';', ',', '=', '.', '/'	; 8 9 : ; , = . /
	defb	'@',   1,   2,   3,   4,   5,   6,   7	; @ a b c d e f g
	defb	  8,   9,  10,  11,  12,  13,  14,  15	; h i j k l m n o
	defb	 16,  17,  18,  19,  20,  21,  22,  23	; p q r s t u v w
	defb	 24,  25,  26, '[','\\', ']','\"', 255	; x y z [ \ ] " ALT
