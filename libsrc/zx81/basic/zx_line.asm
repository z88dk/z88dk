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
;	$Id: zx_line.asm,v 1.4 2016-06-26 20:32:08 dom Exp $
;

SECTION code_clib
PUBLIC	zx_line
PUBLIC	_zx_line
EXTERN	restore81

; enter : hl = line number

zx_line:
_zx_line:
IF FORlambda
        call    $0B36           ; routine LINE-ADDR (LAMBDA)
ELSE
        call    $09D8           ; routine LINE-ADDR (ZX81)
ENDIF

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
IF FORlambda
        jp	$088
ELSE
        jp	$cc1	; single line
ENDIF

return:
IF FORlambda
	ld	h,0
	ld	a,($4007)
	ld	l,a		; error code (hope so !)
	ld	a,255
	ld	($4007),a	; reset ERR_NR

	inc	l		; return with error code (0=OK, etc..)
ELSE
	ld	h,0
	ld	a,($4000)
	ld	l,a		; error code (hope so !)
	ld	a,255
	ld	($4000),a	; reset ERR_NR

	inc	l		; return with error code (0=OK, etc..)
ENDIF

exitgoto:
	pop	bc
	ld	($4002),bc	; restore orginal ERR_SP
	ret
