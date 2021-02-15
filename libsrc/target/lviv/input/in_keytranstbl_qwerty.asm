
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl_qwerty


; This is a QWERTY keyboard layout
.in_keytranstbl_qwerty


;Unshifted - 8 rows, 64 bytes + 4 rows, 32 bytes
; PPI2 PORTA
	defb	'6', '7', '8', 255,   7, '-', '0', '9'	; 6 7 8 INS TAB - 0 9
	defb	'u', 'i', 'o',  13, 127, ']', '[', 'p'	; G [ ] RET DEL * H Z
	defb	'h', 'j', 'k',  12, 255,'\\', ';', 'l'	; r o l BKSP . \ v d
	defb	' ', ',', '.', 255, '_', 255, '/', 255	; SP b @ RSHIFT _ RCTRL / ,
	defb	 27, 128, 129, '5', '4', '3', '2', '1'	; ESC F1 F2 5 4 3 2 1
	defb	255, 255, 'q', 'y', 't', 'r', 'e', 'w'	; UN UN j n e k u c
	defb	';', 255,   6, 'g', 'f', 'd', 's', 'a'	; ; LCTRL CAPS p a w y f
	defb	255, 'z', 'x', 'm', 'n', 'b', 'v', 'c'	; LSHIFT q ^ x t i m s
; PP2 PORTC
	defb	255, 255, 255, 255, 133, 132, 131, 130  ; UN UN UN UN F6 F5 F4 F3
	defb	255, 255, 255, 255, 134, 135, 136, 137  ; UN UN UN UN F7 F8 F9 F10
	defb	255, 255, 255, 255, 255, 255, 138, 139	; UN UN UN UN PGUP SCRLOCK  F11 F12
	defb	255, 255, 255, 255,   9,  11,   8,  10  ; UN UN UN UN RIGHT UP LEFT DOWN

; Shifted
; PPI2 PORTA
	defb	'&','\'', '(', 255,   7, '=', '0', ')'	; 6 7 8 INS TAB - 0 9
	defb	'U', 'I', 'O',  13, 127, '}', '{', 'P'	; G [ ] RET DEL * H Z
	defb	'H', 'J', 'K',  12, 255,'\\', ':', 'L'	; r o l BKSP . \ v d
	defb	' ', '<', '>', 255, '-', 255, '?', 255	; SP b @ RSHIFT _ RCTRL / ,
	defb	 27, 128, 129, '%', '$', '#', '@', '!'	; ESC F1 F2 5 4 3 2 1
	defb	255, 255, 'Q', 'Y', 'T', 'R', 'E', 'W'	; UN UN j n e k u c
	defb	':', 255,   6, 'G', 'F', 'D', 'S', 'A'	; ; LCTRL CAPS p a w y f
	defb	255, 'Z', 'X', 'M', 'N', 'B', 'V', 'C'	; LSHIFT q ^ x t i m s
; PP2 PORTC
	defb	255, 255, 255, 255, 133, 132, 131, 130  ; UN UN UN UN F6 F5 F4 F3
	defb	255, 255, 255, 255, 134, 135, 136, 137  ; UN UN UN UN F7 F8 F9 F10
	defb	255, 255, 255, 255, 255, 255, 138, 139	; UN UN UN UN PGUP SCRLOCK  F11 F12
	defb	255, 255, 255, 255,   9,  11,   8,  10  ; UN UN UN UN RIGHT UP LEFT DOWN


; Ctrl
; PPI2 PORTA
	defb	'6', '7', '8', 255,   7, '-', '0', '9'	; 6 7 8 INS TAB - 0 9
	defb	  7, '[', ']',  13, 127, '*',   8,  26	; G [ ] RET DEL * H Z
	defb	 18,  15,  12,  12, '.','\\',  22,   4	; r o l BKSP . \ v d
	defb	' ',   2, '@', 255, '_', 255, '?', ','	; SP b @ RSHIFT _ RCTRL / ,
	defb	 27, 128, 129, '5', '4', '3', '2', '1'	; ESC F1 F2 5 4 3 2 1
	defb	255, 255,  10,  14,   5,  11,  21,   3	; UN UN j n e k u c
	defb	';', 255,   6,  16,   1,  23,  25,   6	; ; LCTRL CAPS p a w y f
	defb	255,  17, '^',  24,  20,   9,  13,  19	; LSHIFT q ^ x t i m s
; PP2 PORTC
	defb	255, 255, 255, 255, 133, 132, 131, 130  ; UN UN UN UN F6 F5 F4 F3
	defb	255, 255, 255, 255, 134, 135, 136, 137  ; UN UN UN UN F7 F8 F9 F10
	defb	255, 255, 255, 255, 255, 255, 138, 139	; UN UN UN UN PGUP SCRLOCK  F11 F12
	defb	133, 132, 131, 130, 255, 255, 255, 255  ; F6 F5 F4 F3 UN UN UN UN
