        SECTION code_clib
	PUBLIC	cleargraphics
   PUBLIC   _cleargraphics

;
;	$Id: clsgraph.asm,v 1.7 2017-01-02 22:58:00 aralbrec Exp $
;

; ******************************************************************
;
;	Clear graphics area
;

		EXTERN	filltxt

.cleargraphics
._cleargraphics
		ld	l,0
		jp	filltxt
		
		;call	restore81
		;jp	2602	


