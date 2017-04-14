;
;       Sharp MZ C Library
;
;	Print character to the screen
;
;       We will corrupt any register
;
;
;	Sharp MZ Routines
;
;       Stefano Bodrato - 5/5/2000
;
;
;	$Id: fputc_cons.asm,v 1.4 2016-05-15 20:15:45 dom Exp $
;

   	  SECTION code_clib
          PUBLIC  fputc_cons_native

;
; Entry:        hl points char to print
;
	SECTION   bss_clib
.savesp	defw	0

	SECTION   code_clib
.fputc_cons_native

	ex	af,af'
	pop	af
	push	af

	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	
IF STANDARDESCAPECHARS
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

        push    ix
	ld	(savesp),sp

	call	$12

	ld	sp,(savesp)
        pop     ix

	ret
