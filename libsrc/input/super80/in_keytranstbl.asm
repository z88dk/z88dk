
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl
	; 64 bytes per table
	defb	255, ' ', '9', '1', 'x', 'p', 'h', '@'	; REPT SP 9 1 X P H @
	defb	255,  12, ':', '2', 'y', 'q', 'i', 'a'	; SHIF DEL : 2 Y Q I A
	defb	255,   7, ';', '3', 'z', 'r', 'j', 'b'	; FIRE TAB ; 3 2 r J B
	defb	255,  10, ',', '4', '[', 's', 'k', 'c'	; CTRL LINEFEED , 4 [ S K C
	defb	  9,  13, 255, '5','\\', 't', 'l', 'd'	; RIGHT RETURN BRK 5 \ T L D
	defb	  8,  27, '.', '6', ']', 'u', 'm', 'e'	; LEFT ESC . 6 ] U M E
	defb	 10, 127, '/', '7', '^', 'v', 'n', 'f'	; DOWN DEL / 7 ^ V N F
	defb	 11,   6, '0', '8', '-', 'w', 'o', 'g'	; UP LOCK 0 8 - W O G


; Shifted
	defb	255, ' ', ')', '!', 'X', 'P', 'H', '`'	; REPT SP 9 1 X P H @
	defb	255, 127, '*','\"', 'Y', 'Q', 'I', 'A'	; SHIF BS : 2 Y Q I A
	defb	255,   7, '+', '#', 'Z', 'R', 'J', 'B'	; FIRE TAB ; 3 2 r J B
	defb	255,  10, '<', '$', '{', 'S', 'K', 'C'	; CTRL LINEFEED , 4 [ S K C
	defb	  9,  13, 255, '%', '|', 'T', 'L', 'D'	; RIGHT RETURN BRK 5 \ T L D
	defb	  8,  27, '>', '&', '}', 'U', 'M', 'E'	; LEFT ESC . 6 ] U M E
	defb	 10, 127, '?','\'', '~', 'V', 'N', 'F'	; DOWN DEL / 7 ^ V N F
	defb	 11,   6, '_', '(', '=', 'W', 'O', 'G'	; UP LOCK 0 8 - W O G

; Control
	defb	255, ' ', '9', '1',  24,  16,   8,   0	; REPT SP 9 1 X P H @
	defb	255,  12, ':', '2',  25,  17,   9,   1	; SHIF DEL : 2 Y Q I A
	defb	255,   7, ';', '3',  26,  18,  10,   2	; FIRE TAB ; 3 2 r J B
	defb	255,  10, ',', '4', '[',  19,  11,   3	; CTRL LINEFEED , 4 [ S K C
	defb	  9,  13, 255, '5','\\',  20,  12,   4	; RIGHT RETURN BRK 5 \ T L D
	defb	  8,  27, '.', '6', ']',  21,  13,   5	; LEFT ESC . 6 ] U M E
	defb	 10, 127, '/', '7', '^',  22,  14,   6	; DOWN DEL / 7 ^ V N F
	defb	 11,   6, '0', '8', '-',  23,  15,   7	; UP LOCK 0 8 - W O G
