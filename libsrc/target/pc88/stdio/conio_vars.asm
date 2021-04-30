

	SECTION	data_clib

	PUBLIC	__pc88_mode
	PUBLIC	__pc88_gfxmode
	PUBLIC	__pc88_ink
	PUBLIC	__pc88_textink
	PUBLIC	__pc88_paper
	PUBLIC	__pc88_attr

__pc88_mode:	defb	0
__pc88_gfxmode:	defb	0

__pc88_ink:	defb	7
__pc88_paper:	defb	0


; Order is important here
__pc88_textink:	defb	@11101000
__pc88_attr:	defb	0
