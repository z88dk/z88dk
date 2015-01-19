;
;       Amstrad CPC pseudo-Gray Library Functions
;
;       Written by Stefano Bodrato - June 2004
;
;	$Id: g_clg.asm,v 1.2 2015-01-19 01:32:49 pauloscustodio Exp $
;
;


;Usage: g_clg(GrayLevel)


		PUBLIC    g_clg


.g_clg
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel

		call	$BBE4

		;jp	$BC14
		
		jp	$BBDB

