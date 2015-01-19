;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;	$Id: g_page.asm,v 1.4 2015-01-19 01:32:49 pauloscustodio Exp $
;
; A trick to be used with the dafault graph functions
;
; Usage: g_page(int page)
;

		PUBLIC	g_page
		
		EXTERN	graypage
		
.g_page
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)

		jp	graypage
