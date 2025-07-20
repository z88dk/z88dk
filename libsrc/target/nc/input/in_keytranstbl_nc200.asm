





; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

    SECTION rodata_clib
    PUBLIC  in_keytranstbl

in_keytranstbl:


;; Unshifted - each table = 80 bytes
	defb	255, 255, 255,  13,   8, '4', 255, 255	;UN UN UN ENTER LEFT 4 RSHIFT SHIFT
	defb	'9', 255, 255, 255, ' ',  27, 255, 255	;9 UN UN UN SP ESC LCTRL LALT
	defb	255, '6', 255, '5',   7, '1', 255,   6	;UN 6 UN 5 TAB 1 RALT CAPS
	defb	'd', 's', 255, 'e', 'w', 'q', '2', '3'	;d s UN e w q 2 3
	defb	'f', 'r', 255, 'a', 'x', 'z', '7', '8'	;f r UN a x z 7 8
	defb	'c', 'g', 'y', 't', 'v', 'b', 255, 255	;c g y t v b UN UN
	defb	'n', 'h', '/','\\',   9,  12,  10, 255	;n h / \ RIGHT DEL DOWN UN
	defb	'k', 'm', 'u', 255,  11, 255, '=', 255	;k m u RCTRL UP \2 = UN
	defb	',', 'j', 'i','\'', '[', ']', '-', 255	;, k i ' [ ] - UN
	defb	'.', 'o', 'l', ':', 'p', 127, '0', 255	;. o l : p BS 0 UN


nc200_shifted:
;; Shifted
	defb	255, 255, 255,  13,   8, '$', 255, 255	;UN UN UN ENTER LEFT 5 RSHIFT SHIFT
	defb	'(', 255, 255, 255, ' ',  27, 255, 255	;9 UN UN UN SP ESC LCTRL LALT
	defb	255, '^', 255, '%',   7, '!', 255,   6	;UN 6 UN 5 TAB 1 RALT CAPS
	defb	'D', 'S', 255, 'E', 'W', 'Q','\"', '#'	;d s UN e w q 2 3
	defb	'F', 'R', 255, 'A', 'X', 'Z', '&', '*'	;f r UN a x z 7 8
	defb	'C', 'G', 'Y', 'T', 'V', 'B', 255, 255	;c g y t v b UN UN
	defb	'N', 'H', '?', '|',   9, 127,  10, 255	;n h / \ RIGHT DEL DOWN UN
	defb	'K', 'M', 'U', 255,  11, 255, '+', 255	;k m u RCTRL UP \2 = UN
	defb	'<', 'J', 'I', '@', '{', '}', '_', 255	;, k i ' [ ] - UN
	defb	'>', 'O', 'L', ';', 'P', 127, ')', 255	;. o l : p BS 0 UN


;; Control 
	defb	255, 255, 255,  13,   8, '4', 255, 255	;UN UN UN ENTER LEFT UN RSHIFT SHIFT
	defb	'9', 255, 255, 255, ' ',  27, 255, 255	;9 UN UN UN SP ESC LCTRL LALT
	defb	255, '6', 255, '5',   7, '1', 255,   6	;UN 6 UN 5 TAB 1 RALT CAPS
	defb	  4,  19, 255,   5,  23,  17, '2', '3'	;d s UN e w q 2 3
	defb	  6,  18, 255,   1,  24,  26, '7', '8'	;f r UN a x z 7 8
	defb	  3,   7,  25,  20,  22,   2, 255, 255	;c g y t v b UN UN
	defb	 14,   8, '/','\\',   9,  12,  10, 255	;n h / \ RIGHT DEL DOWN UN
	defb	 11,  13,  21, 255,  11, 255, '=', 255	;k m u RCTRL UP \2 = UN
	defb	',',  10,   9,'\'', '[', ']', '-', 255	;, k i ' [ ] - UN
	defb	'.',  15,  12, ':',  16, 127, '0', 255	;. o l : p BS 0 UN
