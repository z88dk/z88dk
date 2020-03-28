
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl


; Homelab 3/4 table
.in_keytranstbl

; 64 bytes per table

;Unshifted
	defb	 10,  11,   9,  8		; DOWN UP RIGHT LEFT
	defb	' ',  13, 255, 255		; SPACE ENTER UN UN
	defb	255, 255, 255, 255		; ?? LSHIFT RSHIFT ALT
	defb	255, 129, 128, 255		; CASS F2 F1
	defb	'0', '1', '2', '3'		; 0 1 2 3
	defb	'4', '5', '6', '7'		; 4 5 6 7 
	defb	'8', '9', ':', ';'		; 8 9 : ;
	defb	',', '=', '.', '?'		; , = . ?
	defb	'~', 'a', 131, 'b'		; ~ a F4 B
	defb	'c', 'd', 'e', 132		; c d e F5
	defb	'f', 'g', 'h', 'i'		; f g h i
	defb	'j', 'k', 'l', 'm'		; j k l m
	defb	'n', 'o', ']', '['		; n o ] [ 
	defb	'p', 'q', 'r', 's'		; p q r s
	defb	't', 'u', 135, 'v'		; t u F8 v
	defb	'w', 'x', 'y', 'z'		; w x y z


;Shifted
	defb	 10,  11,   9,  8		; DOWN UP RIGHT LEFT
	defb	' ',  13, 255, 255		; SPACE ENTER UN UN
	defb	255, 255, 255, 255		; ?? LSHIFT RSHIFT ALT
	defb	255, 129, 128, 255		; CASS F2 F1
	defb	'0', '!','\"', '#'		; 0 1 2 3
	defb	'$', '%', '&','\''		; 4 5 6 7 
	defb	'(', ')', '*', '+'		; 8 9 : ;
	defb	'<', '-', '>', '/'		; , = . /
	defb	'~', 'A', 131, 'B'		; ~ a F4 B
	defb	'C', 'D', 'E', 132		; c d e F5
	defb	'F', 'G', 'H', 'I'		; f g h i
	defb	'J', 'K', 'L', 'M'		; j k l m
	defb	'N', 'O', '}', '{'		; n o [ ]
	defb	'P', 'Q', 'R', 'S'		; p q r s
	defb	'T', 'U', 135, 'V'		; t u F8 v
	defb	'W', 'X', 'Y', 'Z'		; w x y z

;Ctrl
	defb	 10,  11,   9,  8		; DOWN UP RIGHT LEFT
	defb	' ',  13, 255, 255		; SPACE ENTER UN UN
	defb	255, 255, 255, 255		; ?? LSHIFT RSHIFT ALT
	defb	255, 129, 128, 255		; CASS F2 F1
	defb	'0', '1', '2', '3'		; 0 1 2 3
	defb	'4', '5', '6', '7'		; 4 5 6 7 
	defb	'8', '9', ':', ';'		; 8 9 : ;
	defb	',', '=', '.', '?'		; , = . ?
	defb	'~',   1, 131,   2		; ~ a F4 B
	defb	  3,   4,   5, 132		; c d e F5
	defb	  6,   7,   8,   9		; f g h i
	defb	 10,  11,  12, 13		; j k l m
	defb	 14,  15, ']', '['		; n o ] [ 
	defb	 16,  17,  18,  19		; p q r s
	defb	 20,  21, 135,  22		; t u F8 v
	defb	 23,  24,  25,  26		; w x y z
