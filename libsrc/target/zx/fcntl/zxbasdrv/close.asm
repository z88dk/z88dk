;
; Close a file by the BASIC driver
; NOTE: We don't set a drive number, here
;
; Stefano - 5/7/2006
;
; int close(int handle)
;
; $Id: close.asm $

	SECTION code_clib
	PUBLIC	close
	PUBLIC	_close
	
	EXTERN	zxhandl
	
	EXTERN	zx_setint_callee
	EXTERN asm_zx_setint
	EXTERN	zx_goto
	

.close
._close
	pop	hl
	pop	de
	push	de
	push	hl
	
	ld	a,e
	cp	3
	jr	z,islpt

	ld	hl,zxhandl
	add	hl,de
	ld	(hl),0		; free flag for handle

				; note: here we could prevent the "special"
				; stream numbers from being closed

	ld	hl,svar
	
	call	asm_zx_setint
	ld	hl,7550		; BASIC routine for "close"
.goto_basic
	call	zx_goto
	
	ld	hl,0
	
	ret


; If we had stream #3 then jump here.. it is a printer device

.islpt	ld	bc,7750		; BASIC routine for "close printer device"
	jr	goto_basic


	SECTION rodata_clib
	
; BASIC variable names for numeric values
.svar	defb 'S',0
