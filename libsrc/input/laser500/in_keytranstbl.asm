
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; Bit 7 is always unused, so skip it: 84 bytes per table
;Unshifted
	defb	255, 'z', 'x', 'c', 'v', 'b', 'n'	; SHIFT z x c v b n
	defb	255, 'a', 's', 'd', 'f', 'g', 'h'	; CTRL a s d f g h
	defb   '\t', 'q', 'w', 'e', 'r', 't', 'y'	; TAB q w e r t y
	defb	 27, '1', '2', '3', '4', '5', '6'	; ESC 1 2 3 4 5 6
	defb	255, '=', '-', '0', '9', '8', '7'	; UN = - 0 9 8 7
	defb	 12, 255, 255, 'p', 'o', 'i', 'u'	; BS UN UN p o i u
	defb	 13, 255,'\'', ':', 'l', 'k', 'j'	; RET UN ' : l k j
	defb	255, '`', ' ', '/', '.', ',', 'm'	; GRAPH ` SP \ . , m
	; 6bff, 6aff, 69ff, 68ff5
	defb	255,'\\', ']', '[', '~', 127, 141	; UN \ [ ] ~ DEL INS
	defb	  6, 138, 139,  11,   8,   9,  10	; CAPS DELLINE HOME UP LEFT RIGHT DOWN
	defb	255, 137, 136, 135, 134, 133, 132	; UN F10 F9 F8 F7 F6 F5
	defb	255, 128, 129, 130, 131, 255, 255	; UN F1 F2 F3 F4 UN UN

;Shifted
	defb	255, 'Z', 'X', 'C', 'V', 'B', 'N'	; SHIFT z x c v b n
	defb	255, 'A', 'S', 'D', 'F', 'G', 'H'	; SHIFT a s d f g h
	defb   '\t', 'Q', 'W', 'E', 'R', 'T', 'Y'	; TAB q w e r t y
	defb	 27, '!', '@', '#', '$', '%', '^'	; ESC 1 2 3 4 5 6
	defb	255, '+', '_', ')', '(', '*', '&'	; UN = - 0 9 8 7
	defb	127, 255, 255, 'P', 'O', 'I', 'U'	; BS UN UN p o i u
	defb	 13, 255,'\"', ';', 'L', 'K', 'J'	; RET UN ' : l k j
	defb	255, '`', ' ', '?', '>', '<', 'M'	; GRAPH \ SP \ . , m
	; 6bff, 6aff, 69ff, 68ff5
	defb	255,'\\', ']', '[', '~', 127, 141	; UN \ [ ] ~ DEL INS
	defb	  6, 138, 139,  11,   8,   9,  10	; CAPS DELLINE HOME UP LEFT RIGHT DOWN
	defb	255, 137, 136, 135, 134, 133, 132	; UN F10 F9 F8 F7 F6 F5
	defb	255, 128, 129, 130, 131, 255, 255	; UN F1 F2 F3 F4 UN UN

;Control
	defb	255,  26,  24,   3,  22,   2,  14	; SHIFT z x c v b n
	defb	255,   1,  19,   4,   6,   7,   8	; SHIFT a s d f g h
	defb   '\t',  17,  23,   5,   18,  20, 25	; TAB q w e r t y
	defb	 27, '1', '2', '3', '4', '5', '6'	; ESC 1 2 3 4 5 6
	defb	255, '=', '-', '0', '9', '8', '7'	; UN = - 0 9 8 7
	defb	 12, 255, 255,  16,  15,   9,  21	; BS UN UN p o i u
	defb	 13, 255,'\'', ':',  12,  11,  10	; RET UN ' : l k j
	defb	255, '`', ' ', '/', '.', ',',  13	; GRAPH ` SP \ . , m
	; 6bff, 6aff, 69ff, 68ff5
	defb	255,'\\', ']', '[', '~', 127, 141	; UN \ [ ] ~ DEL INS
	defb	  6, 138, 139,  11,   8,   9,  10	; CAPS DELLINE HOME UP LEFT RIGHT DOWN
	defb	255, 137, 136, 135, 134, 133, 132	; UN F10 F9 F8 F7 F6 F5
	defb	255, 128, 129, 130, 131, 255, 255	; UN F1 F2 F3 F4 UN UN
