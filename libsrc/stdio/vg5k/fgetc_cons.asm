;
;    Philips VG5000
;
;    getkey() Wait for keypress
;
;    Jun 2014 - Joaopa
;
;
;    $Id: fgetc_cons.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;
    PUBLIC    fgetc_cons
	ld	ix,$47FA
.fgetc_cons
;	push	bc
;	push	de
;	push	af
.wait_for_a_press
	call	12983
;	ld	(hl), a
	;jr	c, wait_for_a_press
	and	a
	jr	z, wait_for_a_press	

;	pop	af
;	pop	de
;	pop	bc

	ld	l,a
	ld	h,0

	ret