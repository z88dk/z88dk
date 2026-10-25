;
;	Mitsubishi Multi8: save a file to the cassette
;
;	int tape_save(void *addr, size_t len) __smallc;
;
;	Writes len bytes from addr in the format the machine's own loader reads (and appmake and the bootstrap
;	write): a ':' and the address (high byte first) and its checksum, blocks of up to 255 bytes, each a ':', the
;	length, the data and a checksum that makes them add up to zero, and a block of none.  The address is only
;	what tape_load puts the data at: tape_load_to ignores it.
;
;	Returns 0.
;

	MODULE	tape_save

	SECTION	code_clib
	PUBLIC	tape_save
	PUBLIC	_tape_save
	PUBLIC	tape_save_callee
	PUBLIC	_tape_save_callee
	PUBLIC	asm_tape_save

	EXTERN	asm_tape_tx_start
	EXTERN	asm_tape_tx_byte
	EXTERN	asm_tape_tx_end

tape_save:
_tape_save:
	pop	af
	pop	bc			;len
	pop	hl			;addr
	push	hl
	push	bc
	push	af
	jr	asm_tape_save

tape_save_callee:
_tape_save_callee:
	pop	af
	pop	bc
	pop	hl
	push	af

; Entry: hl = address, bc = length
; Exit:  hl = 0, nc
asm_tape_save:
	push	hl
	push	bc
	call	asm_tape_tx_start
	pop	bc
	pop	hl
	ld	a,':'
	call	asm_tape_tx_byte
	ld	a,h
	call	asm_tape_tx_byte
	ld	a,l
	call	asm_tape_tx_byte
	ld	a,h
	add	a,l
	neg
	call	asm_tape_tx_byte
block:
	ld	a,b
	or	c
	jr	z,eof
	ld	d,255			;d = this block's length: 255, or what is left
	ld	a,b
	or	a
	jr	nz,sized
	ld	a,c
	cp	255
	jr	nc,sized
	ld	d,a
sized:
	ld	a,':'
	call	asm_tape_tx_byte
	ld	a,d
	call	asm_tape_tx_byte
	ld	e,d			;e = the sum
	ld	a,c
	sub	d
	ld	c,a
	jr	nc,bytes
	dec	b
bytes:
	ld	a,(hl)
	inc	hl
	call	asm_tape_tx_byte
	add	a,e
	ld	e,a
	dec	d
	jr	nz,bytes
	xor	a
	sub	e
	call	asm_tape_tx_byte
	jr	block
eof:
	ld	a,':'
	call	asm_tape_tx_byte
	xor	a
	call	asm_tape_tx_byte
	xor	a
	call	asm_tape_tx_byte
	call	asm_tape_tx_end
	ld	hl,0
	and	a
	ret
