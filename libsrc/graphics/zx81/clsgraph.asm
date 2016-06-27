        SECTION code_clib
	PUBLIC	cleargraphics

;
;	$Id: clsgraph.asm,v 1.6 2016-06-27 20:26:32 dom Exp $
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


