;
;	Keyboard routines for the NASCOM1/2
;	By Stefano Bodrato - 23/05/2003
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.2 2014-03-05 23:01:59 pauloscustodio Exp $
;

		XLIB	fgetc_cons
		LIB	montest

.fgetc_cons

	call	montest
	jr	nz,nassys

; NASBUG 'T' monitor
.tin
	call	0c4dh
	jr	nc,tin
	
	cp	1dh
	jr	nz,notbs
	ld	a,8
.notbs
	cp	1fh
	jr	nz,notcr
	ld	a,13
.notcr
	jr	fgetcc_exit

; NASSYS monitor
.nassys
	rst	8
	
.fgetcc_exit
	ld	l,a
	ld	h,0
	ret
