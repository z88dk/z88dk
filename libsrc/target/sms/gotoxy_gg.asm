	SECTION code_clib
	PUBLIC	gotoxy_sms
	PUBLIC	_gotoxy_sms
	
	INCLUDE "target/sms/sms.hdr"

	EXTERN	fputc_vdp_offs
	
;==============================================================
; void gotoxy(int x, int y)
;==============================================================
; Places the software text cursor in the specified coordinates.
; Supposed to be used in conjunction with stdio
;==============================================================
.gotoxy_sms
._gotoxy_sms
	ld	hl, 2
	add	hl, sp
IF FORgamegear
	ld	a,3
	add	(hl)
	ld	d,a
ELSE
	ld	d, (hl)		; Y
ENDIF
	inc	hl
	inc 	hl
IF FORgamegear
	ld	a,6
	add	(hl)
	ld	e,a
ELSE
	ld	e, (hl)		; X
ENDIF

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
