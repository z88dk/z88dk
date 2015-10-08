;
;    Philips VG5000
;
;    getkey() Wait for keypress
;
;    Jun 2014 - Joaopa + Stefano Bodrato
;
;
;    $Id: fgetc_cons.asm,v 1.4 2015-10-08 17:12:22 stefano Exp $
;
    PUBLIC    fgetc_cons
	ld	ix,$47FA
.fgetc_cons
	call $aa
	and a
	jr nz,fgetc_cons

.wait_for_a_press
	call $aa
	and	a
	jr	z, wait_for_a_press	

	ld	l,a
	ld	h,0

	ret