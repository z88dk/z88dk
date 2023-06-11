; 
; This is a qwerty keyboard setup for the PK-8000
;
; The original hardware actually has a jcuken

   SECTION rodata_clib
   PUBLIC  in_keytranstbl

; Each table = 80 bytes

in_keytranstbl:
	defb	'0', '1', '2', '3', '4', '5', '6', '7'	; 0 1 2 3 4 5 6 7
	defb	'8', '9', ',', '-', '.', ':', ';', '?'	; 8 9 , - . : ; ?
	defb	'[', '|', ']', '~', '^', '@', 'a', 'b'	; [ | ] ~ ^ @ A B
	defb	'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'	; c d e f g h i j
	defb	'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r'	; k l m n o p q r
	defb	's', 't', 'u', 'v', 'w', 'x', 'y', 'z'	; s t u v w x y z
	defb	255, 255, 138, 137, 255, 128, 129, 130	; SH LCTRL F10 F9 LALT F1 F2 F3
	defb	131, 132,  27,   7, 140,  12, 255,  13	;F4 F5 ESC TAB F12 BKSP RCTRL RET
	defb	' ', 255, 255, 127,  8,    9,  10,  11	;SP CLS INS DEL LEFT UP DOWN RIGHT
	defb	255, 255, 255, 255, 255, 255, 255, 255	; U-L D-R MENU BEGIN END END_PAGE BEGIN_PAGE UN

; Shifted
	defb	')', '!', '@', '#', '$', '%', '6', '&'	; 0 1 2 3 4 5 6 7
	defb	'*', '(', '<', '_', '>','\'','\"', '/'	; 8 9 , - . : ; ?
	defb	'{', '\\','}', '~', '^', '@', 'A', 'B'	; [ | ] ~ ^ @ A B
	defb	'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'	; c d e f g h i j
	defb	'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R'	; k l m n o p q r
	defb	'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'	; s t u v w x y z
	defb	255, 255, 138, 137, 255, 128, 129, 130	; SH LCTRL F10 F9 LALT F1 F2 F3
	defb	131, 132,  27,   7, 140,  12, 255,  13	;F4 F5 ESC TAB F12 BKSP RCTRL RET
	defb	' ', 255, 255, 127,  8,    9,  10,  11	;SP CLS INS DEL LEFT UP DOWN RIGHT
	defb	255, 255, 255, 255, 255, 255, 255, 255	; U-L D-R MENU BEGIN END END_PAGE BEGIN_PAGE UN

; Ctrl
	defb	'0', '1', '2', '3', '4', '5', '6', '7'	; 0 1 2 3 4 5 6 7
	defb	'8', '9', ',', '-', '.', ':', ';', '?'	; 8 9 , - . : ; ?
	defb	'[', '|', ']', '~', '^', '@',   1,   2	; [ | ] ~ ^ @ A B
	defb	  3,   4,   5,   6,   7,   8,   9,  10	; c d e f g h i j
	defb	 11,  12,  13,  14,  15,  16,  17,  18	; k l m n o p q r
	defb	 19,  20,  21,  22,  23,  24,  25,  26	; s t u v w x y z
	defb	255, 255, 138, 137, 255, 128, 129, 130	; SH LCTRL F10 F9 LALT F1 F2 F3
	defb	131, 132,  27,   7, 140,  12, 255,  13	;F4 F5 ESC TAB F12 BKSP RCTRL RET
	defb	' ', 255, 255, 127,  8,    9,  10,  11	;SP CLS INS DEL LEFT UP DOWN RIGHT
	defb	255, 255, 255, 255, 255, 255, 255, 255	; U-L D-R MENU BEGIN END END_PAGE BEGIN_PAGE UN
