;
;       Amstrad CPC pseudo-Gray Library Functions
;
;       Written by Stefano Bodrato - June 2004
;
;	$Id: g_clg.asm,v 1.1 2004-06-30 12:50:57 stefano Exp $
;
;


;Usage: g_clg(GrayLevel)


		XLIB    g_clg


.g_clg
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel

		call	$BBE4

		;jp	$BC14
		
		jp	$BBDB

