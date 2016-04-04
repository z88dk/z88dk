;
;	Bell for the ANSI terminal
;
;	djm 6/6/2000
;
;
;	$Id: f_ansi_bel.asm,v 1.5 2016-04-04 18:31:23 dom Exp $
;


	SECTION	code_clib
	PUBLIC	ansi_BEL

	INCLUDE	"stdio.def"


.ansi_BEL
	ld	a,7
	call_oz(os_out)
	ret

