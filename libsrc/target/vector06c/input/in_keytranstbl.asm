
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl


;Unshifted
	defb	   7, 127,  13,  12,   8, 11,   9,  10	; TAB DEL ENT BKSP LEFT UP RIGHT DOWN
	defb	 255, 255,  27, 128, 129, 130, 131, 132	; HOME PGUP ESC F1 F2 F3 F4 F5
	defb	 '0', '1', '2', '3', '4', '5', '6', '7'	; 0 1 2 3 4 5 6 7
	defb	 '8', '9', ':', ';', ',', '=', '.', '/'	; 8 9 ' ; , = . /
	defb	 '@', 'a', 'b', 'c', 'd', 'e', 'f', 'g'	; @ a b c d e f g
	defb	 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o'	; h i j k l m n o
	defb	 'p', 'q', 'r', 's', 't', 'u', 'v', 'w'	; p q r s t u v w
	defb	 'x', 'y', 'z', '[','\\', ']', '~', ' '	; x y z [ \ ] ~ SP

	; Line 8
	; RUS/LAT CTRL SHIFT - - - - - 

; Shifted
	defb	   7,  13, 127,  12,   8, 11,   9,  10	; TAB DEL ENT BKSP LEFT UP RIGHT DOWN
	defb	 255, 255,  27, 128, 129, 130, 131, 132	; HOME PGUP ESC F1 F2 F3 F4 F5
	defb	 '_', '!', '"', '#', '$', '%', '&', '^'	; 0 1 2 3 4 5 6 7
	defb	 '(', ')', '+', ':', '<', '-', '>', '?'	; 8 9 ' ; , = . /
	defb	 '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G'	; @ a b c d e f g
	defb	 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O'	; h i j k l m n o
	defb	 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W'	; p q r s t u v w
	defb	 'X', 'Y', 'Z', '{', '|', '}', '`', ' '	; x y z [ \ ] ~ SP


; Ctrl
	defb	   7, 127,  13,  12,   8, 11,   9,  10	; TAB DEL ENT BKSP LEFT UP RIGHT DOWN
	defb	 255, 255,  27, 128, 129, 130, 131, 132	; HOME PGUP ESC F1 F2 F3 F4 F5
	defb	 '0', '1', '2', '3', '4', '5', '6', '7'	; 0 1 2 3 4 5 6 7
	defb	 '8', '9', ':', ';', ',', '=', '.', '/'	; 8 9 ' ; , = . /
	defb	 '@',   1,   2,   3,   4,   5,   6,   7	; @ a b c d e f g
	defb	   8,   9,  10,  11,  12,  13,  14,  15	; h i j k l m n o
	defb	  16,  17,  18,  19,  20,  21,  22,  23	; p q r s t u v w
	defb	  24,  25,  26, '[','\\', ']', '~', ' '	; x y z [ \ ] ~ SP

