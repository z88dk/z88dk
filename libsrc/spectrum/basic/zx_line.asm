;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 2018
;
;	int __FASTCALL__ zx_line(int line);
;
;	Execute a single BASIC program line.
;	Returns with BASIC error code.
;	0=OK,... -1=no program lines found
;
;	$Id: zx_line.asm $
;

SECTION code_clib
PUBLIC	zx_line
PUBLIC	_zx_line

; ROM interposer does not work here
;EXTERN	call_rom3

; enter : hl = line number

zx_line:
_zx_line:
	;call	call_rom3
IF FORts2068
	call	$16D6		; LINE-ADDR
ELSE
	call	$196E		; routine LINE-ADDR 
ENDIF
	jr z,havelines				; exit if not exact line
	ld	hl,-1
	ret

;	cp	13
;	jr	nz,havelines
;	ld	hl,-1		; no program lines to point to !
;	ret

havelines:
        inc	hl
        inc	hl
        inc	hl
        inc	hl
	ld	($5C5D),hl	; CH_ADD


	ld	bc,($5C3D)
	push	bc		; save original ERR_SP
	ld	bc,return
	push	bc
	ld	($5C3D),sp	; update error handling routine
	
	;call	call_rom3	
IF FORts2068
	jp	$1A2E		; LINE-SCAN + 7
ELSE
	jp	$1B1E		; LINE-SCAN + 7
ENDIF

return:
	ld	h,0
	ld	a,($5C3A)
	ld	l,a		; error code (hope so !)
	ld	a,255
	ld	($5C3A),a	; reset ERR_NR

	inc	l		; return with error code (0=OK, etc..)

exitgoto:
	pop	bc
	ld	($5C3D),bc	; restore orginal ERR_SP
	ret
