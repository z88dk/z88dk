
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

; 45 bytes per table
;Unshifted
	defb	'r', 'e', 'w', 't', 'q'		; r e w t q
	defb	'f', 'd', 's', 'g', 'a'		; f d s g a
	defb	'c', 'x', 'z', 'v', 255		; c x z v SHIFT
	defb	' ', 255, 255, 255, 255 	; SP UN UN UN UN
	defb	255, 255, 255, 255, 255		; UN NUM CS UN UPPER
	defb	'j', 'k', 'l', 'h',  13		; j k l h RET
	defb	'u', 'i', 'o', 'y', 'p'		; u i o y p
	defb	'n', 'm',  11, 'b', 255		; n m UP b CTRL
	defb	255,   8,  10, 255,  9 		; UN LEFT DN UN RIGHT
; Upper
	defb	'R', 'E', 'W', 'T', 'Q'		; r e w t q
	defb	'F', 'D', 'S', 'G', 'A'		; f d s g a
	defb	'C', 'X', 'Z', 'V', 255		; c x z v SHIFT
	defb	' ', 255, 255, 255, 255 	; SP UN UN UN UN
	defb	255, 255, 255, 255, 255		; UN NUM CS UN UPPER
	defb	'J', 'K', 'L', 'H',  13		; j k l h RET
	defb	'U', 'I', 'O', 'Y', 'P'		; u i o y p
	defb	'N', 'M',  11, 'B', 255		; n m UP b CTRL
	defb	255,   8,  10, 255,   9		; UN LEFT DN UN RIGHT
; Number 
	defb	'4', '3', '2', '5', '1'		; r e w t q
	defb	'F', 'D', 'S', 'G', 'A'		; f d s g a
	defb	'C', 'X', 'Z', 'V', 255		; c x z v SHIFT
	defb	' ', 255, 255, 255, 255 	; SP UN UN UN UN
	defb	255, 255, 255, 255, 255		; UN NUM CS UN UPPER
	defb	'J', '{', '}', 'H',  13		; j k l h RET
	defb	'7', '8', '9', '6', '0'		; u i o y p
	defb	'N', 'M',  11, 'B', 255		; n m UP b CTRL
	defb	255,   8,  10, 255,   9		; UN LEFT DN UN RIGHT
; Symbols
	defb	'$', '#','\"', '%', '!'		; r e w t q
	defb	'^', '=', '+', '_', '-'		; f d s g a
	defb	':', '/', '*', ';', 255		; c x z v SHIFT
	defb	' ', 255, 255, 255, 255 	; SP UN UN UN UN
	defb	255, 255, 255, 255, 255		; UN NUM CS UN UPPER
	defb	'>', '[', ']', '<',  12		; j k l h RET
	defb   '\'', '(', ')', '&', '@'		; u i o y p
	defb	',', '.',  11, 'B', 255		; n m UP b CTRL
	defb	255,   8,  10, 255,   9		; UN LEFT DN UN RIGHT



; Ctrl
	defb	 18,   5,  23,  20,  17		; r e w t q
	defb	  6,   4,  19,   7,   1		; f d s g a
	defb	  3,  24,  26,  22, 255		; c x z v SHIFT
	defb	' ', 255, 255, 255, 255 	; SP UN UN UN UN
	defb	255, 255, 255, 255, 255		; UN NUM CS UN UPPER
	defb	 10,  11,  12,   8, 127		; j k l h RET
	defb	 21,   9,  15,  25,  16		; u i o y p
	defb	 14,  13,  11,   2, 255		; n m UP b CTRL
	defb	255,   8,  10, 255,   9		; UN LEFT DN UN RIGHT

