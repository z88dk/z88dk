;
;       TRS 80 C Library
;
;	Print character to the screen
;
;       Stefano Bodrato - Apr.2008
;
;
;	$Id: fputc_cons.asm,v 1.4 2016-05-15 20:15:46 dom Exp $
;

	  SECTION code_clib
          PUBLIC  fputc_cons_native


.fputc_cons_native
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

