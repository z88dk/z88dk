
	PUBLIC	cleargraphics

;
;	$Id: clsgraph.asm,v 1.5 2015-01-19 01:32:52 pauloscustodio Exp $
;

; ******************************************************************
;
;	Clear graphics area
;

		EXTERN	filltxt

.cleargraphics
		ld	l,0
		jp	filltxt
		
		;call	restore81
		;jp	2602	


