
	XLIB	cleargraphics

;
;	$Id: clsgraph.asm,v 1.4 2009-08-20 05:59:11 stefano Exp $
;

; ******************************************************************
;
;	Clear graphics area
;

		LIB	filltxt

.cleargraphics
		ld	l,0
		jp	filltxt
		
		;call	restore81
		;jp	2602	


