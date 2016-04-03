;
;	Keyboard routines for the NASCOM1/2
;	By Stefano Bodrato - 23/05/2003
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.4 2016-04-03 13:10:24 dom Exp $
;

		SECTION code_clib
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
