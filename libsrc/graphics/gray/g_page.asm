;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;	$Id: g_page.asm,v 1.3 2001-04-18 13:21:38 stefano Exp $
;
; A trick to be used with the dafault graph functions
;
; Usage: g_page(int page)
;

		XLIB	g_page
		
		LIB	graypage
		
.g_page
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)

		jp	graypage
