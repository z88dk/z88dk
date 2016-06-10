	SECTION code_clib
	PUBLIC	gotoxy
	PUBLIC	_gotoxy
	
	INCLUDE "sms/sms.hdr"

	EXTERN	fputc_vdp_offs
	
;==============================================================
; void gotoxy(int x, int y)
;==============================================================
; Places the software text cursor in the specified coordinates.
; Supposed to be used in conjunction with stdio
;==============================================================
.gotoxy
._gotoxy
	ld	hl, 2
	add	hl, sp
	ld	d, (hl)		; Y
	inc	hl
	inc 	hl
	ld	e, (hl)		; X

	ld	l, d
	ld	h, 0
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl		; HL = Y*32
	ld	d, 0
	add	hl, de		; HL = (Y*32) + X
	add	hl, hl		; HL = ((Y*32) + X) * 2

	ld	a, l
	ld	(fputc_vdp_offs), a
	ld	a, h
	ld	(fputc_vdp_offs+1), a	; Saves char offset

	ret
