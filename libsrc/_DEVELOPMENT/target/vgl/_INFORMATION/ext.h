/*

Functions for V-Tech Genius LEADER to make use of my DIY "BusFicker" external latch/register

2017-02-19 Bernhard "HotKey" Slawik

*/

#define byte unsigned char
#define word unsigned short

// Where is the BusFicker at
#define EXT_DO 0xa000
#define EXT_DI 0xa000

extern byte ext_DO			@ (EXT_DO);
extern byte ext_DI			@ (EXT_DI);

#define VAR_SIZE_EXT 0

void ext_init() {
	// Switch some high address lines high to activate the BUSFICKER function decoder
	#asm
		push af
		
		ld a, 81h
		out	(3h), a
		
		pop af
	#endasm
}

void ext_put(byte *ext_put_buf) {
	#asm
		di
	
		pop	bc
		pop	hl	; ext_put_buf
		push	hl
		push	bc
		
		; We need almost everything...
		push	af
		push	hl
	
		
		; HL should now be the address of the first byte of data
		
		_ext_put_loop:
			
			; Send actual data...
			ld	a, (hl)					; Get byte to send from HL in A
			cp	0						; Check if it is zero
			jr	z, _ext_put_end			; ...exit if so
			
			ld (EXT_DO), a
			
			inc	hl						; Next byte
		jp	_ext_put_loop
		
		_ext_put_end:
		pop hl
		pop af
		ei
	#endasm
}

void ext_put_char(byte c) {
	ext_DO = c;
}

byte ext_get_char() {
	return ext_DI;
}

/*
byte ext_get_line(byte *ext_get_buf) {
	
	ext_count = 0;
	
	while(1) {
		ext_c = ext_get_char();
		
		if (ext_c == 0) continue;	// zero means "no data"
		
		// Check for end character
		if ((ext_c == 0x0a) || (ext_c == 0x0d)) break;
		
		// Store in given buffer
		ext_get_buf[ext_count++] = ext_c;
	}
	
	//*ext_get_buf = 0;	// Terminate string
	ext_get_buf[ext_count] = 0;
	
	return ext_count;
}
*/
