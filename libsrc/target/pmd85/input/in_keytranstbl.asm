
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl


;Unshifted
	; Lower 5 bits only
	defb	 27, '1', 'q', 'a', ' '		;K0 1 q a SP
	defb	128, '2', 'w', 's', 'y'		;K1 2 w s y
	defb	129, '3', 'e', 'd', 'x'		;K2 3 e d x
	defb	130, '4', 'r', 'f', 'c'		;K3 4 r f c
	defb	131, '5', 't', 'g', 'v'		;K4 5 t g v
	defb	132, '6', 'z', 'h', 'b'		;K5 6 z h b
	defb	133, '7', 'u', 'j', 'n'		;K6 7 u j n
	defb	134, '8', 'i', 'k', 'm'		;K7 8 i k m
	defb	135, '9', 'o', 'l', ','		;K8 9 o l ,
	defb	136, '0', 'p', ';', '.'		;K9 0 p ; .
	defb	137, '_', '@', ':', '/'		;K10 _ @ : /
	defb	138, '{','\\', '[', 255		;K11 { \ [ UN
	defb	139, 255, 12,  255, 255		;WRK BS LEFT |<- UN
	defb	  7, 127, 11,   10,  13		;C-D DEL UP DOWN EOL
	defb	141, 142,  9,  255,  13		;CLR RCL RIGHT ->| EOL2

	; KEY15
;	defb	255, 255, 255, 255, 255, 255, 255, 255	; UN UN UN UN UN SHIFT CTRL UN
; Shift
	defb	 27, '!', 'Q', 'A', ' '		;K0 1 q a SP
	defb	128,'\"', 'W', 'S', 'Y'		;K1 2 w s y
	defb	129, '#', 'E', 'D', 'X'		;K2 3 e d x
	defb	130, '$', 'R', 'F', 'C'		;K3 4 r f c
	defb	131, '%', 'T', 'G', 'V'		;K4 5 t g v
	defb	132, '&', 'Z', 'H', 'B'		;K5 6 z h b
	defb	133,'\'', 'U', 'J', 'N'		;K6 7 u j n
	defb	134, '(', 'I', 'K', 'M'		;K7 8 i k m
	defb	135, ')', 'O', 'L', '<'		;K8 9 o l ,
	defb	136, '-', 'P', '+', '>'		;K9 0 p ; .
	defb	137, '=', '`', '*', '?'		;K10 _ @ : /
	defb	138, '}', '^', ']', 255		;K11 { \ [ UN
	defb	139, 127,  8,  255, 255		;WRK BS LEFT |<- UN
	defb	140, 127, 11,   10,  13		;C-D DEL UP DOWN EOL
	defb	141, 142,  9,  255,  13		;CLR RCL RIGHT ->| EOL2

; Control
	defb	 27, '1',  17,   1, ' '		;K0 1 q a SP
	defb	128, '2',  23,  19,  25		;K1 2 w s y
	defb	129, '3',   5,   4,  24		;K2 3 e d x
	defb	130, '4',  18,   6,   3		;K3 4 r f c
	defb	131, '5',  20,   7,  22		;K4 5 t g v
	defb	132, '6',  26,   8,   2		;K5 6 z h b
	defb	133, '7',  21,  10,  14		;K6 7 u j n
	defb	134, '8',   9,  11,  13		;K7 8 i k m
	defb	135, '9',  15,  12, ','		;K8 9 o l ,
	defb	136, '0',  16, ';', '.'		;K9 0 p ; .
	defb	137, '_', '@', ':', '/'		;K10 _ @ : /
	defb	138, '{','\\', '[', 255		;K11 { \ [ UN
	defb	139,  12,  8,  255, 255		;WRK BS LEFT |<- UN
	defb	140, 127, 11,   10,  13		;C-D DEL UP DOWN EOL
	defb	141, 142,  9,  255,  13		;CLR RCL RIGHT ->| EOL2
