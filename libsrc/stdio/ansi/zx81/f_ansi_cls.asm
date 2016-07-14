;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Sept 2007
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.7 2016-07-14 17:44:18 pauloscustodio Exp $
;

        SECTION code_clib
	PUBLIC	ansi_cls
	EXTERN	_clg_hr		; we use the graphics CLS routine
IF MTHRG
	EXTERN	text_rows
	EXTERN	MTCH_P2
ENDIF

.ansi_cls
	call	_clg_hr
IF MTHRG
	ld	a,(MTCH_P2+2)
	srl a
	srl a
	srl a
	ld	(text_rows),a
ENDIF

	ret
