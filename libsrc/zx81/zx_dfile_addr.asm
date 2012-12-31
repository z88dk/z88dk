;
;       ZX81 libraries - Stefano
;
;----------------------------------------------------------------
; Internal use code portion to update the actual ptr to d-file
; Can't be used from the external, it expect adjusted
; values for ROW and COLUMN
;----------------------------------------------------------------
;
;  $Id: zx_dfile_addr.asm,v 1.3 2012-12-31 10:38:24 stefano Exp $
;
;----------------------------------------------------------------

	XLIB    zx_dfile_addr

IF FORzx81
	DEFC    COLUMN=$4039    ; S_POSN_x
	DEFC    ROW=$403A       ; S_POSN_y
ELSE
	DEFC   COLUMN=$4024    ; S_POSN_x
	DEFC   ROW=$4025       ; S_POSN_y
ENDIF

zx_dfile_addr:
	push	af
	ld	hl,(16396)	; D_FILE
	inc	hl
	ld	a,(ROW)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,33	; 32+1. Every text line ends with an HALT
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	ld	a,(COLUMN)
	ld	d,0
	ld	e,a
	add	hl,de
IF FORzx81
	ld ($400E),hl	; DF_CC ..current ZX81 cursor position on display file
ENDIF
	pop	af
	ret
