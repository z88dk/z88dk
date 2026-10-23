;
;	Mitsubishi Multi8: receiving from the cassette
;
;	The 8251 USART is at ports $20 (data) and $21 (status/command); the baud rate is whatever the
;	machine's ROM left the 8253 timer at, which is what the bootstrap's own loader relies on too.
;

	MODULE	tape_rx

	SECTION	code_clib
	PUBLIC	asm_tape_rx_init
	PUBLIC	asm_tape_rx_byte

; Set the USART up to receive: the sequence the ROM's loader uses (see asm_tape_load).
;
; Uses: a
asm_tape_rx_init:
	ld	a,$ce
	out	($21),a
	ld	a,$27
	out	($21),a
	ld	a,$77			;reset, so that the mode comes next ...
	out	($21),a
	ld	a,$4e			;... 8 bits, 1 stop bit, no parity
	out	($21),a
	ld	a,$14			;receive enable, reset the error flags
	out	($21),a
	in	a,($20)			;discard what is waiting
	ret

; Read the next byte from the tape, waiting for it.  ESC on the keyboard gives up.
;
; Exit:	nc = a = the byte
;	 c = a = 0: a line error (parity, overrun or framing), 1: ESC was pressed
; Uses: a, flags
asm_tape_rx_byte:
	in	a,($21)
	bit	1,a			;a byte is ready
	jr	nz,ready
	in	a,(1)			;the keyboard: bit 3 is clear while a key is down
	bit	3,a
	jr	nz,asm_tape_rx_byte
	in	a,(0)
	cp	$1b
	jr	nz,asm_tape_rx_byte
	ld	a,1
	scf
	ret
ready:
	and	$30			;parity or framing error
	jr	nz,error
	in	a,($20)
	ret
error:
	xor	a
	scf
	ret
