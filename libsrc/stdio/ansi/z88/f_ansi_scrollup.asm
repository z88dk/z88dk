;
;	f_ansi_scrollup
;
;	Scroll screen up one line
;
;	We set the window to none-scrolling..
;
;
;	$Id: f_ansi_scrollup.asm,v 1.4 2009-06-22 21:44:17 dom Exp $
;

	XLIB	ansi_SCROLLUP

	INCLUDE	"stdio.def"

.ansi_SCROLLUP
	ld	a,1
	call_oz(os_out)
	ld	a,255
	call_oz(os_out)
	ret


