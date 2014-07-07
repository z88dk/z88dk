;
;    Philips VG5000
;
;    getkey() Wait for keypress
;
;    Jun 2014 - Joaopa
;
;
;    $Id: fgetc_cons.asm,v 1.1 2014-07-07 08:25:21 stefano Exp $
;
    XLIB    fgetc_cons
.fgetc_cons
;	push	bc
;	push	de
;	push	af
.wait_for_a_press
	call	12983
;	ld	(hl), a
	jr	c, wait_for_a_press
	or	a
	jr	z, wait_for_a_press	

;	pop	af
;	pop	de
;	pop	bc

	ld	l,a
	ld	h,0

	ret