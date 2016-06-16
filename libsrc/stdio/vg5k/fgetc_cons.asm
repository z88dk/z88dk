;
;    Philips VG5000
;
;    getkey() Wait for keypress
;
;    Jun 2014 - Joaopa + Stefano Bodrato
;
;
;    $Id: fgetc_cons.asm,v 1.5 2016-06-16 19:40:21 dom Exp $
;

        SECTION code_clib
	PUBLIC    fgetc_cons
	PUBLIC    _fgetc_cons

.fgetc_cons
._fgetc_cons
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
