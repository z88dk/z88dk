;
;	f_ansi_scrollup
;
;	Scroll screen up one line
;
;	We set the window to none-scrolling..
;
;
;	$Id: f_ansi_scrollup.asm,v 1.3 2001-05-02 09:21:51 dom Exp $
;

	XLIB	ansi_SCROLLUP

	INCLUDE	"#stdio.def"

.ansi_SCROLLUP
	ld	a,1
	call_oz(os_out)
	ld	a,255
	call_oz(os_out)
	ret


