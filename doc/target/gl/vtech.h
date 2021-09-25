/*

Headers for writing V-Techn ROMs

Mostly done via reverse-engineering
2017-01-08 Bernhard "HotKey" Slawik

*/

#define byte unsigned char
#define word unsigned short

#define CR_ON_LF	// Automatically return to col 0 on 0x0a character (LF)

// Where should we keep the variables? You can #define this prior to including this header to overwrite its default
#ifndef VAR_START_VTECH
	// Default: 0xc000 and up
	#define VAR_START_VTECH 0xc000
#endif


// System-mapped values
extern char SYSTEM_TYPE_TEXT[4] @ 0x7be8;	// May contain "TEXT" after out(01h),07h
extern byte SYSTEM_ARCHITECTURE_0006 @ 0x0006;	// Used to determine the system architecture
extern byte SYSTEM_ARCHITECTURE_0038 @ 0x0038;	// Used to determine the system architecture (and the 30 bytes after that, in 3 byte increments). Checked for being 0xc3 or not
extern byte SYSTEM_ARCHITECTURE_4000 @ 0x4000;	// Used to determine the system architecture
extern byte SYSTEM_ARCHITECTURE_801E @ 0x801e;	// Used to determine the ROM type


extern char LCD_VRAM[20*4] @ 0xdca0;
extern char LCD_VRAM_ROW0[20] @ 0xdca0;	// ... 0xdcb3
extern char LCD_VRAM_ROW1[20] @ 0xdcb4;	// ... 0xdcc7
extern char LCD_VRAM_ROW2[20] @ 0xdcc8;	// ... 0xdcdb	// MODEL4000 only (MODEL2000 stores cursor data there)
extern char LCD_VRAM_ROW3[20] @ 0xdcdc;	// ... 0xdcef	// MODEL4000 only (MODEL2000 stores cursor data there)


// MODEL2000
extern byte KEY_STATUS_MODEL2000 @ 0xdce0;	// Controls reading from the keyboard on 2000 (put 0xc0 into it, wait for it to become 0xd0)
extern byte KEY_CURRENT_MODEL2000 @ 0xdce4;	// Holds the current key code on 2000

extern byte LCD_REFRESH_ROWS_MODEL2000[2] @ 0xdceb;	// MODEL2000
extern byte LCD_REFRESH_ROW0_MODEL2000 @ 0xdceb;	// MODEL2000: Refreshes display of VRAM_ROW0 when 1 is put there
extern byte LCD_REFRESH_ROW1_MODEL2000 @ 0xdcec;	// MODEL2000: Refreshes display of VRAM_ROW1 when 1 is put there

// Something is happending on these addresses: dced, dcee, dcef, dcf0
extern byte LCD_CURSOR_COL_MODEL2000 @ 0xdcef;	// Current column + 64*row
extern byte LCD_CURSOR_MODE_MODEL2000 @ 0xdced;	// Show cursor (0=off, 1=block 2=line)


// MODEL4000
extern byte KEY_STATUS_MODEL4000 @ 0xdb00;	// Controls reading from the keyboard on 4000 (put 0xc0 into it, wait for it to become 0xd0)
extern byte KEY_CURRENT_MODEL4000 @ 0xdb01;	// Holds the current key code on 4000
	//extern byte SYS_db8d @ 0xdb8d;	// BIOS2000 puts 0xff there on boot

extern byte LCD_REFRESH_ROWS_MODEL4000[4] @ 0xdcf0;	// MODEL4000
extern byte LCD_REFRESH_ROW0_MODEL4000 @ 0xdcf0;	// MODEL4000: Refreshes display of VRAM_ROW0 when 1 is put there
extern byte LCD_REFRESH_ROW1_MODEL4000 @ 0xdcf1;	// MODEL4000: Refreshes display of VRAM_ROW1 when 1 is put there
extern byte LCD_REFRESH_ROW2_MODEL4000 @ 0xdcf2;	// MODEL4000: Refreshes display of VRAM_ROW2 when 1 is put there
extern byte LCD_REFRESH_ROW3_MODEL4000 @ 0xdcf3;	// MODEL4000: Refreshes display of VRAM_ROW3 when 1 is put there

extern byte LCD_CURSOR_COL_MODEL4000 @ 0xdcf4;
extern byte LCD_CURSOR_ROW_MODEL4000 @ 0xdcf5;
extern byte LCD_CURSOR_MODE_MODEL4000 @ 0xdcf6;



// Key codes
#define KEY_NONE	0
#define KEY_ASTERISK	0x2a	// Asterisk (top left key) without modifiers
#define KEY_BREAK	0x60	// Asterisk (top left key) + Shift

#define KEY_HELP	0x83	// HELP/TAB without modifiers
#define KEY_TAB		0x82	// HELP/TAB + Shift

#define KEY_PLAYER_LEFT	0x7b	// LEFT PLAYER without modifiers
#define KEY_PLAYER_RIGHT	0x7f	// RIGHT PLAYER without modifiers
//#define KEY_PLAYER_LEFT	0x5b	// LEFT PLAYER + Shift
//#define KEY_PLAYER_RIGHT	0x5f	// RIGHT PLAYER + Shift
//#define KEY_INS	0x7b
//#define KEY_DEL	0x7f

#define KEY_CURSOR_RIGHT	0xf0
#define KEY_CURSOR_LEFT	0xf1
#define KEY_CURSOR_UP	0xf2	// uUml + Alt
#define KEY_CURSOR_DOWN	0xf3	// aUml + Alt
#define KEY_BACKSPACE_X	0xf4	// oUml + Alt

#define KEY_ANSWER	0x2b	// +/ANSWER (does not change with Shift)
#define KEY_ENTER	0x7c

#define KEY_REPEAT	0x7e	// REPEAT/DELETE without modifiers
#define KEY_DELETE	0x5C	// REPEAT/DELETE + Shift

#define KEY_ACTIVITY_1	0x01	// First activity selection foil button
#define KEY_ACTIVITY_2	0x02
#define KEY_ACTIVITY_3	0x03
#define KEY_ACTIVITY_4	0x04
#define KEY_ACTIVITY_5	0x05
#define KEY_ACTIVITY_6	0x06
#define KEY_ACTIVITY_7	0x07
#define KEY_ACTIVITY_8	0x08
#define KEY_ACTIVITY_9	0x09
#define KEY_ACTIVITY_10	0x0a
#define KEY_ACTIVITY_11	0x0b
#define KEY_ACTIVITY_12	0x0c
#define KEY_ACTIVITY_13	0x0d
#define KEY_ACTIVITY_14	0x0e
#define KEY_ACTIVITY_15	0x0f
#define KEY_ACTIVITY_16	0x10
#define KEY_ACTIVITY_17	0x11
#define KEY_ACTIVITY_18	0x12
#define KEY_ACTIVITY_19	0x13
#define KEY_ACTIVITY_20	0x14
#define KEY_ACTIVITY_21	0x15
#define KEY_ACTIVITY_22	0x16
#define KEY_ACTIVITY_23	0x17
#define KEY_ACTIVITY_24	0x18
#define KEY_ACTIVITY_25	0x19
#define KEY_ACTIVITY_26	0x1a
#define KEY_ACTIVITY_27	0x1b
#define KEY_ACTIVITY_28	0x1c
#define KEY_ACTIVITY_29	0x1d
#define KEY_ACTIVITY_30	0x1e
#define KEY_ACTIVITY_31	0x1f	// This is the last one they could fit below valid ASCII codes
#define KEY_ACTIVITY_32	0xB0	// This is where they continue (0xb0)
#define KEY_ACTIVITY_33	0xB1
#define KEY_ACTIVITY_34	0xB2
#define KEY_ACTIVITY_35	0xB3	// Last activity selection foil button

#define KEY_POWER_OFF	0xB4	// OFF foil button
#define KEY_LEVEL	0xB5	// LEVEL foil button
#define KEY_PLAYERS	0xB6	// PLAYERS foil button
#define KEY_DISKETTE	0xB7	// DISKETTE foil button



// 4000 models seem to store their variables at d400...
// d500 is also OK
// Seems like c000 - d7ff can be used?

extern p_put	@ (VAR_START_VTECH + 0);
extern p_put_char	@ (VAR_START_VTECH + 2);
extern p_get_char	@ (VAR_START_VTECH + 4);

extern byte sys_type			@ (VAR_START_VTECH + 6);
extern byte screen_cols		@ (VAR_START_VTECH + 8);
extern byte screen_rows		@ (VAR_START_VTECH + 10);
extern byte cursor_col			@ (VAR_START_VTECH + 12);
extern byte cursor_row			@ (VAR_START_VTECH + 14);

extern word screen_size		@ (VAR_START_VTECH + 16);
extern word screen_scrollSize	@ (VAR_START_VTECH + 18);

extern byte cursor_ofs			@ (VAR_START_VTECH + 20);
//extern byte *put_text_p		@ (VAR_START_VTECH + 16);
extern byte screen_c			@ (VAR_START_VTECH + 22);

extern word frq			@ (VAR_START_VTECH + 24);

extern byte get_line_c			@ (VAR_START_VTECH + 26);
extern byte get_line_count	@ (VAR_START_VTECH + 27);

#define VAR_SIZE_VTECH 28




void put(byte *text) {
	//screen_put_char(text);
	p_put(text);
}

void put_char(byte c) {
	//screen_put_char(c);
	p_put_char(c);
}
void put_line() {
	//put_char(0x0d);
	put_char(0x0a);
}

byte get_char() {
	return p_get_char();
}

byte get_line(byte *get_line_buf) {
	
	get_line_count = 0;
	
	while(1) {
		get_line_c = get_char();
		
		if (get_line_c == 0) continue;	// zero means "no data"
		
		// Check for end character
		if ((get_line_c == 0x0a) || (get_line_c == 0x0d)) break;
		
		// Store in given buffer
		get_line_buf[get_line_count++] = get_line_c;
	}
	
	//*get_line_buf = 0;	// Terminate string
	get_line_buf[get_line_count] = 0;
	
	return get_line_count;
}

//////////////////// Utils


void delay_0x1fff() {
	// Used for screen functions (after putting stuff to ports 0x0a or 0x0b)
	#asm
		push	hl
		ld	hl, 1fffh
	_delay_1fff_loop1:
		dec	l
		jr	nz, _delay_1fff_loop1
		dec	h
		jr	nz, _delay_1fff_loop1
		pop	hl
	#endasm
}
void delay_0x010f() {
	// Used for screen functions (after putting stuff to ports 0x0a or 0x0b)
	#asm
		push	hl
		ld	hl, 010fh
	_delay_010f_loop1:
		dec	l
		jr	nz, _delay_010f_loop1
		dec	h
		jr	nz, _delay_010f_loop1
		pop	hl
	#endasm
}

void delay(word cycles) {
	#asm
		;pop	bc
		;pop	hl	; text
		;push	hl
		;push	bc
	
		push	hl
		push	af
		_delay_loop:
			dec	hl
			ld	a,h
			or	l
			jr	nz, _delay_loop
		pop	af
		pop	hl
	#endasm
}

byte hexDigit(byte c) {
	if (c < 10)
		return ('0'+c);
	return 'A' + (c-10);
}

byte parse_hexDigit(byte c) {
	if (c > 'f') return 0;
	
	if (c < '0') return 0;
	if (c <= '9') return (c - '0');
	
	if (c < 'A') return 0;
	if (c <= 'F') return (10 + c - 'A');
	
	if (c < 'a') return 0;
	return (10 + c - 'a');
}
byte parse_hex8(byte *text) {
	return parse_hexDigit(*text++) * 0x10 + parse_hexDigit(*text);
}
word parse_hex16(byte *text) {
	return
		(word)(parse_hexDigit(*text++)) * 0x1000 +
		(word)(parse_hexDigit(*text++)) * 0x0100 +
		(word)(parse_hexDigit(*text++)) * 0x0010 +
		(word)(parse_hexDigit(*text))   * 0x0001
	;
}



void put_hex8(byte c) {
	put_char(hexDigit(c >> 4));
	put_char(hexDigit(c & 0x0f));
}

void put_hex16(word d) {
	put_hex8(d >> 8);
	put_hex8(d & 0xff);
}


//////////////////// LCD

void cursor_reset() {
	// Clear cursor
	// Hides the cursor, moves to upper left, sets to "insert" mode (auto-increment position after character has been written to port 0x0b)
	#asm
		di
		xor	a
		ld	(0dcedh),a
		ld	(0dceeh),a
		ld	(0dcefh),a
		ld	(0dcf0h),a	; This also refreshes row 0 on MODEL 4000, because that is its refresh-location! (fo..f3)
		ei
	#endasm
}

void cursor_update() {
	
	cursor_ofs = cursor_row * screen_cols + cursor_col;
	
	switch (sys_type) {
		case 2:
			LCD_CURSOR_MODE_MODEL2000 = 1;	// Show cursor (0=off, 1=block 2=line)
			//LCD_CURSOR_COL_MODEL2000 = cursor_col;
			LCD_CURSOR_COL_MODEL2000 = cursor_col + 0x40*cursor_row;
		
		case 3:
			LCD_CURSOR_MODE_MODEL4000 = 1;	// Show cursor
			LCD_CURSOR_COL_MODEL4000 = cursor_col;
			LCD_CURSOR_ROW_MODEL4000 = cursor_row;
			break;
	}
	
}

void screen_refresh_all() {
	switch(sys_type) {
		case 2:
			// Refresh both lines on MODEL2000
			LCD_REFRESH_ROW0_MODEL2000 = 0x01;
			LCD_REFRESH_ROW1_MODEL2000 = 0x01;
			return;
		
		case 3:
			// Refresh all 4 lines on MODEL4000
			LCD_REFRESH_ROW0_MODEL4000 = 0x01;
			LCD_REFRESH_ROW1_MODEL4000 = 0x01;
			LCD_REFRESH_ROW2_MODEL4000 = 0x01;
			LCD_REFRESH_ROW3_MODEL4000 = 0x01;
			return;
	}
}


void screen_refresh_row(byte row) {
	// Refresh both lines on MODEL2000
	switch(sys_type) {
		case 2:
			LCD_REFRESH_ROWS_MODEL2000[row] = 0x01;
			return;
		case 3:
			LCD_REFRESH_ROWS_MODEL4000[row] = 0x01;
			return;
	}
}

void screen_scroll() {
	// Scroll all lines up by one
	//beep();
	
	//@FIXME: Something is still wrong here. When accessing VRAM too fast, odd things happen. Inserting a delay fixes a lot!
	
	#asm
		di
		push de
		push hl
		push bc
		push af
	
		; Move everything up by one row
		ld	bc, (_screen_scrollSize)
		ld	hl, _LCD_VRAM_ROW1
		ld	de, _LCD_VRAM_ROW0
		ldir	; Copy BC chars from (HL) to (DE)
		
		
		; DE should already be at the right position
		ld	h, d
		ld	l, e
		
		;ld	hl, _LCD_VRAM_ROW0
		;ld	de, (_screen_scrollSize)
		;add	hl, de
		
		; HL is now at the beginning of the last row
		
		ld	bc, (_screen_cols)		; Number of chars
		xor c
		
		ld	a, 0x20					; Which char to use: SPACE
		
		; Set B bytes at HL
		_screen_scroll_clear_loop:
			ld	(hl), a
			inc	hl
		djnz _screen_scroll_clear_loop
		
		pop af
		pop bc
		pop hl
		pop de
		ei
	#endasm
	
	// Refresh screen
	//screen_refresh_all();
	//delay_0x1fff();
}

void screen_put(byte *text) {
	cursor_ofs = cursor_row * screen_cols + cursor_col;
	
	// Repeat until end-of-string:
	while (1) {
		
		//screen_c = *put_text_p;
		screen_c = *text;
		if (screen_c == 0) break;	// End of string
		
		// New line or on the full right?
		// Normally: \n = 0x0a = LF and \r = 0x0d = CR. But this compiler maps "\r" to 0x0a and "\n" to 0x0d!!!!!
		//if ((screen_c == 0x0a) || (screen_c == 0x0d)) {	// LF / CR
			
		// New line or on the full right?
		if (screen_c == 0x0d) {	// CR
			screen_refresh_row(cursor_row);
			cursor_col = 0;
			cursor_ofs = cursor_row * screen_cols + cursor_col;
		} else
		if (screen_c == 0x0a) {	// LF
			screen_refresh_row(cursor_row);
			// New line
			cursor_row++;
			if (cursor_row >= screen_rows) {
				// Already at the bottom: Scroll!
				screen_scroll();
				
				// Stay at the last line
				cursor_row = screen_rows-1;
			}
			#ifdef CR_ON_LF
				cursor_col = 0;	// Auto-Carriage Return on Line Feed?
			#endif
			cursor_ofs = cursor_row * screen_cols + cursor_col;
		} else {
			
			// Put the char on screen
			LCD_VRAM[cursor_ofs++] = screen_c;
			cursor_col++;
			//screen_refresh_row(cursor_row);
			
			if (cursor_col >= screen_cols) {
				cursor_row++;
				if (cursor_row >= screen_rows) {
					screen_scroll();
					cursor_row = screen_rows-1;
				}
				cursor_col = 0;
				cursor_ofs = cursor_row * screen_cols + cursor_col;
			}
		}
		
		text++;
	}
	
	// Refresh current line
	if (cursor_col > 0) screen_refresh_row(cursor_row);
	cursor_update();
}


void screen_put_char(byte c) {
	
	// New line or on the full right?
	if (c == 0x0d) {	// CR
		screen_refresh_row(cursor_row);
		cursor_col = 0;
		cursor_ofs = cursor_row * screen_cols + cursor_col;
	} else
	//if ((c == 0x0a) || (c == 0x0d)) {	// nlLF/CR
	if (c == 0x0a) {	// LF
		screen_refresh_row(cursor_row);
		// New line
		cursor_row++;
		if (cursor_row >= screen_rows) {
			// Already at the bottom: Scroll!
			screen_scroll();
			
			// Stay at the last line
			cursor_row = screen_rows-1;
		}
		#ifdef CR_ON_LF
			cursor_col = 0;	// Auto-Carriage Return on Line Feed?
		#endif
		cursor_ofs = cursor_row * screen_cols + cursor_col;
	} else {
		// Put the char on screen
		LCD_VRAM[cursor_ofs++] = c;
		cursor_col++;
		// Refresh current line
		screen_refresh_row(cursor_row);
		
		if (cursor_col >= screen_cols) {
			cursor_col = 0;
			cursor_row++;
			if (cursor_row >= screen_rows) {
				screen_scroll();
				cursor_row = screen_rows-1;
			}
			cursor_ofs = cursor_row * screen_cols + cursor_col;
		}
	}
	
	cursor_update();
}




/*
void put_direct(char *text) {
	// Just slab 20 bytes of data into the VRAM
	#asm
		pop	bc
		pop	hl	; text in HL now
		push	hl
		push	bc
		
		push	de
		push	bc
		ld	de, _LCD_VRAM_ROW0
		ld	bc, (_screen_cols)
		xor c
		ldir	; Copy BC bytes from (HL) to (DE)
		pop	bc
		pop	de
	#endasm
}
*/

void screen_reset() {
	// Restores sane LCD state
	// at 0321:
	delay_010f(); delay_010f();
	out_0x0a(0x38); delay_010f(); delay_010f();	// delay 0x330 in total
	out_0x0a(0x38); delay_010f(); delay_010f();	// delay 0x330 in total
	out_0x0a(0x38); delay_010f(); delay_010f();	// delay 0x330 in total
	out_0x0a(0x38); delay_010f(); delay_010f();	// delay 0x330 in total
	
	out_0x0a(0x0f);
	out_0x0a(0x0e);
	out_0x0a(0x0c);
	
	out_0x0a(0x01);
	
	out_0x0a(0x06);
	out_0x0a(0x04);
	out_0x0a(0x01); delay_010f(); delay_010f();	// delay 0x330 in total
	
	out_0x0a(0x02); delay_010f(); delay_010f();	// delay 0x330 in total
	
	// First byte is missing if we do not delay enough
	delay_010f();
	
	
	//@TODO: Also blank out by putting C0+c and 80+c to ports 0x0a and 0x0b
	
}

void screen_clear() {
	
	//screen_reset();
	out_0x0a(0x01); delay_010f(); delay_010f();
	
	// Blank out memory
	#asm
		push hl
		push bc
		
		ld	hl, _LCD_VRAM_ROW0
		ld	bc, (_screen_size)		; Number of chars
		ld	a, 0x20					; Which char to use: SPACE
		_screen_clear_loop:
			ld	(hl), a
			inc	hl
		djnz _screen_clear_loop
		
		pop bc
		pop hl
	#endasm
	
	screen_refresh_all();
	
	
	// First byte gets lost else
	delay_010f();
	//put_char('#');	// This gets lost after screen_reset...
	
	cursor_col = 0;
	cursor_row = 0;
	cursor_ofs = 0;
	
	cursor_update();
}




void key_caps_on() {
	// Turns on caps lock LED
	// Cursor on
	// a = 0x00 / 0x20
	// Depends on the value of (0dce7h). If it is 0x01, also perform:
	// a = 0x08 / 0x28
	#asm
		;ld	a, 20h
		
		in	a, (12h)
		or	20h
		
		out	(12h), a
	#endasm
}

void key_caps_off() {
	#asm
		;ld	a, 0h
		in	a, (12h)
		and	0dfh
		out	(12h), a
	#endasm
}


void key_reset() {
	#asm
		ld	a, 0fh
		out	(0ah), a
	#endasm
	delay_0x010f();
	
	#asm
		ld	a, 0eh
		out	(0ah), a
	#endasm
	delay_0x010f();
	
	#asm
		ld	a, 0ch
		out	(0ah), a
	#endasm
	delay_0x010f();
	
	delay_0x1fff();
	delay_0x1fff();
}


byte key_get_char() {
	
	switch(sys_type) {
		case 2:	// MODEL2000
			#asm
				push af
				
				ld	a, 0c0h
				ld	(_KEY_STATUS_MODEL2000), a	; Prepare next getkey (2000)
				
				; Wait for key press
				_key_get_loop_MODEL2000:
					ld	a, (_KEY_STATUS_MODEL2000)
					cp	0d0h
				jr	nz, _key_get_loop_MODEL2000
				
				; Get current key
				ld	a, (_KEY_CURRENT_MODEL2000)
				
				; Set return value
				ld	h, 0
				ld	l, a
				pop af
				ret
			#endasm
		
		case 3:	// MODEL4000
			#asm
				push af
				
				ld	a, 0c0h
				ld	(_KEY_STATUS_MODEL4000), a	; Prepare next getkey (4000)
				
				; Wait for key press
				_key_get_loop_MODEL4000:
					ld	a, (_KEY_STATUS_MODEL4000)
					cp	0d0h
				jr	nz, _key_get_loop_MODEL4000
				
				; Get current key
				ld	a, (_KEY_CURRENT_MODEL4000)
				
				; Set return value
				ld	h, 0
				ld	l, a
				pop af
				ret
			#endasm
	}
	
	return 0x00;
}



void key_peek_arm() {
	// Arm the system to detect next key
	
	switch(sys_type) {
		case 2:	// MODEL2000
			#asm
				push af
				ld	a, 0c0h
				ld	(_KEY_STATUS_MODEL2000), a	; Prepare next getkey (2000)
				pop af
				ret
			#endasm
		
		case 3:	// MODEL4000
			#asm
				push af
				ld	a, 0c0h
				ld	(_KEY_STATUS_MODEL4000), a	; Prepare next getkey (4000)
				pop af
				ret
			#endasm
	}
	return;
}

byte key_peek_char() {
	// Check (and return) the pressed key (or 0 if none pressed)
	
	switch(sys_type) {
		case 2:	// MODEL2000
			#asm
				push af
				
				ld	h, 0
				ld	l, 0
			
				; Check for key press
				ld	a, (_KEY_STATUS_MODEL2000)
				cp	0d0h
				jr	nz, _key_peek_char_done_MODEL2000
				
				; Get current key
				ld	a, (_KEY_CURRENT_MODEL2000)
				ld	l, a
				
				_key_peek_char_done_MODEL2000:
				pop af
				ret
			#endasm
		
		case 3:	// MODEL4000
			#asm
				push af
				
				ld	h, 0
				ld	l, 0
				
				; Check for key press
				ld	a, (_KEY_STATUS_MODEL4000)
				cp	0d0h
				jr	nz, _key_peek_char_done_MODEL4000
				
				; Get current key
				ld	a, (_KEY_CURRENT_MODEL4000)
				ld	l, a
				
				_key_peek_char_done_MODEL4000:
				pop af
				ret
			#endasm
	}
	
	return 0x00;
}



void port_put(char *text) {
	
	// Output text using port access
	
	#asm
		; Get argument from stack:
		pop	bc
		pop	hl	; text
		push	hl
		push	bc
		
		
		push bc	; Used for counting here
		_put_port_loop:
			; Load current char
			ld	a, (hl)	
			
			; Check if zero (end of string)
			cp	0
			jr	z, _put_port_end	; Jump to end if so
			
			; Actually output via port
			out	(0bh), a
			
			; now delay 0x1fff
			ld	bc, 1fffh
			_put_port_delay_1fff_loop:
				dec	c
				jr	nz, _put_port_delay_1fff_loop
				dec	b
				jr	nz, _put_port_delay_1fff_loop
			
			; go to next byte
			inc	hl
		jr	_put_port_loop
		
		_put_port_end:
		pop bc
		
	#endasm
}


void sound(word frq, word len) {
	// Perform a beep (frq is actually a delay...)
	#asm
		di
		pop	bc
		pop	de	; len
		pop	hl	; frq
		push	hl
		push	de
		push	bc
		
		
	
		push	hl
		push	de
		push	bc
		
		_sound_loop:
			; Speaker on
			ld	a, 8h	; +20h
			out	(12h), a
			call _sound_delay
			
			; Speaker off
			ld	a, 0h	; +20h
			out	(12h), a
			call _sound_delay
		
		dec	e
		jr	nz, _sound_loop
		dec	d
		jr	nz, _sound_loop
		jr _sound_end
		
		_sound_delay:
			push    hl
			push    af
			_sound_delay_loop:
				dec	hl
				ld	a,h
				or	l
				jr	nz, _sound_delay_loop
			pop     af
			pop     hl
		ret
		
		
		
	_sound_end:
		pop	bc
		pop	de
		pop	hl
		ei
	#endasm
}

void sound_note(word n, word len) {
/*
	//Original notes from firmware:
		case	0:	y = 0x015d;	x = 0x00c2; break;
		case	1:	y = 0x0168;	x = 0x00ac; break;
		case	2:	y = 0x016f;	x = 0x00a2; break;
		case	3:	y = 0x017c;	x = 0x0090; break;
		case	4:	y = 0x018c;	x = 0x0080; break;
		case	5:	y = 0x019d;	x = 0x0072; break;
		case	6:	y = 0x01a7;	x = 0x006b; break;
*/
	
/*
	// Dynamic 16-bit int
	x = 0x0090;	// Base frequency
	switch(d % 12) {
		case 0:	x = (x * 256) >> 8	break;
		case 1:	x = (x * 241) >> 8	break;
		case 2:	x = (x * 228) >> 8	break;
		case 3:	x = (x * 215) >> 8	break;
		case 4:	x = (x * 203) >> 8	break;
		case 5:	x = (x * 191) >> 8	break;
		case 6:	x = (x * 181) >> 8	break;
		case 7:	x = (x * 170) >> 8	break;
		case 8:	x = (x * 161) >> 8	break;
		case 9:	x = (x * 152) >> 8	break;
		case 10:	x = (x * 143) >> 8	break;
		case 11:	x = (x * 135) >> 8	break;
		case 12:	x = (x * 128) >> 8	break;
	}
*/
	
	// My own, working great!
	switch(n % 12) {
		case 0:	frq = 0x0900;	break;
		case 1:	frq = 0x087e;	break;
		case 2:	frq = 0x0804;	break;
		case 3:	frq = 0x0791;	break;
		case 4:	frq = 0x0724;	break;
		case 5:	frq = 0x06be;	break;
		case 6:	frq = 0x065d;	break;
		case 7:	frq = 0x0601;	break;
		case 8:	frq = 0x05ab;	break;
		case 9:	frq = 0x0559;	break;
		case 10:	frq = 0x050d;	break;
		case 11:	frq = 0x04c4;	break;
	}
	
	frq = frq >> (n/12);
	len = 0x0100 + (len / frq);	// Length according to delay
	sound(frq, len);
}

void beep() {
	//sound(0x0303, 0x011f);
	sound_note(12*3 + 0, 0x2000);
}



byte sys_getType() {
	
	// Returns 2 for MODEL2000, 3 for MODEL4000
	
	
	// checkArchitecture1(): Check 10x byte at [0038 + x*3]. If all are 0xc3 return A=3, else return A=2
	#asm
		push	bc
		push	de
		push	hl
	
		ld	de, 3h
		ld	b, 0ah
		ld	hl, _SYSTEM_ARCHITECTURE_0038
		
		_ca1_loop:
			ld	a, (hl)
			cp	0c3h	; check if [HL] == 0xc3	(This is the case for MODEL2000 and MODEL4000)
			jr	nz, _ca1_ret2	; if not: set a:=2 and return
			add	hl, de	; increment by 3
		djnz	_ca1_loop
		
		; They have all evaluated to 0xc3
		ld	a, 03h	; set a:=3
		jr	_ca1_retA
		
		_ca1_ret2:
		ld	a, 02h
		
		_ca1_retA:
		pop	hl
		pop	de
		pop	bc
		
		;ret
		
		; Store result
		xor	h
		ld	l, a
	#endasm
	
	// checkArchitecture2(A): call checkArchitecture3_A2/3 accordingly
	#asm
		push	af
		push	hl
		; The next check depends on the previous result (A=2 or A=3)
		cp	02h
		jr	z, _ca3A2	; if a == 2: checkArchitecture3_A2(): Probe CPU and ROM, continue at checkArchitecture5()
		call	_ca3A3	; checkArchitecture3A3(): Set A to ([0x0006] & 0x7f >> 4)
		jr	_ca5
	#endasm
	
	// checkArchitecture3_A2(): Probe CPU and ROM, continue at checkArchitecture5()
	#asm
		_ca3A2:
			call	_ca4A2	; checkArchitecture4_A2(): Probe CPU (out (0x01), 0x01), check [0x4003]: Return A=1 for 0x02 and A=2 for 0x01 else A=that value
			jr	_ca5	; checkArchitecture5(): Probe ROM header, reset if 0x801e <> A
	#endasm

	// checkArchitecture3_A3(): Set A to ([0x0006] & 0x7f >> 4)
	#asm
		_ca3A3:
			ld	a, (_SYSTEM_ARCHITECTURE_0006)
			and	7fh
			srl	a
			srl	a
			srl	a
			srl	a
		ret
	#endasm
	
	
	// checkArchitecture4_A2(): Probe CPU (out (0x01), 0x01), check [0x4003]: Return A=1 for 0x02 and A=2 for 0x01 else A=that value
	#asm
		_ca4A2:
			push	hl
			ld	hl, _SYSTEM_ARCHITECTURE_4000
			ld	a, 01h	; out 0x01, 0x01: Get model? language?
			out	(01h), a
			push	bc
			ld	bc, 0003h
			add	hl, bc
			pop	bc
			ld	a, (hl)	; get value at 0x4003
			cp	02h
			jr	z, _ca4A2_ret1	; return 1
			cp	01h
			jr	z, _ca4A2_ret2	; return 2
			jr	_ca4A2_retA	; break
			
		_ca4A2_ret1:
			ld	a,01h
			jr	_ca4A2_retA	; break
			
		_ca4A2_ret2:
			ld	a,02h
			
		_ca4A2_retA:
			pop	hl
		ret
	#endasm
	
	// checkArchitecture5(): Probe ROM header, reset if 0x801e <> A
	#asm
		_ca5:
			ld	hl, _SYSTEM_ARCHITECTURE_801E	; This is inside the header at the beginning of the ROM, Right after the PC-PROGCARD-text
			cp	(hl)
			jp	nz,0000h	; reset if [801e] > 0 (it is in fact 01h)
			pop	hl
			pop	af
		
		_ca_end:
			; Store result
			xor	h
			ld	l, a
	#endasm
}


void sys_halt() {
	// As seen in MODEL4000 ROM 0181
	#asm
		ld	a, 1
		out	(0ah), a
		
		ld	a, 1
		out	(12h), a
		halt
	#endasm
}

void sys_reboot() {
	#asm
		ld	a, 0
		out	(03h), a
	#endasm
}


void vtech_init() {
	
	p_put = screen_put;
	p_put_char = screen_put_char;
	p_get_char = key_get_char;
	
	sys_type = 0;
	
	screen_cols = 20;
	screen_rows = 1;
	
	// Determine the system architecture so we know how to output stuff
	sys_type = sys_getType();
	
	switch(sys_type) {
		case 2:	// MODEL2000
			screen_rows = 2;
			break;
		
		case 3:	// MODEL4000
			screen_rows = 4;
			break;
	}
	
	screen_size = screen_cols * screen_rows;
	screen_scrollSize = screen_cols * (screen_rows-1);
	
	cursor_col = 0;
	cursor_row = 0;
	cursor_ofs = 0;
	
	//screen_reset();
}