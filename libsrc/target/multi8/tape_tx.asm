;
;	Mitsubishi Multi8: sending to the cassette
;
;	The 8251 USART is at ports $20 (data) and $21 (status/command).  The recorder's remote control is
;	bit 1 of port A of the PSG (register 14, written through ports $18 and $19).
;

	MODULE	tape_tx

	SECTION	code_clib
	PUBLIC	asm_tape_tx_start
	PUBLIC	asm_tape_tx_byte
	PUBLIC	asm_tape_tx_end

	EXTERN	asm_set_psg

; Start the recorder and set the USART up to transmit, then send a leader: the loaders ignore everything
; before the ':' that starts a block.
;
; Uses: af, bc, de, hl
asm_tape_tx_start:
	ld	l,7			;PSG mixer: port A an output, the sound off
	ld	e,$7f
	call	asm_set_psg
	ld	l,14			;remote on
	ld	e,2
	call	asm_set_psg
	xor	a			;three zeroes and a reset leave the USART ready for a mode, whatever it was doing
	out	($21),a
	out	($21),a
	out	($21),a
	ld	a,$40
	out	($21),a
	ld	a,$4e			;8 bits, 1 stop bit, no parity
	out	($21),a
	ld	a,$27			;transmit enable
	out	($21),a
	ld	b,128
leader:
	xor	a
	call	asm_tape_tx_byte
	djnz	leader
	ret

; Send a byte, waiting for the USART to take it.
;
; Entry: a = the byte
; Exit:  a unchanged
asm_tape_tx_byte:
	push	af
wait:
	in	a,($21)
	rrca				;bit 0: transmit ready
	jr	nc,wait
	pop	af
	out	($20),a
	ret

; Send a trailer, wait for the last byte to be out and stop the recorder.
;
; Uses: af, bc, de, hl
asm_tape_tx_end:
	ld	b,16
trailer:
	xor	a
	call	asm_tape_tx_byte
	djnz	trailer
empty:
	in	a,($21)
	bit	2,a			;transmitter empty
	jr	z,empty
	ld	l,14			;remote off
	ld	e,0
	jp	asm_set_psg
