;
; Open a file by the BASIC driver
;
; Stefano - 5/7/2006
;
; int open(char *name, int flags, mode_t mode)
;
; $Id: open.asm,v 1.7 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	open
	PUBLIC	_open
	
	EXTERN	zxhandl
	
	EXTERN	zx_setint
	EXTERN	zx_goto
	EXTERN	zxgetfname



.open
._open
	ld	hl,2
	add	hl,sp

	inc hl
	inc hl

	push	hl
	ld	de,fvar		; BASIC variable F
	push	de
	ld	b,(hl)		; mode flag
	inc	hl
	ld	c,(hl)
	push	bc
	call	zx_setint
	pop	bc
	pop	bc
	pop	hl

	inc hl
	inc hl
	
	call	zxgetfname	; HL is pointing to file name

	cp	16		; drive "P:" ?
	jr	z,islpt		; if so, it is a printer !

	ld	b,0
	ld	hl,zxhandl
.hloop
	ld	a,(hl)
	cp	255
	jr	nz,notlast
	ld	hl,-1		; error, no more free handles
	ret
.notlast
	and	a
	jr	z,hfound
	inc	hl
	inc	b
	jr	hloop
.hfound
	inc	a
	ld	(hl),a
	ld	c,b
	ld	b,0

	ld	hl,svar		; BASIC variable S
	push	hl
	push	bc		; file handle
	call	zx_setint
	pop	bc
	pop	hl

	push	bc		; save file handle
				; BASIC routine for "open"
	ld	hl,7500		; now it is __FASTCALL__
	call	zx_goto
	pop	hl		; file handle

	push	hl
	ld	a,l
	add	a,a
	add	a,$16
	ld	l,a
	ld	h,$5c
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	a,d
	or	e
	pop	hl		; file handle
	ret	nz

	ld	hl,-1		; stream isn't open: file not found !
	ret

; Drive "P::" is a unix style device for printer
; We call BASIC to init the #3 stream

.islpt
	ld	hl,7700		; BASIC routine for "init printer device"
	call	zx_goto
	ld	hl,3		; force stream #3 as file handle
	ret

; BASIC variable names for numeric values
	SECTION rodata_clib
.fvar	defb 'F',0
.svar	defb 'S',0
