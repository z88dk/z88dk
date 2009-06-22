;
;	Bell for the ANSI terminal
;
;	djm 6/6/2000
;
;
;	$Id: f_ansi_bel.asm,v 1.3 2009-06-22 21:44:17 dom Exp $
;


	XLIB	ansi_BEL

	INCLUDE	"stdio.def"


.ansi_BEL
	ld	a,7
	call_oz(os_out)
	ret

