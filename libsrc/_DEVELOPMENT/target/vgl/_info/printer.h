/*

Printer functions for V-Tech Genius LEADER

2017-01-08 Bernhard "HotKey" Slawik

*/

#define byte unsigned char
#define word unsigned short

#define VAR_SIZE_PRINTER 0

byte printer_isReady() {
	// Wait until BUSY line is cleared (1) or timeout (0)
	#asm
		; Wait for port 0x11 bit 5 to go low (with time out)
		push	bc
		ld	bc, 0xff
		ld	hl, 0x01	; return value
		
		_printer_check_loop:
			in	a, (11h)
			bit	5, a	; Test if bit 0x05 is set
			jr	nz, _printer_check_end	; If set: Return
		djnz	_printer_check_loop	; If not: retry 255 times
		
		; Timeout
		ld	hl, 0x00
		
		_printer_check_end:
		pop	bc
	#endasm
}

void printer_put_char(byte c) {
	
	// Output a byte to the parallel port as it is done in MODEL4000 firmware
	/*
		Port		0x10		0x11		0x12
				...		...		...
	data			~X >		...		...
	TX?			...		FF >		...
				...		...		<<<
	strobe		...		...		+4 >
	strobe		...		...		-4 >
				...		...		...
	*/
	
	// First we should check if the printer is busy or not
	//print_check():
	
	#asm
		
		pop bc
		pop hl	; byte to be printed
		push hl
		push bc
		
		; Get dirty
		di	; Put your gloves on...
		
		ld	a, l
		cpl	; inverts A
		out	(10h),a		; Send the inverted byte to the parallel port data pins
	
		nop
		nop
		nop
		nop
		nop
		
		ld	a,0ffh
		out	(11h),a		; Set port 0x11 all-high (transmit it)
		
		nop
		nop
		nop
		
		in	a,(12h)		; Strobe: Parallel port pin 1 LOW
		or	04h
		
		nop
		nop
		
		out	(12h),a
		
		nop
		nop
		nop
		nop
		
		and	0fbh
		out	(12h),a		; Strobe end: Parallel port pin 1 HIGH again
		
		ei	; Back to normal
	#endasm
}

void printer_get(byte *printer_get_buf) {
	// Get a character from parallel port?
	// Does this implement the PC-Link thing?
	// It seems to be requesting a byte by sending out a bit mask and receiving the result on the status register
	// This can be seen at 0x01a6 of MODEL4000 ROM
	/*
		Port		0x10		0x11		0x12
				...		...		...
				...		FF >		...
				80 >		...		...
				...		<<<		...
				<<<		...		...
				00 >		...		...
	strobe		...		...		<<<
	strobe		...		...		20 >
				...		...		...
	*/
	#asm
		
		pop bc
		pop hl	; Pointer to buffer
		push hl
		push bc
		
		;ld	hl, _printer_get_buf			; Where to put the data
		
		; Set flags to high?
		ld	a, 0ffh
		out	(11h), a					; Send 0xff to port 0x11
		
		
		ld	c, 80h
		ld	b, 8h						; 8 rounds of it (bit by bit)
		
		; Loop:
		_printer_get_loop:
			ld	a, c
			out	(10h),a					; Send value/bitmask to port 0x10
			
			in	a, (11h)				; Read port 0x11
			ld	(hl), a					; ...and store in buffer
			inc	hl
			
			in	a,(10h)					; Read port 0x10
			ld	(hl), a					; ...and store in buffer
			inc	hl
			
			xor	a
			out	(10h),a					; Send 0x00 to port 0x10
			
			srl	c						; Next bit
		djnz	_printer_get_loop
		; Next round/bit
		
		; Clock/ack? via port 0x12
		in	a,(12h)					; Read port 0x12
		or	20h						; Clear all bits but caps lock?
		nop
		nop
		out	(12h),a					; Send 0x00/0x20 to port 0x12
		
	#endasm
}