;
;	Keyboard routines for the NASCOM1/2
;	By Stefano Bodrato - 23/05/2003
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.3 2015-01-19 01:33:20 pauloscustodio Exp $
;

		PUBLIC	getk
		EXTERN	montest

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
