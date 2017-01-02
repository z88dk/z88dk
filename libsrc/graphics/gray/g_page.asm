;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;	$Id: g_page.asm,v 1.5 2017-01-02 22:57:58 aralbrec Exp $
;
; A trick to be used with the dafault graph functions
;
; Usage: g_page(int page)
;

		PUBLIC	g_page
      PUBLIC   _g_page
		
		EXTERN	graypage
		
.g_page
._g_page
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)

		jp	graypage
