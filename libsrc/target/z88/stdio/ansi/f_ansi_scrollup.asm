;
;	f_ansi_scrollup
;
;	Scroll screen up one line
;
;	We set the window to none-scrolling..
;
;
;	$Id: f_ansi_scrollup.asm,v 1.6 2016-04-04 18:31:23 dom Exp $
;

	SECTION	code_clib
	PUBLIC	ansi_SCROLLUP

	INCLUDE	"stdio.def"

.ansi_SCROLLUP
	ld	a,1
	call_oz(os_out)
	ld	a,255
	call_oz(os_out)
	ret


