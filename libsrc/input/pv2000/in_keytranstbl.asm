
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL'
; key represented by FUNC
; http://www43.tok2.com/home/cmpslv/Pv2000/EnrPV.htm

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

;
;
; First 4 in each row from port $20, second half from $10
; Each table is 56 bytes

;Unshifted
	defb	'1', '2', '3', '4', '5', '6', '7', '8'
	defb	'q', 'w', 'e', 'r', 't', 'y', 'u', 'i'
	defb	'a', 's', 'd', 'f', 'g', 'h', 'j', 'k'
	defb	255, 'z', 'x', 'c', 'v', 'b', 'n', ' '		;Kana
	defb	255, 255, 255,'\\', '0', '^', '-', '9'		;CLS/HOME
	defb	255, 255, 255, 255, 'p', '[', '@', 'o'		;J1 up-right, J1 down-right, J1 down-left, J1-up-left
	defb	255, 255, 255, 255, ';', ']', ':', 'l'		; J2-right, J2-left, J1-right, j1-left
	defb	255, 255, 255, 255, ',', '/', '.', 'm'		;J2-up, J2-down, j1-up, j1-down
	defb	255, 255, 255, 255, 255,  12, 255,  13		; J2-but1, J2-but0, J1-but1, J1-but0, -, inst/del, mode, return
	defb    255, 255, 255, 255, 255, 255, 255, 255  	; STOP/CONT, -, -, -, -, -, -, -, -

;Shifted
	defb	'!', '\"','#', '$', '%', '&', '\'','('
	defb	'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I'
	defb	'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K'
	defb	255, 'Z', 'X', 'C', 'V', 'B', 'N', ' '		;Kana
	defb	255, 255, 255, '|', '0', '~', '=', ')'		;CLS/HOME
	defb	255, 255, 255, 255, 'p', '{', '`', 'O'		;J1 up-right, J1 down-right, J1 down-left, J1-up-left
	defb	255, 255, 255, 255, ';', '}', '*', 'L'		; J2-right, J2-left, J1-right, j1-left
	defb	255, 255, 255, 255, '<', '?', '>', 'M'		;J2-up, J2-down, j1-up, j1-down
	defb	255, 255, 255, 255, 255, 127, 255,  13		; J2-but1, J2-but0, J1-but1, J1-but0, -, inst/del, mode, return
	defb    255, 255, 255, 255, 255, 255, 255, 255  	; STOP/CONT, -, -, -, -, -, -, -, -

;Func modifier (control)
	defb 	 27,  28,  29,  30,  31, 135, '`',  134
        defb     17,  23,   5,  18,  20,  25,  21,   9
        defb      1,  19,   4,   6,   7,   8,  10,  11
        defb    255,  26,  24,   3,  22,   2,  14,  ' '
        defb    255, 255, 255, '\\', 255, 255, 255, 255
	defb	255, 255, 255, 255,  16, '[', '@',  15
	defb	255, 255, 255, 255, 255, ']', 255,  12		; J2-right, J2-left, J1-right, j1-left
	defb	255, 255, 255, 255, ',', '/', '.',  13		;J2-up, J2-down, j1-up, j1-down
	defb	255, 255, 255, 255, 255, 127, 255,  13		; J2-but1, J2-but0, J1-but1, J1-but0, -, inst/del, mode, return
	defb    255, 255, 255, 255, 255, 255, 255, 255  	; STOP/CONT, -, -, -, -, -, -, -, -
