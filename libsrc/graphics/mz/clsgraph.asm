
        SECTION code_clib
	PUBLIC	cleargraphics
   PUBLIC   _cleargraphics

	EXTERN	base_graphics

;
;	$Id: clsgraph.asm,v 1.4 2017-01-02 22:57:58 aralbrec Exp $
;

; ******************************************************************
;
; Clear graphics area
;
; Sharp MZ version.  
; 80x50 rez.
;
.cleargraphics
._cleargraphics

	ld	hl,$D000
	ld	(hl),0 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,40*25
	ldir

	ld	hl,$D800
	ld	(hl),$70
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,40*25
	ldir

	ret
