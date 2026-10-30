;
;	Samsung SPC-1000: save a file to the cassette
;
;	int tape_save(const char *name, const void *addr, size_t len, const void *user, size_t ulen) __smallc;
;
;	Writes a machine code file in the ROM's own format (BASIC's LOAD "name",M reads it: it goes to addr): a header
;	block, which has the name (up to 16 characters), and a block of the len bytes at addr.  A program can keep up to
;	102 bytes of its own in the header (user and ulen, which may be 0): tape_load_to gives them back.
;
;	Interrupts are off while it runs.  It waits for the deck to run (the player presses RECORD and PLAY, and the
;	deck says so): the break keys give up.
;
;	Returns 0, or -1 if it was stopped.
;

	MODULE	tape_save

	SECTION	bss_clib
ts_name:	defw	0
ts_addr:	defw	0
ts_len:		defw	0
ts_user:	defw	0
ts_ulen:	defw	0

	SECTION	code_clib
	PUBLIC	tape_save
	PUBLIC	_tape_save

	EXTERN	asm_tape_fcb
	EXTERN	asm_tape_psg_init
	EXTERN	asm_tape_motor_on
	EXTERN	asm_tape_motor_off
	EXTERN	asm_tape_tx_leader
	EXTERN	asm_tape_tx_block

tape_save:
_tape_save:
	ld	hl,2
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	(ts_ulen),de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	(ts_user),de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	(ts_len),de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	(ts_addr),de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	(ts_name),de
	ld	hl,asm_tape_fcb		;the header: 1 (a machine code file), the name, the length at +$12, the address at +$14,
	ld	de,asm_tape_fcb+1	;the start address (none) and the protection (none), then the program's own bytes at +$1a
	ld	bc,127
	ld	(hl),0
	ldir
	ld	a,1
	ld	(asm_tape_fcb),a
	ld	hl,(ts_name)
	ld	de,asm_tape_fcb+1
	ld	b,16
name:
	ld	a,(hl)
	and	a
	jr	z,named
	ld	(de),a
	inc	hl
	inc	de
	djnz	name
named:
	ld	hl,(ts_len)
	ld	(asm_tape_fcb+$12),hl
	ld	hl,(ts_addr)
	ld	(asm_tape_fcb+$14),hl
	ld	bc,(ts_ulen)
	ld	a,b
	and	a
	jr	nz,clamp
	ld	a,c
	cp	103
	jr	c,sized
clamp:
	ld	bc,102
sized:
	ld	a,b
	or	c
	jr	z,start
	ld	hl,(ts_user)
	ld	de,asm_tape_fcb+$1a
	ldir
start:
	ld	a,i			;the interrupt flag, for when it is done
	push	af
	di
	call	asm_tape_psg_init
	call	asm_tape_motor_on
	jr	c,fail
	ld	bc,$55f0		;the header's leader: 22000 zero bits, 40 ones, 40 zeros
	ld	de,$2828
	call	asm_tape_tx_leader
	ld	hl,asm_tape_fcb
	ld	bc,128
	call	asm_tape_tx_block
	jr	c,fail
	call	asm_tape_motor_off
	ld	bc,(ts_len)
	ld	a,b
	or	c
	jr	z,ok			;nothing to put after the header
	call	asm_tape_motor_on
	jr	c,fail
	ld	bc,$2af8		;the data's: 11000 zero bits, 20 ones, 20 zeros
	ld	de,$1414
	call	asm_tape_tx_leader
	ld	hl,(ts_addr)
	ld	bc,(ts_len)
	call	asm_tape_tx_block
	jr	c,fail
	call	asm_tape_motor_off
ok:
	ld	hl,0
	jr	finish
fail:
	call	asm_tape_motor_off
	ld	hl,-1
finish:
	pop	af
	ret	po
	ei
	ret
