;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
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
