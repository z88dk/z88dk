;
;       Galaksija C Library
;
;	Print character to the screen
;
;       Stefano Bodrato - Apr.2008
;
;
;	$Id: fputc_cons.asm,v 1.3 2016-05-15 20:15:45 dom Exp $
;

	  SECTION code_clib
          PUBLIC  fputc_cons_native


.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	; Some undercase text? Transform to UPPER because Galaksija doesn't
	; have lower case characters.
	cp	97
	jr	c,nounder
	sub	32
	jr	setout
.nounder
	; Galaksija's ROM uses some non-standard codes for special functions
	; https://www.tablix.org/~avian/galaksija/rom/rom1.html#l0a04h
IF STANDARDESCAPECHARS
	; ASCII backspace
	cp	8
	jr	nz,nobs
	ld	a,29
	jr	setout
.nobs
	; ASCII line feed
	cp	10
	jr	nz,setout
	ld	a,13
ENDIF
.setout
        rst	20h
	ret

