/*

Bit-bang serial functions for V-Tech Genius LEADER

2017-01-08 Bernhard "HotKey" Slawik

*/

#define byte unsigned char
#define word unsigned short

// Where should we keep the variables? You can #define this prior to including this header to overwrite its default
#ifndef VAR_START_SOFTSERIAL
	// Default: 0xc000 and up
	#define VAR_START_SOFTSERIAL 0xc000
#endif

extern byte serial_c			@ (VAR_START_SOFTSERIAL + 0);
extern byte serial_0			@ (VAR_START_SOFTSERIAL + 1);
//extern byte serial_count		@ (VAR_START_SOFTSERIAL + 2);

#define VAR_SIZE_SOFTSERIAL 2

void serial_put(byte *serial_put_buf) {
	#asm
		di
	
		pop	bc
		pop	hl	; serial_put_buf
		push	hl
		push	bc
		
		; We need almost everything...
		push	af
		push	hl
		push	bc
		push	de
	
		
		; HL should now be the address of the first byte of data
		
		_bbtx_loop:
			
			; Send actual data...
			ld	a, (hl)					; Get byte to send from HL in A
			cp	0						; Check if it is zero
			jr	z, _bbtx_end			; ...exit if so
			
			; Send all 8 data bits of C
			ld	c, a					; Prepare data bits in C
			ld	b, 8					; 8 Bits to send
			
			
			; Send start bit
			call	_bbtx_set_LOW
			call	_bbtx_delay
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			
			; Send data bits
			_bbtx_bit_loop:
				; Send out current LSB of C
				call	_bbtx_set
				call	_bbtx_delay
				
				srl	c					; Shift down to put next bit to LSB; the bit that was lost is now in CARRY
			djnz	_bbtx_bit_loop		; Repeat B times
			
			; Send stop bit(s)
			call	_bbtx_set_HIGH
			call	_bbtx_delay
			; Normally some nops should be here. But I am pretty certain it takes enough clock cylcles to fetch the next byte
			;nop
			;nop
			
			
			inc	hl						; Next byte
		jp	_bbtx_loop
		
		
		_bbtx_set:
			; Set the output pin to the given value of C (bit 0)
			; Try to keep the control flow of "1" and "0" about the same CPU cycle length!
			
			bit	0, c				; Check LSB of C (if it is 0, Z is set)
			jr	nz, _bbtx_set_HIGH	; ...it is 1: Send HIGH
			jr	_bbtx_set_LOW		; ...it is 0: Send LOW
		ret							; Unknown state - should never happen
		
		; For some reason setting HIGH takes longer. So we need to calibrate using "NOP slides"
		_bbtx_set_LOW:
			ld	a, 0xff
			out	(10h), a
			
			ld	a, 0xff
			out	(11h), a
			
			in	a, (12h)
			or	0x4					; Clock it down...
			out	(12h), a
			nop
			nop
			nop
			nop
			nop
			and	0xfb				; Clock it up...
			out	(12h), a
		ret
		
		_bbtx_set_HIGH:
			ld	a, 0x00
			out	(10h), a
			
			ld	a, 0xff
			out	(11h), a
			
			in	a, (12h)
			or	0x4					; Clock it down...
			out	(12h), a
			nop
			nop
			and	0xfb				; Clock it up...
			out	(12h), a
		ret
		
		
		_bbtx_delay:
			push hl
			
			; Delay the length of one bit (depending on the desired baud rate and CPU speed)
			;
			; I did some measurements on my 4000 Quadro:
			;
			;ld	l, 0x40		; Measured: 8 bits in 1658880 ns, so 1 bit in 207360 E-9 s, so 4822,53 baud
			;ld	l, 0x20		; Measured: 8 bits in 983040 ns, so 1 bit in 122880 E-9 s, so 8138,02 baud
			;
			; Calculation: tpbN [ns] = tc + tpi * lN	(time per bit at setting N = constant time + time per iteration * iterations at setting N)
			; tc = tpbN - tpi * lN
			;
			; N=0x40
			;	l40 := 0x40 == 64	(given)
			;	tpb40 := 207360	(measured)
			;	tc = tpb40 - tpi * 0x40
			;
			; N=0x20
			;	l20 := 0x20 == 32	(given)
			;	tpb20 := 122880	(measured)
			;	tc = tpb20 - tpi * 0x20
			;
			;	0 = tpb40 - tpi * 0x40 - (tpb20 - tpi * 0x20)
			;	0 = tpb40 - tpi * 0x40 - tpb20 + tpi * 0x20
			;	0 = tpb40-tpb20 - tpi * 0x20
			;	tpi = (tpb40-tpb20) / 0x20
			;	tpi = 84480 / 32
			;	tpi = 2640
			;
			;	2*tc = tpb20+tpb40 - tpi*96
			;	2*tc = tpb20+tpb40 - tpi*96
			;	2*tc = 330240 - 253440
			;	2*tc = 76800
			;	tc = 38400
			;
			; For 9600 baud:
			;	tpbB9600 = 104166,67 ns
			;	tpb = tc + tpi * l
			;	tpb - tc = l * tpi
			;	l = (tpb - tc) / tpi
			;	l = 24,911
			ld	l, 25	; For 9600 baud
			
			_bbtx_delay_loop:
				dec	l
				jr	nz, _bbtx_delay_loop
			pop hl
		ret
		
		
		_bbtx_end:
			
			;	; The final zero byte is now at address HL
			;	; Store the number of bytes sent (i.e. current value of HL) in "y"
			;	ld	b, h		; Copy HL to BC
			;	ld	c, l		; ...byte-wise
			;	ld	hl, _y		; Set HL to the address of "y"
			;	ld	(hl), b		; Set high byte
			;	inc	hl
			;	ld	(hl), c		; Set low byte
			
		pop de
		pop bc
		pop hl
		pop af
		ei
	#endasm
}

void serial_put_char(byte c) {
	serial_c = c;
	serial_0 = 0;
	serial_put(&serial_c);
}

byte serial_isReady() {
	#asm
		in	a, (11h)	; Get printer status
		cp	0x5f
		jr	nz, _serial_isReady_not
	
	_serial_isReady_yes:
		ld	l, 1
		jr _serial_isReady_end
	_serial_isReady_not:
		ld	l, 0
	_serial_isReady_end:
		ld	h, 0
	#endasm
}

byte serial_get_char() {
	// Return byte
	// If in "less blocking" mode, it returns "0" if no data was detected. In blocking mode all data is received
	#asm
		di				; Full attention!
		
		push	af
		push	bc
		push	de
		
		; Get timings for inter-bit-delay
		; By trial and error: 9600 baud: D=0x03, E=0x12
		ld	d, 0x03
		ld	e, 0x12
		
		
		_brx_byte_start:
		ld	c, 0					; This holds the result
		
		
		; Wait for start bit (blocking)
		;_brx_wait_loop:
		;	in	a, (11h)	; Get printer status
		;	cp	0x5f
		;jr	z, _brx_wait_loop
	
		; Wait for start bit (less blocking)
		ld	b, 0x08		; Timeout
		_brx_wait_loop:
			dec b
			jp z, _brx_byte_end	; Timeout
			
			in	a, (11h)	; Get printer status
			cp	0x5f
		jr	z, _brx_wait_loop
		
		
		; Wait half of the start bit...
		call	_brx_delayEdge
		
		
		ld	b, 8					; 8 bits is what we want
		_brx_loop:
			
			; Wait for next bit
			call	_brx_delay
			
			in	a, (11h)			; Get port status
			
			; Extract the state of the BUSY line (parallel port pin 11, the other serial terminal is connected to that line)
			cp	0x7f
			jp	z, _brx_got_0		; the received bit is 0
			jp	_brx_got_1
			
			
			; Both cases should be designed to use the same number of CPU cycles to complete
			_brx_got_1:				; The received bit is 1...
				ld	a, c			; Load the bits so far
				srl	a				; Move old bits down
				or	0x80			; Set the MSB
				jp _brx_next
			
			_brx_got_0:				; The received bit is 0...
				ld	a, c
				srl	a				; Move old bits down
				and	0x7f			; Clear the MSB
				jp _brx_next
			
			_brx_next:
				ld	c, a			; Put the temp result A back to C
			
		djnz	_brx_loop			; Loop over all bits
		; All data bits were handled
		
		; Epilogue
		; Wait 1 bit
		; call _brx_delay
		
		; Wait for stop bit to actually occur
		_brx_wait_stopBit_loop:
			in	a, (11h)
			cp	0x5f
		jr	nz, _brx_wait_stopBit_loop
		
		; The stop bit should now be happening.
		; We are ready to receive next byte
		jr	_brx_byte_end				; Jump to end
		
		
		
		_brx_delayEdge:
			push hl
			; Delay a little to make sure the edge is over
			; This must be calibrated for the desired baud rate and the CPU speed used
			; By trial and error: H=0x01, L=0x0c works fine (0x03 >> 1, 0x18 >> 1)
			
			; Works, but could be more stable for late entry
			ld	h, d
			ld	l, e
			srl	h
			srl	l
			
			jp	_brx_delay_loop		; Skip right to the loop (of _brx_delay)
		
		_brx_delay:
			push hl
			; Set the delay. This must be calibrated for the desired baud rate and the CPU speed used
			; By trial and error: 9600 baud result in a delay of H=0x03, L=0x18
			ld	h, d
			ld	l, e
			
			_brx_delay_loop:
				nop
				nop
				nop
				
				dec	l
				jp	nz, _brx_delay_loop
				
				ld	a, h
				jp	z, _brx_delay_end
				
				dec	h
			jp	_brx_delay_loop
			
			
			_brx_delay_end:
				pop hl
				ret
			
		
		_brx_byte_end:
			; Publish the result (C)
			;	ld	a, c
			;	ld	(_c), a
			
			; Set return value
			ld	h, 0
			ld	l, c
		
		_brx_end:
		pop	de
		pop	bc
		pop	af
		;pop	hl
		ei
	#endasm
}

/*
byte serial_get_line(byte *serial_get_buf) {
	
	serial_count = 0;
	
	while(1) {
		serial_c = serial_get_char();
		
		if (serial_c == 0) continue;	// zero means "no data"
		
		// Check for end character
		if ((serial_c == 0x0a) || (serial_c == 0x0d)) break;
		
		// Store in given buffer
		serial_get_buf[serial_count++] = serial_c;
	}
	
	//*serial_get_buf = 0;	// Terminate string
	serial_get_buf[serial_count] = 0;
	
	return serial_count;
}
*/
