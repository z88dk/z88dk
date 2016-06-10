
	SECTION code_clib
	PUBLIC	DrawOneLine
	
	INCLUDE "sms/sms.hdr"

	
	EXTERN	VRAMToHL

;==============================================================
; DrawOneLine
;==============================================================
; Draws one line on the bkg map.
; hl = Initial address of data
; de = Destination VRAM address
; c  = Number of bkg tiles to write
;==============================================================
.DrawOneLine
	push	hl
	ld	h, d
	ld	l, e
	call	VRAMToHL	; Set VRAM write address
	pop	hl
	
	push	af
.loop
	ld	a, (hl)
	out	($be), a	; Character number
	inc	hl
	ld	a, (hl)
	out	($be), a	; Attribute number
	inc	hl

	dec	c
	jp	nz, loop	; Repeat until c is zero
	pop	af
	
	ret
