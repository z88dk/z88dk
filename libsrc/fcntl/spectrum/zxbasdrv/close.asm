;
; Close a file by the BASIC driver
; NOTE: We don't set a drive number, here
;
; Stefano - 5/7/2006
;
; int close(int handle)
;
; $Id: close.asm,v 1.1 2006-07-18 21:02:54 stefano Exp $

	XLIB	close
	
	LIB	zxhandl
	
	LIB	zx_setint
	LIB	zx_goto
	
; BASIC variable names for numeric values
.svar	defb 'S',0

.close
	pop	hl
	pop	bc
	push	bc
	push	hl
	
	ld	a,c
	cp	3
	jr	z,islpt

	ld	hl,svar
	push	hl		; BASIC variable S
	push	bc		; file handle (stream #)
	call	zx_setint
	pop	de
	pop	hl
	ld	hl,zxhandl
	xor	a
	add	hl,de
	ld	(hl),a		; free flag for handle

				; note: here we could prevent the "special"
				; stream numbers from being closed

	ld	bc,7550		; BASIC routine for "close"
	push	bc
	call	zx_goto
	pop	bc
	
	ld	hl,0
	
	ret


; If we had stream #3 then jump here.. it is a printer device

.islpt	ld	bc,7750		; BASIC routine for "close printer device"
	push	bc
	call	zx_goto
	pop	bc
	ret
