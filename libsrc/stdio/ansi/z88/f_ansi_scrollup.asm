;
;	f_ansi_scrollup
;
;	Scroll screen up one line
;
;	We set the window to none-scrolling..
;
;
;	$Id: f_ansi_scrollup.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_SCROLLUP

.ansi_SCROLLUP
	ld	a,1
	call_oz(os_out)
	ld	a,255
	call_oz(os_out)
	ret


