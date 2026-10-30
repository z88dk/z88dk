;
;	Samsung SPC-1000: load a file from the cassette into a buffer
;
;	int tape_load_to(const char *name, void *buf, size_t len, void *user, size_t ulen) __smallc;
;
;	Reads the next file with that name (any name if name is 0; see tape_save) and stores its data at buf, whatever
;	address the file says.  Files with other names are passed over.  A file longer than len is read to its end and
;	the rest dropped.  The program's own bytes in the header go to user (up to ulen of them, if it is not 0).
;
;	Interrupts are off while it runs.  It waits for the deck to run (the player presses PLAY, and the deck says so)
;	and for the file: the break keys give up.
;
;	Returns the number of bytes stored; -1 if the tape could not be read and buf is as it was (the header was not read: an
;	error, or the break keys); -2 if the header was read and the data was not (buf may have been written to).
;

	MODULE	tape_load_to

	SECTION	bss_clib
tl_name:	defw	0
tl_buf:		defw	0
tl_len:		defw	0
tl_user:	defw	0
tl_ulen:	defw	0
tl_size:	defw	0

	SECTION	code_clib
	PUBLIC	tape_load_to
	PUBLIC	_tape_load_to

	EXTERN	asm_tape_fcb
	EXTERN	asm_tape_psg_init
	EXTERN	asm_tape_motor_on
	EXTERN	asm_tape_motor_off
	EXTERN	asm_tape_find_leader
	EXTERN	asm_tape_rx_block

tape_load_to:
_tape_load_to:
	ld	hl,2
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	(tl_ulen),de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	(tl_user),de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	(tl_len),de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	(tl_buf),de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	(tl_name),de
	ld	a,i			;the interrupt flag, for when it is done
	push	af
	di
	call	asm_tape_psg_init
header:
	call	asm_tape_motor_on
	jp	c,fail
	ld	hl,$2828		;a header's leader: 40 ones and 40 zeros
	call	asm_tape_find_leader
	jp	c,fail
	ld	hl,asm_tape_fcb
	ld	bc,128
	ld	de,128
	call	asm_tape_rx_block
	jp	c,fail
	call	asm_tape_motor_off
	ld	hl,(tl_name)
	ld	a,h
	or	l
	jr	z,match
	ld	de,asm_tape_fcb+1
	ld	b,16
compare:
	ld	a,(de)
	cp	(hl)
	jr	nz,header		;another file: look for the next
	and	a
	jr	z,match
	inc	hl
	inc	de
	djnz	compare
match:
	ld	hl,(tl_user)
	ld	a,h
	or	l
	jr	z,sized
	ld	bc,(tl_ulen)
	ld	a,b
	and	a
	jr	nz,clamp
	ld	a,c
	cp	103
	jr	c,copy
clamp:
	ld	bc,102
copy:
	ld	a,b
	or	c
	jr	z,sized
	ex	de,hl			;de = user
	ld	hl,asm_tape_fcb+$1a
	ldir
sized:
	ld	bc,(asm_tape_fcb+$12)	;the length of the data
	ld	a,b
	or	c
	jr	z,none
	ld	(tl_size),bc
	ld	hl,(tl_len)
	and	a
	sbc	hl,bc
	ld	de,(tl_len)
	jr	c,limited		;the buffer is the smaller
	ld	e,c			;the file is: all of it
	ld	d,b
limited:
	push	de			;what will be stored
	call	asm_tape_motor_on
	jr	c,fail_pop
	ld	hl,$1414		;a data block's leader: 20 ones and 20 zeros
	call	asm_tape_find_leader
	jr	c,fail_pop
	pop	de
	push	de
	ld	hl,(tl_buf)
	ld	bc,(tl_size)
	call	asm_tape_rx_block
	jr	c,fail_pop
	call	asm_tape_motor_off
	pop	hl
	jr	finish
none:
	ld	hl,0
	jr	finish
fail_pop:
	pop	de
	call	asm_tape_motor_off
	ld	hl,-2
	jr	finish
fail:
	call	asm_tape_motor_off
	ld	hl,-1
finish:
	pop	af
	ret	po
	ei
	ret
