;
;       SAM Coupé C Library
;
;	Print character to the screen
;
;       We will corrupt any register
;
;
;	Frode Tennebø - 29/12/2002
;
;	$Id: fputc_cons.asm,v 1.5 2016-05-15 20:15:46 dom Exp $
;

	  SECTION code_clib
          PUBLIC  fputc_cons_native

;
; Entry:        char to print on stack
;

.fputc_cons_native
        ld      hl,2
        add     hl,sp
	ld	b,(hl)
	ld	hl,skip_count
	ld	a,(hl)
	and	a
	ld	a,b
	jr	z,continue
	dec	(hl)
	jr	direct
continue:
	cp	22		;move to
	jr	nz,not_posn
	ld	(hl),2
not_posn:
	cp	10
	jr	nz,not_lf
	ld	a,13
not_lf:
	cp	12	; CLS ?
	jr	nz,direct
	xor	a
	call	$014E
	ld	a,0xfe	;screen
	jp	$0112
direct:
	rst	16
	ld	a,255
	ld	(0x5C8C),a
	ret

	SECTION	bss_clib

skip_count:	defb	0
