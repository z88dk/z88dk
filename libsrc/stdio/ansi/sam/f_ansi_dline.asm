;
;       SAM Coupé C Library
;
; 	ANSI Video handling for SAM Coupé
;
;
; 	Clean a text line
;
;	Stefano Bodrato - Apr. 2000
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_del_line
 	EXTERN	ansi_default
	EXTERN	ansi_restore	
	
	EXTERN	ansi_ROW
	
.ansi_del_line
 	ld	(ansi_ROW),a

	call	ansi_default
	ld	b,32
.line
	ld	a,' '
	rst	16
	djnz	line

	jp	ansi_restore
	
