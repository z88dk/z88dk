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
;	UncleBod - 2018-09-25
;	Added handling of DEL key
;
;	TODO
;	Conversion of mzASCII to real ASCII, especially codes 0-127
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
	cp  12
	jr  nz,nocls
	ld	a,$16
.nocls

IF STANDARDESCAPECHARS
	cp  10
	jr  nz,notCR
	ld	a,13
.notCR
ENDIF

; Handling of DEL-key
	cp	8
	jr	nz,notback
	ld	a,$14 ; move left on MZ700
.notback

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
