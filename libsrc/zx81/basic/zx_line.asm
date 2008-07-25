;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	int __FASTCALL__ zx_line(int line);
;
;	Execute a single BASIC program line.
;	Returns with BASIC error code.
;	0=OK,... -1=no program lines found
;
;	$Id: zx_line.asm,v 1.1 2008-07-25 15:31:25 stefano Exp $
;

XLIB	zx_line
XREF	restore81

; enter : hl = line number

zx_line:
        call    $09D8           ; routine LINE-ADDR

	cp	118
	jr	nz,havelines
	ld	hl,-1		; no program lines to point to !
	ret

havelines:
        inc	hl
        inc	hl
        inc	hl
        inc	hl
	ld	($4016),hl	; CH_ADD

	call	restore81

	ld	bc,($4002)
	push	bc		; save original ERR_SP
	ld	bc,return
	push	bc
	ld	($4002),sp	; update error handling routine
        
        jp	$cc1	; single line


return:
	ld	h,0
	ld	a,($4000)
	ld	l,a		; error code (hope so !)
	ld	a,255
	ld	($4000),a	; reset ERR_NR

	inc	l		; return with error code (0=OK, etc..)

exitgoto:
	pop	bc
	ld	($4002),bc	; restore orginal ERR_SP
	ret
