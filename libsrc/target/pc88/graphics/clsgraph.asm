
	SECTION	code_clib
	PUBLIC	cleargraphics
	PUBLIC   _cleargraphics
	EXTERN	__pc88_clear_hires
	EXTERN	__pc88_clear_text
	EXTERN	__pc88_gfxmode

	EXTERN	generic_console_cls

cleargraphics:
_cleargraphics:
	ld	a,(__pc88_gfxmode)
	and	a
	jp	z,__pc88_clear_hires
	jp	__pc88_clear_text
