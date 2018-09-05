
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key
; http://www.russelldavis.org/CamputersLynx/files/Newsletters/Lynx%20User/Lynx%20User1.pdf

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; 80 bytes per table

;Unshifted

	defb	255,  27,  10,  11, 255, 255, 255, '1'	; SHIFT ESC DOWN UP SHIFTLK - - - 1
	defb	255, 255, 'c', 'd', 'x', 'e', '4', '3'	; - - c d x e 4 3
	defb	255, 255, 'a', 's', 'z', 'w', 'q', '2'	; - CTRL a s z w q 2
	defb	255, 255, 'f', 'g', 'v', 't', 'r', '5'	; - - f g v t r 5
	defb	255, 255, 'b', 'n', ' ', 'h', 'y', '6'	; - - b n SP h y 6
	defb	255, 255, 'j', 255, 'm', 'u', '8', '7'	; - - j - m u 8 7
	defb	255, 255, 'k', 255, ',', 'o', 'i', '9'	; - - k , - o i 9
	defb	255, 255, ':', 255, '.', 'l', 'p', '0'	; - - : - . l p 0
	defb	255, 255, ';', 255, '/', '[', '@', '-'	; - - ; - / [ @ '-'
	defb	255, 255,   9, 255,  13,   8, ']', 12	; - - RIGHT - RET LEFT ] DEL

; Shifted
	defb	255,  27,  10,  11, 255, 255, 255, '!'	; SHIFT ESC DOWN UP SHIFTLK - - - 1
	defb	255, 255, 'C', 'D', 'X', 'E', '$', '#'	; - - c d x e 4 3
	defb	255, 255, 'A', 'S', 'Z', 'W', 'Q','\"'	; - CTRL a s z w q 2
	defb	255, 255, 'F', 'G', 'V', 'T', 'R', '%'	; - - f g v t r 5
	defb	255, 255, 'B', 'N', ' ', 'H', 'Y', '&'	; - - b n SP h y 6
	defb	255, 255, 'J', 255, 'M', 'U', '(','\''	; - - j - m u 8 7
	defb	255, 255, 'K', 255, '<', 'O', 'I', ')'	; - - k , - o i 9
	defb	255, 255, '*', 255, '>', 'L', 'P', '_'	; - - : - . l p 0
	defb	255, 255, '+', 255, '?', '{','\\', '='	; - - ; - / [ @ '-'
	defb	255, 255,   9, 255,  13,   8, '}', 127	; - - RIGHT - RET LEFT ] DEL

; Control
	defb	255,  27,  10,  11, 255, 255, 255, '1'	; SHIFT ESC DOWN UP SHIFTLK - - - 1
	defb	255, 255,   3,   4,  24,   5, '4', '3'	; - - c d x e 4 3
	defb	255, 255,   1,  19,  26,  23,  17, '2'	; - CTRL a s z w q 2
	defb	255, 255,   6,   7,  22,  20,  18, '5'	; - - f g v t r 5
	defb	255, 255,   2,  14, ' ',   8,  25, '6'	; - - b n SP h y 6
	defb	255, 255,  10, 255,  13,  21, '8', '7'	; - - j - m u 8 7
	defb	255, 255,  11, 255, ',',  15,   9, '9'	; - - k , - o i 9
	defb	255, 255, ':', 255, '.',  12,  16, '0'	; - - : - . l p 0
	defb	255, 255, ';', 255, '/', '[', '@', '-'	; - - ; - / [ @ '-'
	defb	255, 255,   9, 255,  13,   8, ']', 12	; - - RIGHT - RET LEFT ] DEL
