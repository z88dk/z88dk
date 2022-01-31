
	SECTION code_clib
	PUBLIC	DrawOneLine
	
	INCLUDE "target/sms/sms.hdr"

	include	"macros.inc"

;==============================================================
; DrawOneLine
;==============================================================
; Draws one line on the bkg map.
; hl = Initial address of data
; de = Destination VRAM address
; c  = Number of bkg tiles to write
;==============================================================
.DrawOneLine
	setVRAM	e, d	; Set VRAM write address
	push	af
.loop
	ld	a, (hl)
	out	($be), a	; Character number
	inc	hl		;6
	ld	a, (hl)		;7
	nop			;4
	nop			;4
	nop			;4
	nop			;4
	out	($be), a	; Attribute number
	inc	hl

	dec	c
	jp	nz, loop	; Repeat until c is zero
	pop	af
	
	ret
