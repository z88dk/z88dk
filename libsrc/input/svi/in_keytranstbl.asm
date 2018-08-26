
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; Each table 72 bytes

;Unshifted
	defb	'7', '6', '5', '4', '3', '2', '1', '0'	; 7 6 5 4 3 2 1 0
	defb	'/', '.', '=', ',','\'', ':', '9', '8'	; / . = , ' : 9 8
	defb	'g', 'f', 'e', 'd', 'c', 'b', 'a', '-'	; g f e d c b a -
	defb	'o', 'n', 'm', 'l', 'k', 'j', 'i', 'h'	; o n m l k j i h
	defb	'w', 'v', 'u', 't', 's', 'r', 'q', 'p'	; w v u t s r q p
	defb	 11,  12, ']','\\', '[', 'z', 'y', 'x'	; UP, DEL, ] \ [ z y x
	defb	  8,  13, 255, 27,  255, 255, 255, 255	; LEFT, RET, STOP, ESC, RGRAPH, LGRAPH, CTROL, SHIFT
	defb	 10, 255, 255, 132, 131, 130, 129, 128	; DOWN, INSERT, HOME, F5, F4, F3, F2, F1
	defb	  9, 255, 255, 255,  12, 127,   9, ' '	; RIGHT, -, PRTSCR, PAUSE, CAPS, DEL, TAB, SPACE


; Shifted
	defb	'&', '^', '%', '$', '#', '@', '!', ')'	; 7 6 5 4 3 2 1 0
	defb	'?', '>', '+', '<','\"', ';', '*', '('	; / . = , ' : 9 8
	defb	'G', 'F', 'E', 'D', 'C', 'B', 'A', '_'	; g f e d c b a -
	defb	'O', 'N', 'M', 'L', 'K', 'J', 'I', 'H'	; o n m l k j i h
	defb	'W', 'V', 'U', 'T', 'S', 'R', 'Q', 'P'	; w v u t s r q p
	defb	 11, 127, '}', '~', '{', 'Z', 'Y', 'X'	; UP, DEL, ] \ [ z y x
	defb	  8,  13, 255, 27,  255, 255, 255, 255	; LEFT, RET, STOP, ESC, RGRAPH, LGRAPH, CTROL, SHIFT
	defb	 10, 255, 255, 132, 131, 130, 129, 128	; DOWN, INSERT, HOME, F5, F4, F3, F2, F1
	defb	  9, 255, 255, 255,  12, 127,   9, ' '	; RIGHT, -, PRTSCR, PAUSE, CAPS, DEL, TAB, SPACE


; Control
	defb	'7', '6', '5', '4', '3', '2', '1', '0'	; 7 6 5 4 3 2 1 0
	defb	'/', '.', '=', ',','\'', ':', '9', '8'	; / . = , ' : 9 8
	defb	  7,   6,   5,   4,   3,   2,   1, '-'	; g f e d c b a -
	defb	 15,  14,  13,  12,  11,  10,   9,   8	; o n m l k j i h
	defb	 23,  22,  21,  20,  19,  18,  17,  16	; w v u t s r q p
	defb	 11,  12, ']','\\', '[',  26,  25,  24	; UP, DEL, ] \ [ z y x
	defb	  8,  13, 255, 27,  255, 255, 255, 255	; LEFT, RET, STOP, ESC, RGRAPH, LGRAPH, CTROL, SHIFT
	defb	 10, 255, 255, 132, 131, 130, 129, 128	; DOWN, INSERT, HOME, F5, F4, F3, F2, F1
	defb	  9, 255, 255, 255,  12, 127,   9, ' '	; RIGHT, -, PRTSCR, PAUSE, CAPS, DEL, TAB, SPACE
