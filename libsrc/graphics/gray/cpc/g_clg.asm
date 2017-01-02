;
;       Amstrad CPC pseudo-Gray Library Functions
;
;       Written by Stefano Bodrato - June 2004
;
;	$Id: g_clg.asm,v 1.3 2017-01-02 22:57:58 aralbrec Exp $
;
;


;Usage: g_clg(GrayLevel)


		PUBLIC    g_clg
      PUBLIC    _g_clg


.g_clg
._g_clg
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel

		call	$BBE4

		;jp	$BC14
		
		jp	$BBDB

