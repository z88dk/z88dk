    SECTION code_clib
	PUBLIC	cleargraphics
	PUBLIC   _cleargraphics

cleargraphics:
_cleargraphics:
	ld	a,' '
    ld	b,24*4
    ld	de,0
	jp	$bfee
