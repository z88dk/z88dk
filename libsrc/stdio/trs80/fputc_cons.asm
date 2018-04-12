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
;	Prints at cooards from 4020-4021

	  SECTION code_clib
          PUBLIC  fputc_cons_native


.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	12
	jr	z,cls
IF STANDARDESCAPECHARS
	cp  13
	ret z
	cp  10
	jr  nz,notCR
	ld	a,13
.notCR
ENDIF

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

.cls
	call	$1c9		;CLS	
	ret
