
; This table translates key presses into ascii codes.

; Write to Z80PIO port a on port $30 to specify which bit of keyboard to read,
;		-CCCRRRR
;	C = bit set for chunks (0-3 = 1 << 4, 4-7 = 2 << 4,8-11 = 4 << 4)
;	R = bit set for row wihtin chunk
; Read via Z80PIO port b on port $31

SECTION code_clib
PUBLIC in_getrow
PUBLIC in_rowtable

; Map between row number and the value needed to poke into the PIO
; Entry a = scan row
; Exit  a: high nibble = chunk, low nibble = row
in_getrow:
	push	hl
	and	15
	ld	c,a
	ld	b,0
	ld	hl,in_rowtable
	add	hl,bc
	ld	a,(hl)
	pop	hl
	ret

	SECTION	rodata_clib
in_rowtable:
	defb	@01000001
	defb	@01000010
	defb	@01000100
	defb	@01001000

	defb	@00100001
	defb	@00100010
	defb	@00100100
	defb	@00101000

	defb	@00010001
	defb	@00010010
	defb	@00010100
	defb	@00011000



SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl

	; 96 bytes per table
	; Chunk 3
	defb	'-', '5', '6', 'f', 'h', '9', ':', '}'	;- 5 6 F H 9 : }
	defb	'q', 'w', 'e', 'g', 'j', 'i', 'o', 'p'	;Q W E G J I O P
	defb	'a', 's', 'd', 'v', 'n', 'k', 'l', ';'	;A S D V N K L ;
	defb	'z', 'x', 'c', 'b', 'm', ',', '.', '/'	;Z X C B M , . / 
	;Chunk	2
	defb	255, 255, 255, 255,   8, 255, 255, ' '	;END, UNK, UNK, UNK, LEFT, UNK, SPC
	defb	128, 129, 130, 131, 132, 133, 134, 135	;F1, F2, F3, F4, F5, F6, F7, F8
	defb	'1', '0', '4', 'r', 'y', '=','\\', 255	;1 0 4 R Y = \ YEN
	defb	'2', '3', '8', 't', 'u', '7', '@', '{'	;2 3 8 T U 7 @ {
	;Chunk 1
	defb	255, 255,   6, 255, 255, 255, 255, 255	;CTRL, SHIFT, CAPS, UNK, UNK, KANA, UNK, UNK
	defb	255, 255, 255, 255, 255, 255, 255, 255	;KP0, KP1, KP2, KP3, KP4, KP5, KP6, KP7
	defb	255, 255, 255,  10,  11, 255, 255,  13	;KP8, KP8, KP-, DOWN, UP, HOME, KPDEL, KPENTER
	defb	  9, 255,  12,   7, 255, 255, 255, 255	;RIGHT, STATUS?, BACKSPACE, TAB, UNK, UNK, UNK, UNK


;Shifted
	; Chunk 3
	defb	'=', '%', '&', 'F', 'H', ')', '*', ']'	;- 5 6 F H 9 : }
	defb	'Q', 'W', 'E', 'G', 'J', 'I', 'O', 'P'	;Q W E G J I O P
	defb	'A', 'S', 'D', 'V', 'N', 'K', 'L', '+'	;A S D V N K L ;
	defb	'Z', 'X', 'C', 'B', 'M', '<', '>', '?'	;Z X C B M , . / 
	;Chunk	2
	defb	255, 255, 255, 255,   8, 255, 255, ' '	;END, UNK, UNK, UNK, LEFT, UNK, SPC
	defb	128, 129, 130, 131, 132, 133, 134, 135	;F1, F2, F3, F4, F5, F6, F7, F8
	defb	'!', '_', '$', 'R', 'Y', '-', '^', 255	;1 0 4 R Y = \ YEN
	defb   '\"', '#', '(', 'T', 'U','\'', '@', '['	;2 3 8 T U 7 @ {
	;Chunk 1
	defb	255, 255,   6, 255, 255, 255, 255, 255	;CTRL, SHIFT, CAPS, UNK, UNK, KANA, UNK, UNK
	defb	255, 255, 255, 255, 255, 255, 255, 255	;KP0, KP1, KP2, KP3, KP4, KP5, KP6, KP7
	defb	255, 255, 255,  10,  11, 255, 255,  13	;KP8, KP8, KP-, DOWN, UP, HOME, KPDEL, KPENTER
	defb	  9, 255, 127,   7, 255, 255, 255, 255	;RIGHT, STATUS?, BACKSPACE, TAB, UNK, UNK, UNK, UNK


;(control)
	; 96 bytes per table
	; Chunk 3
	defb	'-', '5', '6',   6,   8, '9', ':', '}'	;- 5 6 F H 9 : }
	defb	 17,  23,   5,   7,  10,   9,  15,  16	;Q W E G J I O P
	defb	  1,  19,   4,  22,  14,  11,  12, ';'	;A S D V N K L ;
	defb	 26,  24,   3,   2,  13, ',', '.', '/'	;Z X C B M , . / 
	;Chunk	2
	defb	255, 255, 255, 255,   8, 255, 255, ' '	;END, UNK, UNK, UNK, LEFT, UNK, SPC
	defb	128, 129, 130, 131, 132, 133, 134, 135	;F1, F2, F3, F4, F5, F6, F7, F8
	defb	'1', '0', '4',  18,  25, '=','\\', 255	;1 0 4 R Y = \ YEN
	defb	'2', '3', '8',  20,  21, '7', '@', '{'	;2 3 8 T U 7 @ {
	;Chunk 1
	defb	255, 255,   6, 255, 255, 255, 255, 255	;CTRL, SHIFT, CAPS, UNK, UNK, KANA, UNK, UNK
	defb	255, 255, 255, 255, 255, 255, 255, 255	;KP0, KP1, KP2, KP3, KP4, KP5, KP6, KP7
	defb	255, 255, 255,  10,  11, 255, 255,  13	;KP8, KP8, KP-, DOWN, UP, HOME, KPDEL, KPENTER
	defb	  9, 255,  12,   7, 255, 255, 255, 255	;RIGHT, STATUS?, BACKSPACE, TAB, UNK, UNK, UNK, UNK
