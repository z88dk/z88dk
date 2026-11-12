; Copyright (c) November 2026 Phillip Stevens (feilipu)
;
; Transfer one 512-byte LBA through the CP/M 2.2 BIOS.
; A = 0 reads, A = 1 writes. HL is the buffer. BCDE is the LBA, E low.
; Carry is set on success and HL is then buffer + 512.
;
; The BIOS record is 128 bytes, so the LBA is shifted left two bits.
; One restoring divide by the DPB sector-per-track word splits that
; record into a track and a sector. The next three records follow,
; wrapping to the next track when the sector hits SPT.
;
; The LBA is a physical sector. BDOS adds DPB OFF before SETTRK.
; This path calls the BIOS, so OFF is not added again.
;
; SECTRAN runs only when the DPH translation word is not zero.
; WRITE is called with C = 1. CP/M may defer a data write. C = 1
; makes the BIOS finish the sector before it returns, so a FAT
; sector and a file sector are both committed.
;
; 8080 opcodes only. The frame is 18 bytes and every exit pops it.
;   0 count, 2 track, 4 sector, 6 spt, 8 xlt,
;   10 buffer, 12 flag, 14 lba low, 16 lba high

	SECTION	code_driver

	PUBLIC	cpm_bios_xfer

	EXTERN	cpm_bios

cpm_bios_xfer:
	push	bc
	push	de
	ld	c,a
	ld	b,0
	push	bc
	push	hl
	ld	hl,0
	push	hl
	push	hl
	push	hl
	push	hl
	push	hl

	ld	c,0
	ld	e,1			; already logged in
	ld	a,24			; SELDSK
	call	cpm_bios
	ld	a,h
	or	l
	jp	Z,xfer_fail

	ld	e,(hl)
	inc	hl
	ld	d,(hl)			; DE = XLT
	push	hl
	ld	hl,10			; xlt slot, plus the saved DPH+1
	add	hl,sp
	ld	(hl),e
	inc	hl
	ld	(hl),d
	pop	hl
	ld	bc,9			; DPH+1 + 9 = DPB address
	add	hl,bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ex	de,hl			; HL = DPB
	ld	e,(hl)
	inc	hl
	ld	d,(hl)			; DE = SPT
	ld	a,d
	or	e
	jp	Z,xfer_fail
	ld	hl,6
	add	hl,sp
	ld	(hl),e
	inc	hl
	ld	(hl),d

	ld	hl,14
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)			; BCDE = LBA
	call	xfer_shl32
	jp	C,xfer_fail		; record does not fit in 32 bits
	call	xfer_shl32
	jp	C,xfer_fail
	ld	hl,14
	add	hl,sp
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	ld	(hl),c
	inc	hl
	ld	(hl),b

	ld	hl,6
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)			; DE = SPT
	push	de
	ld	hl,16			; lba low, plus the saved SPT
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)			; BCDE = record
	pop	hl			; HL = SPT
	call	cpm_div32
	ld	a,b
	or	c
	jp	NZ,xfer_fail		; track does not fit in SETTRK
	push	hl			; remainder is the sector
	ld	hl,4			; track slot, plus the saved sector
	add	hl,sp
	ld	(hl),e
	inc	hl
	ld	(hl),d
	pop	de
	ld	hl,4
	add	hl,sp
	ld	(hl),e
	inc	hl
	ld	(hl),d
	ld	hl,0
	add	hl,sp
	ld	(hl),4

xfer_loop:
	ld	hl,8
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	a,d
	or	e
	jp	Z,xfer_noskew
	push	de
	ld	hl,6			; sector slot, plus the saved XLT
	add	hl,sp
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	pop	de
	ld	a,45			; SECTRAN
	call	cpm_bios
	ld	b,h
	ld	c,l
	jp	xfer_setsec

xfer_noskew:
	ld	hl,4
	add	hl,sp
	ld	c,(hl)
	inc	hl
	ld	b,(hl)

xfer_setsec:
	push	bc			; physical sector
	ld	hl,4			; track slot, plus the saved sector
	add	hl,sp
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	a,27			; SETTRK
	call	cpm_bios
	pop	bc
	ld	a,30			; SETSEC
	call	cpm_bios
	ld	hl,10
	add	hl,sp
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	a,33			; SETDMA
	call	cpm_bios
	ld	hl,12
	add	hl,sp
	ld	a,(hl)
	or	a
	jp	Z,xfer_read
	ld	c,1			; finish this sector before returning
	ld	a,39			; WRITE
	call	cpm_bios
	jp	xfer_io

xfer_read:
	ld	a,36			; READ
	call	cpm_bios

xfer_io:
	or	a
	jp	NZ,xfer_fail
	ld	hl,10
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	a,e
	add	a,128
	ld	e,a
	ld	a,d
	adc	a,0
	ld	d,a
	ld	(hl),d
	dec	hl
	ld	(hl),e
	ld	hl,0
	add	hl,sp
	dec	(hl)
	jp	Z,xfer_done		; last record needs no following sector

	ld	hl,4
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	de
	ld	hl,6
	add	hl,sp
	ld	c,(hl)
	inc	hl
	ld	b,(hl)			; BC = SPT
	ld	a,e
	cp	c
	jp	NZ,xfer_store
	ld	a,d
	cp	b
	jp	NZ,xfer_store
	ld	de,0
	ld	hl,2
	add	hl,sp
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	bc
	ld	a,b
	or	c
	jp	Z,xfer_fail		; next record would pass track 65535
	ld	(hl),b
	dec	hl
	ld	(hl),c

xfer_store:
	ld	hl,4
	add	hl,sp
	ld	(hl),e
	inc	hl
	ld	(hl),d
	jp	xfer_loop

xfer_done:
	ld	hl,10
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	hl,18
	add	hl,sp
	ld	sp,hl
	ex	de,hl
	scf
	ret

xfer_fail:
	ld	hl,18
	add	hl,sp
	ld	sp,hl
	or	a
	ret

; BCDE left one bit. The bit that leaves B is carry.
xfer_shl32:
	ld	a,e
	add	a,a
	ld	e,a
	ld	a,d
	rla
	ld	d,a
	ld	a,c
	rla
	ld	c,a
	ld	a,b
	rla
	ld	b,a
	ret

; BCDE / HL. HL is not zero. 32 restoring steps.
; BCDE returns the quotient, E low. HL returns the remainder.
; A shift out of the remainder is 65536 + HL. The remainder was
; smaller than HL on the previous step, so one 16-bit subtract
; borrows and is the true remainder. No carry is added in.
cpm_div32:
	push	hl
	ld	hl,32
	push	hl
	ld	hl,0

div_lp:
	ld	a,e
	add	a,a
	ld	e,a
	ld	a,d
	rla
	ld	d,a
	ld	a,c
	rla
	ld	c,a
	ld	a,b
	rla
	ld	b,a
	ld	a,l
	rla
	ld	l,a
	ld	a,h
	rla
	ld	h,a
	push	bc
	push	de
	jp	C,div_ov
	ld	d,h
	ld	e,l
	ld	hl,6			; divisor, under qlo and qhi
	add	hl,sp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	a,d
	cp	h
	jp	C,div_lt
	jp	NZ,div_ge
	ld	a,e
	cp	l
	jp	C,div_lt

div_ge:
	ld	a,e
	sub	l
	ld	e,a
	ld	a,d
	sbc	a,h
	ld	d,a
	jp	div_bit

div_ov:
	ld	d,h
	ld	e,l
	ld	hl,6
	add	hl,sp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	a,e
	sub	l
	ld	e,a
	ld	a,d
	sbc	a,h
	ld	d,a

div_bit:
	pop	hl
	ld	a,l
	or	1
	ld	l,a
	ex	de,hl
	pop	bc
	jp	div_next

div_lt:
	ex	de,hl
	pop	de
	pop	bc

div_next:
	push	hl
	ld	hl,2
	add	hl,sp
	dec	(hl)
	pop	hl
	jp	NZ,div_lp
	pop	af
	pop	af
	ret
