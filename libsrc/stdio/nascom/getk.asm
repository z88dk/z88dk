;
;	Keyboard routines for the NASCOM1/2
;	By Stefano Bodrato - 23/05/2003
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.1 2003-06-27 14:04:13 stefano Exp $
;

		XLIB	getk
		LIB	montest

.getk
	call	montest
	jr	nz,nassys

; T monitor
	call	c4dh
	jr	gkret

; NASSYS monitor
.nassys
	defw	62dfh
	
.gkret
	ld	l,a
	ld	h,0
	ret
