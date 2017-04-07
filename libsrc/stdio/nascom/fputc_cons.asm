;
;	ROM Console routine for the NASCOM1/2
;	By Stefano Bodrato - 19/6/2003
;
;	$Id: fputc_cons.asm,v 1.5 2016-05-15 20:15:45 dom Exp $
;

	SECTION	code_clib
	PUBLIC	fputc_cons_native
	EXTERN	montest

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	push	af
	call	montest
	jr	nz,nassys
	
; T monitor
	pop	af
	cp	12
	jr	nz,notcls
	ld	a,1eh
.notcls
IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,notcr
	ld	a,1fh
.notcr
	jp	0c4ah

.nassys
; NASSYS monitor
	pop	af
IF STANDARDESCAPECHARS
	cp	10
	jr	nz,prt_nassys
	ld	a,13
ENDIF
.prt_nassys
	defb	0f7h
	ret
