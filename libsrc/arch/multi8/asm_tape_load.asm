

	MODULE	asm_tape_load

	SECTION	code_clib
	PUBLIC	asm_tape_load
;
; Load a block to the address specified in the file header
;
; Exit: nc = success
;        c = failure
;
asm_tape_load:
	call	initialise_hw
	ld	a,$4e
	out	($21),a
	ld	a,$14
	out	($21),a
	in	a,($20)
wait_for_ready:
	in	a,($21)
	bit	1,a
	jr	z,wait_for_ready
	in	a,($21)
	and	$30
	jr	nz,asm_tape_load
	in	a,($20)			;ac4
	cp	$3a
	jr	nz,asm_tape_load
	call	read_byte
	ld	c,a
	ld	h,a
	call	read_byte
	ld	l,a
	add	c
	ld	c,a
	call	read_byte
	add	c
	jr	nz,failure		;@0b07
next_block:
	call	read_byte
	cp	$3a
	jr	nz,failure
	call	read_byte
	ld	c,a
	ld	b,a
	or	a
	ret	z			;end of file
read_block_loop:
	call	read_byte
IF VERIFY
	push	af
	ld	a,(some_var)		;some_var = f97b
	or	a
	jr	z,skip_verify
	pop	af
	cp	(hl)
	jr	nz,failure
	jr	rejoin
skip_verify:
	pop	af
ENDIF
	ld	(hl),a
rejoin:
	add	c
	ld	c,a
	inc	hl
	dec	b
	jr	nz,read_block_loop
	call	read_byte
	add	c
	jr	z,next_block
failure:
	scf
	ret
failure_pop:
	pop	af	;return address from read_byte
	jr	failure

read_byte:
	in	a,($21)
	bit	1,a
	jr	z,read_byte
	in	a,($21)
	and	$30
	jr	nz,failure_pop
	in	a,($20)
	ret


initialise_hw:
	ld	a,$ce
	out	($21),a
	ld	a,$27
	out	($21),a
	ld	a,$77
	out	($21),a
	ret

