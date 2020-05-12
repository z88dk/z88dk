
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl



;Unshifted - lower 2 bits are always unused, so each port is 6

	defb	 13,  12, '.', ':', '-', 255	; RET BS . : - INS
	defb	255, '/','\\', 'h', '0', 138	; END / \ h 0 F11
	defb	  9, ',', 'v', 'z', '9', 137	; RIGHT , v z 9 F10
	defb	139, '~', 'd', ']', '8', 136	; F12 ~ d ] 8 F9
	defb	  8, 'b', 'l', '[', '7', 135	; LEFT b l [ 7 F8
	defb 	' ', 'x', 'o', 'g', '6', 134	; SP x o g 6 F7
	defb	 27, 't', 'r', 'n', '5', 133	; ESC t r n 5 F6
	defb	  7, 'i', 'p', 'e', '4', 132	; TAB i p e 4 F5
	defb	 10, 'm', 'a', 'k', '3', 131	; DOWN s w u 2 F4
	defb	 11, 's', 'w', 'u', '2', 130	; UP s w u 2 F3
	defb	255, '=', 'y', 'c', '1', 129	; HOME = y c 1 F2
	defb	255, 'q', 'f', 'j', ';', 128	; LAT q f j " F1
	; shift is on line 12

; Shifted
	defb	 13, 127, '>', '*', '=', 255	; RET BS . : - INS
	defb	255,'\\', '/', 'H', '0', 138	; END / \ h 0 F11
	defb	  9, '<', 'V', 'Z', ')', 137	; RIGHT , v z 9 F10
	defb	139, '@', 'D', '}', '(', 136	; F12 ~ d ] 8 F9
	defb	  8, 'B', 'L', '{','\'', 135	; LEFT b l [ 7 F8
	defb 	' ', 'X', 'O', 'G', '&', 134	; SP x o g 6 F7
	defb	 27, 'T', 'R', 'N', '%', 133	; ESC t r n 5 F6
	defb	  7, 'I', 'P', 'E', '$', 132	; TAB i p e 4 F5
	defb	 10, 'M', 'A', 'K', '#', 131	; DOWN s w u 2 F4
	defb	 11, 'S', 'W', 'U','\"', 130	; UP s w u 2 F3
	defb	255, '^', 'Y', 'C', '!', 129	; HOME = y c 1 F2
	defb	255, 'Q', 'F', 'J', '+', 128	; LAT q f j " F1

; Ctrl
	defb	 13,  12, '.', ':', '-', 255	; RET BS . : - INS
	defb	255, '/','\\',   8, '0', 138	; END / \ h 0 F11
	defb	  9, ',',  22,  26, '9', 137	; RIGHT , v z 9 F10
	defb	139, '~',   4, ']', '8', 136	; F12 ~ d ] 8 F9
	defb	  8,   2,  12, '[', '7', 135	; LEFT b l [ 7 F8
	defb 	' ',  24,  15,   7, '6', 134	; SP x o g 6 F7
	defb	 27,  20,  18,  14, '5', 133	; ESC t r n 5 F6
	defb	  7,   9,  16,   5, '4', 132	; TAB i p e 4 F5
	defb	 10,  13,   1,  11, '3', 131	; DOWN s w u 2 F4
	defb	 11,  19,  23,  21, '2', 130	; UP s w u 2 F3
	defb	255, '=',  25,   3, '1', 129	; HOME = y c 1 F2
	defb	255,  17,   6,  10, ';', 128	; LAT q f j " F1
