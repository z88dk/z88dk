;
; Read a byte by the BASIC driver
; It is based on the INPUT-AD ROM routines, designed to get a char
; from the current stream.  We trap errors too, because it happens
; that the shadow roms prefer to stop directly when an EOF is reached.
;
; Stefano - 5/7/2006
;
; int __LIB__ __FASTCALL__ readbyte(int handle)
;
; $Id: readbyte.asm,v 1.5 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	readbyte
	PUBLIC	_readbyte
	
.readbyte
._readbyte
	ld	a,l
	call	$1601


	ld	bc,($5c3d)
	push	bc		; save original ERR_SP
	ld	bc,error
	push	bc
	ld	($5c3d),sp	; update error handling routine


.again
	call	$15e6		; INPUT-AD
	ccf			; we adapt the carry condition to the Z88DK requirements
	ld	h,0
	ld	l,a
	jr	nc,gotchar
	jr	z,again		; No new char present.. try again

	; We'll fall here rarely, I think
	ld	hl,-1	; EOF

.gotchar
	pop	bc
	pop	bc
	ld	($5c3d),bc	; restore orginal ERR_SP
	ret	

; Errors ?    Probably it's an EOF !
.error
	pop	bc
	ld	($5c3d),bc	; restore orginal ERR_SP
	ld	(iy+0),255	; reset ERR_NR
	ld	(iy+124),0	; clear FLAGS3
	scf
	ccf
	ld	hl,-1	; EOF
	ret
