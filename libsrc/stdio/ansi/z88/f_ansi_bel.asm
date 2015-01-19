;
;	Bell for the ANSI terminal
;
;	djm 6/6/2000
;
;
;	$Id: f_ansi_bel.asm,v 1.4 2015-01-19 01:33:19 pauloscustodio Exp $
;


	PUBLIC	ansi_BEL

	INCLUDE	"stdio.def"


.ansi_BEL
	ld	a,7
	call_oz(os_out)
	ret

