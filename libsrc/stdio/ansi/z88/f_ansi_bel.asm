;
;	Bell for the ANSI terminal
;
;	djm 6/6/2000


	XLIB	ansi_BEL

	INCLUDE	"#stdio.def"


.ansi_BEL
	ld	a,7
	call_oz(os_out)
	ret

