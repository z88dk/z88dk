;
;	Samsung SPC-1000: the cassette, bit by bit (what tape_save and tape_load_to are made of)
;
;	The format is the machine's own (the ROM's FSAVE/MSAVE and FLOAD/MLOAD), so what is written can be read by
;	BASIC and what BASIC wrote can be read here.  A file is two blocks.  A block is:
;
;	  - a leader: zero bits, then D one bits, then E zero bits and one more one bit
;	  - the bytes, each a one bit (the start bit) and its eight bits, most significant first
;	  - a checksum (the number of one bits in the data) as two bytes, high first, and a one bit
;	  - 256 zero bits and the same data, checksum and one bit again (the reader takes the second if the first is bad)
;
;	A bit is a pulse, high and then low: a zero is about 0.45 ms and a one about 0.9 ms (the output is bit 0 of port
;	$6000).  The input is bit 7 of the AY-3-8910's port A (register 14, address port $4000, data port $4001); a bit is
;	read by waiting for the rising edge and looking at the level 0.33 ms later.  The timing is the ROM's, instruction
;	for instruction: the loops below are its own.
;
;	The motor is the other bits of the same port: a rising edge on bit 1 switches the deck's motor on or off, as it
;	says by bit 6 of port A (set while the motor is stopped).
;
;	The caller disables interrupts.  A keyboard break (the ROM's: the two keys that make bits 1 and 4 of row 0 low)
;	stops everything.
;

	MODULE	tape_io

	SECTION	code_clib
	PUBLIC	asm_tape_motor_on
	PUBLIC	asm_tape_motor_off
	PUBLIC	asm_tape_tx_leader
	PUBLIC	asm_tape_tx_block
	PUBLIC	asm_tape_find_leader
	PUBLIC	asm_tape_rx_block
	PUBLIC	asm_tape_psg_init
	PUBLIC	asm_tape_fcb

	SECTION	bss_clib
tape_port:	defb	0		; what was last sent to port $6000
tape_cnt:	defw	0		; the one bits of the block, as sent or read
tape_dst:	defw	0
tape_size:	defw	0
tape_lim:	defw	0
tape_copies:	defb	0
tape_fl:	defw	0
asm_tape_fcb:	defs	128		; the header block: the file control block (tape_save and tape_load_to)

	SECTION	code_clib

; The AY's port A is an input (bit 6 of the mixer register clear), and register 14 is the one that is selected.
;
; Uses: af, bc
asm_tape_psg_init:
	ld	bc,$4000
	ld	a,7
	out	(c),a
	ld	a,$40
	in	a,(1)			;the mixer: port 4001 with a as the high byte
	and	$bf
	ld	bc,$4001
	out	(c),a
; fall into select
select:
	ld	bc,$4000
	ld	a,14
	out	(c),a
	ret

; Carry if the break keys are down.
;
; Uses: af
brk:
	ld	a,$80
	in	a,(0)
	and	$12
	ret	nz
	scf
	ret

; The motor on: pulse it until the deck says it is running, then wait for it (the player's PLAY key) or the break keys.
;
; Exit:  nc: running; c: break
; Uses: af, bc
asm_tape_motor_on:
	push	hl
	call	select
	ld	l,10
mon_try:
	ld	a,$40
	in	a,(1)
	and	$40
	jr	nz,mon_pulse
mon_ok:
	pop	hl
	and	a
	ret
mon_pulse:
	call	pulse
	dec	l
	jr	nz,mon_try
mon_wait:
	call	brk
	jr	c,mon_break
	ld	a,$40
	in	a,(1)
	and	$40
	jr	nz,mon_wait
	jr	mon_ok
mon_break:
	pop	hl
	scf
	ret

; The motor off: pulse it until the deck says it has stopped (or ten times).
;
; Uses: af, bc
asm_tape_motor_off:
	push	de
	call	select
	ld	d,10
moff_try:
	ld	a,$40
	in	a,(1)
	and	$40
	jr	nz,moff_done
	call	pulse
	dec	d
	jr	nz,moff_try
moff_done:
	pop	de
	ret

; Bit 1 of the port low and high again
pulse:
	ld	bc,$6000
	ld	a,(tape_port)
	res	1,a
	out	(c),a
	set	1,a
	out	(c),a
	ld	(tape_port),a
	ret

; Send a zero bit
tx0:
	push	af
	push	bc
	ld	bc,$6000
	ld	a,(tape_port)
	set	0,a
	out	(c),a
	push	af
	ld	a,$3c
	call	delay
	pop	af
	res	0,a
	out	(c),a
	ld	(tape_port),a
	ld	a,$37
	call	delay
	pop	bc
	pop	af
	ret

; Send a one bit
tx1:
	push	af
	push	bc
	ld	bc,$6000
	ld	a,(tape_port)
	set	0,a
	out	(c),a
	push	af
	ld	a,$78
	call	delay
	pop	af
	res	0,a
	out	(c),a
	ld	(tape_port),a
	ld	a,$73
	call	delay
	pop	bc
	pop	af
	ret

; The sampling delay, and a delay of a loops (14 states each)
sample_delay:
	ld	a,$5a
delay:
	dec	a
	jp	nz,delay
	ret

; Send the byte in a: a start bit and the eight bits
tx_byte:
	push	bc
	ld	b,8
	call	tx1
txb_bit:
	rlca
	call	c,tx1
	call	nc,tx0
	dec	b
	jp	nz,txb_bit
	pop	bc
	ret

; Send a leader.
;
; Entry: bc = the zero bits to start with, d = the one bits, e = the zero bits that follow them
; Uses: af, bc, de
asm_tape_tx_leader:
txl_zeros:
	call	tx0
	dec	bc
	ld	a,b
	or	c
	jr	nz,txl_zeros
txl_ones:
	call	tx1
	dec	d
	jr	nz,txl_ones
txl_zero:
	call	tx0
	dec	e
	jr	nz,txl_zero
	jp	tx1

; Send a block's data, twice.
;
; Entry: hl = the data, bc = its length (not 0)
; Exit:  nc: sent; c: break
; Uses: af, bc, de, hl
asm_tape_tx_block:
	push	hl
	push	bc
	ld	de,0			;the checksum: the one bits
txc_byte:
	push	bc
	ld	b,8
	ld	a,(hl)
txc_bit:
	rlca
	jr	nc,txc_zero
	inc	de
txc_zero:
	djnz	txc_bit
	pop	bc
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,txc_byte
	ld	(tape_cnt),de
	pop	bc
	pop	hl
	ld	d,2			;the copies
txb_copy:
	push	hl
	push	bc
txb_byte:
	ld	a,(hl)
	call	tx_byte
	call	brk
	jr	c,txb_break
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,txb_byte
	ld	hl,(tape_cnt)
	ld	a,h
	call	tx_byte
	ld	a,l
	call	tx_byte
	call	tx1
	dec	d
	jr	z,txb_done
	ld	b,0
txb_gap:
	call	tx0
	dec	b
	jp	nz,txb_gap
	pop	bc
	pop	hl
	jr	txb_copy
txb_done:
	pop	bc
	pop	hl
	and	a
	ret
txb_break:
	pop	bc
	pop	hl
	scf
	ret

; Wait for the next rising edge of the input (the start of a pulse).
;
; Exit:  nc: there is one; c: break
; Uses: af
edge:
edge_a:
	ld	a,$80
	in	a,(0)
	and	$12
	jp	nz,edge_b
	scf
	ret
edge_b:
	ld	a,$40
	in	a,(1)
	and	$80
	jp	nz,edge_a		;high: wait for it to go low
edge_c:
	ld	a,$80
	in	a,(0)
	and	$12
	jp	nz,edge_d
	scf
	ret
edge_d:
	ld	a,$40
	in	a,(1)
	and	$80
	jp	z,edge_c		;low: wait for it to go high
	ret

; Read a byte, and take the start bit of the next (the byte's own is taken already).  The one bits are added to tape_cnt.
;
; Exit:  nc = a = the byte; c: break
; Uses: af
rx_byte:
	push	bc
	push	hl
	ld	h,8
	ld	l,0
rxb_bit:
	call	edge
	jr	c,rxb_break
	call	sample_delay
	ld	a,$40
	in	a,(1)
	and	$80
	jr	z,rxb_zero
	push	hl
	ld	hl,(tape_cnt)
	inc	hl
	ld	(tape_cnt),hl
	pop	hl
	scf
rxb_zero:
	ld	a,l
	rla
	ld	l,a
	dec	h
	jr	nz,rxb_bit
	call	edge
	jr	c,rxb_break
	ld	a,l
	pop	hl
	pop	bc
	and	a
	ret
rxb_break:
	pop	hl
	pop	bc
	scf
	ret

; Find a leader: h one bits and then l zero bits (the header's are 40 and 40, a data block's 20 and 20), and its last one bit.
;
; Exit:  nc: found; c: break
; Uses: af, bc, hl
asm_tape_find_leader:
	ld	(tape_fl),hl
	call	select
fl_restart:
	ld	hl,(tape_fl)
fl_ones:
	call	edge
	jr	c,fl_break
	call	sample_delay
	ld	a,$40
	in	a,(1)
	and	$80
	jr	z,fl_restart
	dec	h
	jr	nz,fl_ones
fl_zeros:
	call	edge
	jr	c,fl_break
	call	sample_delay
	ld	a,$40
	in	a,(1)
	and	$80
	jr	nz,fl_restart
	dec	l
	jr	nz,fl_zeros
	jp	edge			;the last one bit
fl_break:
	scf
	ret

; Read a block's data (the first copy that has the right checksum), up to lim bytes of the length stored.
;
; Entry: hl = where to store, bc = the length of the data, de = how many bytes to store (the rest is read and dropped)
; Exit:  nc: read; c: a = 0 the checksum was wrong in both copies, 1 break
; Uses: af, bc, de, hl
asm_tape_rx_block:
	ld	(tape_dst),hl
	ld	(tape_size),bc
	ld	(tape_lim),de
	ld	a,2
	ld	(tape_copies),a
rxl_try:
	call	select
rxl_start:
	call	edge
	jr	c,rxl_break
	call	sample_delay
	ld	a,$40
	in	a,(1)
	and	$80
	jr	z,rxl_start		;the start bit of the first byte is the first one bit
	ld	hl,0
	ld	(tape_cnt),hl
	ld	hl,(tape_dst)
	ld	bc,(tape_size)
	ld	de,(tape_lim)
rxl_byte:
	call	rx_byte
	jr	c,rxl_break
	push	af
	ld	a,d
	or	e
	jr	z,rxl_drop
	pop	af
	ld	(hl),a
	inc	hl
	dec	de
	jr	rxl_next
rxl_drop:
	pop	af
rxl_next:
	dec	bc
	ld	a,b
	or	c
	jr	nz,rxl_byte
	ld	hl,(tape_cnt)
	push	hl
	call	rx_byte
	jr	c,rxl_break_pop
	ld	e,a
	call	rx_byte
	jr	c,rxl_break_pop
	pop	hl
	cp	l
	jr	nz,rxl_bad
	ld	a,e
	cp	h
	jr	nz,rxl_bad
	and	a
	ret
rxl_bad:
	ld	a,(tape_copies)
	dec	a
	ld	(tape_copies),a
	jr	nz,rxl_try
	xor	a
	scf
	ret
rxl_break_pop:
	pop	hl
rxl_break:
	ld	a,1
	scf
	ret
