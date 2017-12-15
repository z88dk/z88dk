;
;	Keyboard routines for the NASCOM1/2
;	By Stefano Bodrato - 23/05/2003
;
;	getk() Read key status
;
;
;	$Id: getk.asm $
;

		SECTION code_clib
		PUBLIC	getk
		EXTERN	montest

.getk
	call	montest
	jr	nz,nassys

; T monitor
	;call	0c4dh
	call $69
	defb 33 ; ld hl,NN to skip the next 2 bytes

; NASSYS monitor
.nassys
	;defw	62dfh
	rst $18
	defb $62		;  an INKEY$ example suggests $61
.gkret
	jr c,gkdone
	xor a
.gkdone
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	ret
