;
; Open a file by the BASIC driver
;
; Stefano - 5/7/2006
;
; int open(char *name, int flags, mode_t mode)
;
; $Id: open.asm $

	SECTION code_clib
	PUBLIC	open
	PUBLIC	_open
	PUBLIC	___open
	
	EXTERN	zxhandl
	
	EXTERN	zx_setint_callee
	EXTERN asm_zx_setint
	EXTERN	zx_goto
	EXTERN	zxgetfname



.open
._open
.___open
	ld	hl,2
	add	hl,sp

	inc hl
	inc hl

	push	hl
	
	ld	e,(hl)		; mode flag
	inc	hl
	ld	d,(hl)
	
	ld	hl,fvar		; BASIC variable F
	call	asm_zx_setint
	
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
	ld	(hl),a		; set handle as busy
	
	ld	e,b
	ld	d,0
	push de		; save file handle

	ld	hl,svar		; BASIC variable S
	call	asm_zx_setint

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

	ld	de,zxhandl
	add	hl,de
	ld	(hl),0		; free flag for handle
	ld	hl,-1		; stream isn't open: file not found !
	ret

; Drive "P::" is a unix style device for printer
; We call BASIC to init the #3 stream

.islpt
	ld	hl,7700		; BASIC routine for "init printer device"
	call	zx_goto
	ld	hl,3		; force stream #3 as file handle
	ret


	SECTION rodata_clib
	
; BASIC variable names for numeric values
.fvar	defb 'F',0
.svar	defb 'S',0
