;
;	f_ansi_scrollup
;
;	Scroll screen up one line
;
;	We set the window to none-scrolling..
;

	XLIB	ansi_SCROLLUP

.ansi_SCROLLUP
	ld	a,1
	call_oz(os_out)
	ld	a,255
	call_oz(os_out)
	ret


