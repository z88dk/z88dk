; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
; One 512-byte LBA becomes two consecutive 256-byte sectors.
; floppy256_read and floppy256_write are the entries.
; A is 0 on the read entry and 1 on the write entry.
; HL is the 512-byte buffer. BCDE is the LBA, E low.
; Carry is set on success and HL is then buffer + 512.
;
; The target supplies floppy256_sector.
; A = 0 reads one 256-byte sector. A = 1 writes it.
; A = 2 asks the target to wait. A not-ready drive uses that wait.
; BCDE is the linear sector, E low. Sector 0 is the first on the disk.
; HL is the 256-byte buffer. Carry is set when the sector worked.
; The target turns the linear sector into its track, head, and sector.
; The hook may change AF, BC, DE, and HL.
;
; Four tries on each half. A sector error or a verify mismatch
; waits, then tries that half again. The wait is A = 2 with the
; same sector and the same buffer. The target write returns when
; that command has finished.
; A write is read back into floppy256_verify and compared.
; That window is BSS. A classic stack cannot hold 256 bytes here.
; 8080 opcodes only. The frame is 8 bytes and every exit pops it.
;   0 mode, 2 physical low, 4 physical high, 6 buffer
; During a try the attempts word and the half count sit above that.

	MODULE	floppy256_xfer

	SECTION	code_driver

	PUBLIC	floppy256_read
	PUBLIC	floppy256_write
	PUBLIC	floppy256_xfer

	EXTERN	floppy256_sector

	defc	F256_TRIES = 4

floppy256_read:
	xor	a
	jp	floppy256_go

floppy256_write:
	ld	a,1

floppy256_xfer:
floppy256_go:
	push	hl
	ld	l,a			; mode survives the shift in L
	call	f256_shl
	jp	c,f256_early		; physical sector does not fit
	ld	a,l
	pop	hl
	push	hl			; buffer
	push	bc			; physical high
	push	de			; physical low
	ld	c,a
	ld	b,0
	push	bc			; mode

	ld	c,2			; two halves, low byte so dec (hl) hits it
	ld	b,0
	push	bc

f256_attempts:
	ld	c,F256_TRIES
	ld	b,0

f256_try:
	push	bc
	call	f256_args
	call	floppy256_sector
	jp	nc,f256_retry
	ld	hl,4
	add	hl,sp
	ld	a,(hl)			; mode. 0 is a read.
	or	a
	jp	z,f256_half_ok

	call	f256_args		; write verify. Read the same physical sector.
	ld	hl,floppy256_verify
	xor	a
	call	floppy256_sector
	jp	nc,f256_retry
	ld	hl,10
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)			; DE = source half
	ld	hl,floppy256_verify
	ld	b,0			; 256 bytes

f256_cmp:
	ld	a,(de)
	cp	(hl)
	jp	nz,f256_retry		; verify mismatch
	inc	de
	inc	hl
	dec	b
	jp	nz,f256_cmp

f256_half_ok:
	pop	bc			; attempts
	ld	hl,0
	add	hl,sp
	dec	(hl)			; halves left
	jp	z,f256_done
	ld	hl,8
	add	hl,sp			; buffer, attempts word already popped
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	d			; next half is 256 bytes higher
	ld	(hl),d
	dec	hl
	ld	(hl),e
	ld	hl,4
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)			; BCDE = physical sector
	ld	a,e
	add	a,1
	ld	e,a
	ld	a,d
	adc	a,0
	ld	d,a
	ld	a,c
	adc	a,0
	ld	c,a
	ld	a,b
	adc	a,0
	ld	b,a
	ld	hl,4
	add	hl,sp
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	ld	(hl),c
	inc	hl
	ld	(hl),b
	jp	f256_attempts

f256_done:
	pop	bc			; halves
	ld	hl,6
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	d			; this half, so HL returns buffer + 512
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	push	de
	pop	hl
	scf
	ret

f256_retry:
	call	f256_args		; same sector and buffer
	ld	a,2			; settle. Flags from the hook are ignored.
	call	floppy256_sector
	pop	bc
	dec	c
	jp	nz,f256_try
	pop	bc			; halves

f256_drop:
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	or	a
	ret

f256_early:
	pop	hl
	or	a
	ret

; BCDE left one bit. The bit that leaves B is carry. HL stays.
f256_shl:
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

; The try frame is under the return address.
; Returns A = mode, BCDE = physical sector, HL = buffer.
f256_args:
	ld	hl,8
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	hl,12
	add	hl,sp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,8			; mode, plus the saved buffer
	add	hl,sp
	ld	a,(hl)
	pop	hl
	ret


	SECTION	bss_clib

floppy256_verify:
	defs	256
