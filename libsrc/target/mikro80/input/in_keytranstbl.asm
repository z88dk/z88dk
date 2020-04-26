
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl


;Unshifted
	defb	'0', '1', '2', '3', '4', '5', '6', 255	; 0 1 2 3 4 5 6 UN
	defb	'7', '8', '9', ':', ';', ',', '-', 255	; 7 8 9 : ; , - UN
	defb	'.', '/', '"', 'a', 'b', 'c', 'd', 255	; . / " a b c d UN
	defb	'e', 'f', 'g', 'h', 'i', 'j', 'k', 255	; e f g h i j k UN
	defb	'l', 'm', 'n', 'o', 'p', 'q', 'r', 255	; l m n o p q r UN
	defb	's', 't', 'u', 'v', 'w', 'x', 'y', 255	; s t u v w x y UN
	defb	'z', '[','\\', ']', '~', '+', ' ', 255	; z [ \ ] ~ + SP UN
	defb	  9,   8,  11,  10,  13,  27,  12, 255	; RIGHT LEFT UP DOWN RET ESC HOME UN (HOME = BKSPACE)
	; Line 8
	; RUS/LAT CTRL SHIFT - - - - - 

; Shifted
	defb	'0', '!','\"', '#', '$', '%', '&', 255	; 0 1 2 3 4 5 6 UN
	defb	'&', '(', ')', '*', '+', '<', '=', 255	; 7 8 9 : ; , - UN
	defb	'>', '?', '@', 'A', 'B', 'C', 'D', 255	; . / " a b c d UN
	defb	'E', 'F', 'G', 'H', 'I', 'J', 'K', 255	; e f g h i j k UN
	defb	'L', 'M', 'N', 'O', 'P', 'Q', 'R', 255	; l m n o p q r UN
	defb	'S', 'T', 'U', 'V', 'W', 'X', 'Y', 255	; s t u v w x y UN
	defb	'Z', '{', '|', '}', '`', '_', ' ', 255	; z [ \ ] ~ + SP UN
	defb	  9,   8,  11,  10,  13,  27, 127, 255	; RIGHT LEFT UP DOWN RET ESC HOME UN (HOME = BKSPACE)


; Ctrl
	defb	'0', '1', '2', '3', '4', '5', '6', 255	; 0 1 2 3 4 5 6 UN
	defb	'7', '8', '9', ':', ';', ',', '-', 255	; 7 8 9 : ; , - UN
	defb	'.', '/', '"',   1,   2,   3,   4, 255	; . / " a b c d UN
	defb	  5,   6,   7,   8,   9,  10,  11, 255	; e f g h i j k UN
	defb	 12,  13,  14,  15,  16,  17,  18, 255	; l m n o p q r UN
	defb	 19,  20,  21,  22,  23,  24,  25, 255	; s t u v w x y UN
	defb	 26, '[','\\', ']', '~', '+', ' ', 255	; z [ \ ] ~ + SP UN
	defb	  9,   8,  11,  10,  13,  27,  12, 255	; RIGHT LEFT UP DOWN RET ESC HOME UN (HOME = BKSPACE)

