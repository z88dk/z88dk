;
;	Bell for the ANSI terminal
;
;	djm 6/6/2000
;
;
;	$Id: f_ansi_bel.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;


	XLIB	ansi_BEL

	INCLUDE	"#stdio.def"


.ansi_BEL
	ld	a,7
	call_oz(os_out)
	ret

