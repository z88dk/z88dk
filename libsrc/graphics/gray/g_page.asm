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
		
                XREF    base_graphics
		XREF	graybit1
		XREF	graybit2
		
.g_page
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)
		and	a
		jr	nz,flippage
		ld	hl,(graybit1)
		ld	(base_graphics),hl
		ret
.flippage
		ld	hl,(graybit2)
		ld	(base_graphics),hl
		ret
