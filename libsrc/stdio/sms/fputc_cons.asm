	PUBLIC	fputc_cons
	
	INCLUDE "sms/sms.hdr"

	EXTERN	fputc_vdp_offs
	
	EXTERN	VRamToHL
	
.fputc_cons
	ld	a, (fputc_vdp_offs)
	ld	l, a
	ld	a, (fputc_vdp_offs+1)
	ld	h, a			; Loads char offset
	ld	de, NameTableAddress
	add	hl, de			; Calculates name table address
	call	VRamToHL
	
	ld      hl,2
	add     hl,sp
	ld	a,(hl)

	cp	13
	jr	nz,nocrlf

	; Line break
	ld	a, (fputc_vdp_offs)
	ld	l, a
	ld	a, (fputc_vdp_offs+1)
	ld	h, a			; Loads char offset
	ld	a, l
	and	a, $C0
	ld	l, a			; Calculates start of line
	ld	de, 64
	add	hl, de			; Calculates address of next line
	ld	a, l
	ld	(fputc_vdp_offs), a
	ld	a, h
	ld	(fputc_vdp_offs+1), a	; Saves char offset
	
	ret				; Nothing more to do

.nocrlf
	cp	12		; CLS ?
	jr	nz,nocls

	; TODO: Implement CLS

.nocls
	out	($be), a	; Outputs character
	
	ld	a, (fputc_vdp_offs)
	ld	l, a
	ld	a, (fputc_vdp_offs+1)
	ld	h, a			; Loads char offset
	inc	hl
	inc	hl			; offset += 2
	ld	a, l
	ld	(fputc_vdp_offs), a
	ld	a, h
	ld	(fputc_vdp_offs+1), a	; Saves char offset

	ret
