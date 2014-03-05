;
;	Keyboard routines for the NASCOM1/2
;	By Stefano Bodrato - 23/05/2003
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.2 2014-03-05 23:01:59 pauloscustodio Exp $
;

		XLIB	getk
		LIB	montest

.getk
	call	montest
	jr	nz,nassys

; T monitor
	call	0c4dh
	jr	gkret

; NASSYS monitor
.nassys
	defw	62dfh
	
.gkret
	ld	l,a
	ld	h,0
	ret
