;
;	Mitsubishi Multi8: load a file from the cassette into a buffer
;
;	int tape_load_to(void *buf, size_t len) __smallc;
;
;	Reads the next file (see tape_save) and stores its data at buf, whatever address the file says (tape_load
;	puts it where the file says).  A file longer than len is read to its end and the rest dropped.  It waits
;	for a file; ESC gives up.
;
;	Returns the number of bytes stored, or -1 if the tape could not be read (an error, or ESC).
;

	MODULE	tape_load_to

	SECTION	code_clib
	PUBLIC	tape_load_to
	PUBLIC	_tape_load_to
	PUBLIC	tape_load_to_callee
	PUBLIC	_tape_load_to_callee
	PUBLIC	asm_tape_load_to

	EXTERN	asm_tape_rx_init
	EXTERN	asm_tape_rx_byte

tape_load_to:
_tape_load_to:
	pop	af
	pop	bc			;len
	pop	hl			;buf
	push	hl
	push	bc
	push	af
	jr	asm_tape_load_to_c

tape_load_to_callee:
_tape_load_to_callee:
	pop	af
	pop	bc
	pop	hl
	push	af
asm_tape_load_to_c:
	call	asm_tape_load_to
	ret	nc
	ld	hl,-1
	ret

; Entry: hl = buffer, bc = its size
; Exit:  nc: hl = the number of bytes stored
;         c: an error
asm_tape_load_to:
	push	hl			;where the data starts
retry:
	call	asm_tape_rx_init
sync:
	call	asm_tape_rx_byte	;look for the ':' that starts the file
	jr	c,sync_error
	cp	':'
	jr	nz,sync
	call	asm_tape_rx_byte	;its address and checksum, which are not wanted but must add up
	jr	c,fail
	ld	d,a
	call	asm_tape_rx_byte
	jr	c,fail
	add	a,d
	ld	d,a
	call	asm_tape_rx_byte
	jr	c,fail
	add	a,d
	jr	nz,fail
block:
	call	asm_tape_rx_byte
	jr	c,fail
	cp	':'
	jr	nz,fail
	call	asm_tape_rx_byte
	jr	c,fail
	ld	d,a			;d = the block's length
	ld	e,a			;e = the sum
	or	a
	jr	z,done			;a block of none ends the file
bytes:
	call	asm_tape_rx_byte
	jr	c,fail
	push	af
	add	a,e
	ld	e,a
	ld	a,b
	or	c
	jr	z,drop			;the buffer is full: the rest is read and dropped
	pop	af
	ld	(hl),a
	inc	hl
	dec	bc
	jr	next
drop:
	pop	af
next:
	dec	d
	jr	nz,bytes
	call	asm_tape_rx_byte	;the checksum
	jr	c,fail
	add	a,e
	jr	z,block
fail:
	pop	de
	scf
	ret
done:
	pop	de
	and	a
	sbc	hl,de
	ret
sync_error:
	and	a
	jr	z,retry			;a line error before the file: listen again
	jr	fail			;ESC
