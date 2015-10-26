;
;       TRS 80 C Library
;
;	Print character to the screen
;
;       Stefano Bodrato - Apr.2008
;
;
;	$Id: fputc_cons.asm,v 1.3 2015-10-26 18:34:51 stefano Exp $
;


          PUBLIC  fputc_cons


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
;	cp	12
;	jr	nz,nocls
;
;.nocls

	; Some undercase text?  Transform in UPPER !
	cp	97
	jr	c,nounder
	sub	32
	jr	setout
.nounder
	; Some more char remapping can stay here...
.setout
        call    $33
	ret

