
	PUBLIC	clg

;
;	$Id: clg.asm,v 1.4 2015-01-19 01:32:52 pauloscustodio Exp $
;

; ******************************************************************
;
;	Clear graphics area, 
;

		EXTERN	filltxt

.clg
		ld	l,0
		jp	filltxt
		
		;call	restore81
		;jp	2602	
