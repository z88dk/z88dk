	SECTION code_clib
	PUBLIC	clg
	PUBLIC	_clg

;
;	$Id: clg.asm,v 1.5 2016-06-27 20:26:32 dom Exp $
;

; ******************************************************************
;
;	Clear graphics area, 
;

		EXTERN	filltxt

.clg
._clg
		ld	l,0
		jp	filltxt
		
		;call	restore81
		;jp	2602	
