; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;

	MODULE	code_clib
	PUBLIC	conio_map_colour

	EXTERN	__CLIB_CONIO_NATIVE_COLOUR

conio_map_colour:
        ld      c,__CLIB_CONIO_NATIVE_COLOUR
	dec	c
	ret	z

	and	15
	ld	c,a
	ld	b,0
	ld	hl,table
	add	hl,bc
	ld	a,(hl)
	ret

	SECTION	rodata_clib
	; The pmd85 ColorAce mod uses two attributes to specify the colour, so
	; we end up with a colour resolution of 48 x 128 rows
table:
        defb    @00000000	;BLACK -> GREEN
	defb	@00001010	;BLUE -> BLUE
	defb	@00000000	;GREEN -> GREEN
	defb	@00001000	;CYAN -> CYAN
	defb	@00000101	;RED -> RED
	defb	@00001111	;MAGENTA->MAGENTA
	defb	@00000101	;BROWN->RED
	defb	@00001100	;LIGHTGRAY->WHITE
	defb	@00001100	;DARKGRAY->WHITE
	defb	@00001010	;LIGHTBLUE -> BLUE
	defb	@00000000	;LIGHTGREEN -> GREEN
	defb	@00001000	;LIGHTCYAN -> CYAN
	defb	@00000101	;LIGHTRED -> RED
	defb	@00001111	;LIGHTMAGENTA->MAGENTA
	defb	@00000100	;YELLOW -> YELLOW
	defb	@00001100	;WHITE -> WHITE
