/*
	Penius Cheater
	
	Debug console for the V-Tech Genius Leader
	
	(C)opyright 2017 Bernhard "HotKey" Slawik
*/

// Turn this on to have nicer debug texts (uses a lot of space)
//#define FRIENDLY
//#define SHOW_HELP	// Requires "a lot" of memory for strings

// Toggle which functionalities you want include (carefully watch the resulting binary size!)
#define USE_TERM
//#define USE_SOFTSERIAL
//#define USE_PRINTER
#define USE_EXT
#define USE_MIDI
#define USE_SPI


// Do the memory layout. Since this is a ROM and we want to have mutable values we need to lay them out in the RAM regions manually
//#define VAR_START 0xc000
//#define VAR_START_VTECH VAR_START
#include <vtech.h>

#define VAR_START_TERM VAR_START_VTECH + VAR_SIZE_VTECH
#ifdef USE_TERM
	#include <term.h>
#else
	#define VAR_SIZE_TERM 0
#endif

#define VAR_START_SOFTSERIAL VAR_START_TERM + VAR_SIZE_TERM
#ifdef USE_SOFTSERIAL
	#include <softserial.h>
#else
	#define VAR_SIZE_SOFTSERIAL 0
#endif

#define VAR_START_PRINTER VAR_START_SOFTSERIAL + VAR_SIZE_SOFTSERIAL
#ifdef USE_PRINTER
	#include <printer.h>
#else
	#define VAR_SIZE_PRINTER 0
#endif

#define VAR_START_EXT VAR_START_PRINTER + VAR_SIZE_PRINTER
#ifdef USE_EXT
	#include <ext.h>
#else
	#define VAR_SIZE_EXT 0
#endif

#define VAR_START_MIDI VAR_START_EXT + VAR_SIZE_EXT
#ifdef USE_MIDI
	#include <midi.h>
#else
	#define VAR_SIZE_MIDI 0
#endif

#define VAR_START_SPI VAR_START_MIDI + VAR_SIZE_MIDI
#ifdef USE_SPI
	#include <spi.h>
#else
	#define VAR_SIZE_SPI 0
#endif

#define VAR_START_USER VAR_START_SPI + VAR_SIZE_SPI


#define MAX_CMD 255
#define PROMPT_CHAR '>'

// Local variables
// Variables need to be in RAM (starting at 0xd500) not ROM
extern byte a				@ (VAR_START_USER + 0);
extern byte b				@ (VAR_START_USER + 1);
extern byte c				@ (VAR_START_USER + 2);
extern byte d				@ (VAR_START_USER + 3);
extern byte e				@ (VAR_START_USER + 4);

extern word x				@ (VAR_START_USER + 6);
extern word y				@ (VAR_START_USER + 8);
extern word z				@ (VAR_START_USER + 10);

#define VAR_START_CMD VAR_START_USER + 12
extern byte cmd[MAX_CMD]	@ (VAR_START_CMD);
extern byte cmd_len		@ (VAR_START_CMD + MAX_CMD);
extern byte cmd_o			@ (VAR_START_CMD + MAX_CMD + 1);
extern byte str_compare_c1	@ (VAR_START_CMD + MAX_CMD + 2);
extern byte str_compare_c2	@ (VAR_START_CMD + MAX_CMD + 3);
extern byte cmd_oldC		@ (VAR_START_CMD + MAX_CMD + 4);
extern byte cmd_oldC0		@ (VAR_START_CMD + MAX_CMD + 5);
extern byte cmd_oldO		@ (VAR_START_CMD + MAX_CMD + 6);
extern byte cmd_oldLen		@ (VAR_START_CMD + MAX_CMD + 7);

#define BUF_LEN 255
extern byte buf[BUF_LEN]		@ (VAR_START_CMD + MAX_CMD + 8);

// Forwards
void cmd_handle();

void banner() {
	put("Penius CHEATER\r");
	put("by B. HotKey Slawik\r");
}

byte str_compare(byte *s1, byte *s2) {
	while (1) {
		str_compare_c1 = *s1;
		str_compare_c2 = *s2;
		
		if (str_compare_c1 != str_compare_c2)
			return 0;
		
		if ((str_compare_c1 == 0) || (str_compare_c2 == 0))
			return 1;
		
		s1++;
		s2++;
	}
}
byte str_startsWith(byte *s1, byte *sPrefix) {
	while (1) {
		str_compare_c1 = *s1;
		str_compare_c2 = *sPrefix;
		
		if (str_compare_c2 == 0)	// Prefix ended. OK!
			return 1;
		
		if (str_compare_c1 != str_compare_c2)
			return 0;
		
		s1++;
		sPrefix++;
	}
}
byte cmd_is(byte *s) {
	return str_startsWith(cmd, s);
}

void more() {
	// Pause if reached end of screen
	if (cursor_row >= screen_rows-1) {
		get_char();
		screen_clear();
	}
}

void cmd_spawn(void *np_put, void *np_put_char, void *np_get_char) {
	// Set new std in and out
	p_put = np_put;
	p_put_char = np_put_char;
	p_get_char = np_get_char;
	
	while(1) {
		
		// Breathe (give interrupts a little bit of time to do their thing)
		//delay_0x010f();
		delay_0x1fff();
		
		// Receive command
		cmd_len = get_line(&cmd[0]);
		
		// Check for EXIT
		if (cmd_is("exit")) break;
		
		// Handle that cmd
		cmd_handle();
	}
	
	// Return to keyboard and screen
	p_put = screen_put;
	p_put_char = screen_put_char;
	p_get_char = key_get_char;
}

void cmd_handle() {
	//put("cmd_handle \""); put(cmd); put("\"...\r");
	
	if (str_compare(cmd, "")) {
		// Empty? Ignore.
		return;
	}
	
	if (cmd_is("help")) {
		banner();
		
		#ifdef SHOW_HELP
			more();	put("Try those commands:\r");
			more();	put("* ver\r");	// Some info
			more();	put("* cls\r");	// Clear LCD screen
			more();	put("* loop COMMAND...\r");	// Repeat the given command infinitely
			more();	put("* halt\r");	// Halt system
			more();	put("* menu\r");	// Back to menu (not for all models)
			more();	put("* reboot\r");	// Reboot system
			
			more();	put("* peek XXXX\r");	// Get one memory cell
			more();	put("* poke XXXX YY\r");	// Set memory
			more();	put("* dump XXXX\r");	// hex dump a few bytes of memory, human readable
			more();	put("* dump2 XXXX count\r");	// Extract memory region as hex dump used for automated procedures
			more();	put("* inject XXXX HEX\r");	// Inject the given hex bytes into the given address
			more();	put("* call XXX\r");	// Call the given address (jump there)
			more();	put("* ret XX (#pops)\r");	// invoke RET (a few times)
			
			more();	put("* inp XX\r");	// Show value of port
			more();	put("* out XX YY\r");	// Output value to port
			
			more();	put("* beep\r");	// Beep
			more();	put("* sound FRQ LEN\r");
			
			more();	put("* keyget\r");	// Get and display a key
			more();	put("* screenreset\r");
			more();	put("* cursorreset\r");
			
			//more();	put("* putvram\r");
			//more();	put("* putvramloop\r");
			more();	put("* portput\r");
			
			#ifdef USE_PRINTER
			more();	put("* printerready\r");	// Check if printer is ready
			more();	put("* printerputchar XX\r");	// Put one chaacter to the printer
			more();	put("* printerputloop\r");	// Put several bytes to the printer
			#endif
			
			#ifdef USE_SOFTSERIAL
			more();	put("* serialgetchar\r");	// Get a char via bit-bang software serial over parallel port
			//more();	put("* serialgetline\r");	// Get a line of text via bit-bang software serial over parallel port
			more();	put("* serialputchar XX\r");
			more();	put("* serialput DATA\r");	// Put the given data via bit-bang software serial over parallel port
			more();	put("* serialcmd\r");	// Wait for a line of text at the bit-bang software serial port and execute it
			//more();	put("* serialdump XXXX count\r");	// Extract memory region to serial port
			#endif
			
			#ifdef USE_EXT
			more();	put("* extinit\r");
			more();	put("* extputchar XX\r");
			more();	put("* extput DATA\r");
			more();	put("* extget\r");
			more();	put("* extcmd\r");
			more();	put("* extterm\r");
			#endif
			
			#ifdef USE_MIDI
			more();	put("* midi\r");
			#endif
			
			#ifdef USE_SPI
			more();	put("* spi\r");
			#endif
			
		#else	// if SHOW_HELP
			put("Help is not compiled in!\r");
		#endif	// if SHOW_HELP
		
		
		
		more();
		return;
	}
	
	if (cmd_is("loop")) {
		// Shorten command (shift away the LOOP), call the resulting command in a loop!
		#asm
			ld	hl, _cmd	; source: cmd
			
			ld	d, h		; destination: cmd
			ld	e, l
			
			; Increment the source to the end of the "loop " command
			inc	hl	; "L"
			inc	hl	; "O"
			inc	hl	; "O"
			inc	hl	; "P"
			inc	hl	; " "
			
			ld	bc, 0x00f0	; Max length
			ldir	; Copy BC bytes from (HL) to (DE)
		#endasm
		put("LOOPING \"");
		put(cmd);
		put("\"...\r");
		while (1) {
			cmd_handle();
		}
		return;
	}
	
	if (cmd_is("halt")) {
		sys_halt();
	}
	if (cmd_is("reboot")) {
		sys_reboot();
	}
	
	if (cmd_is("ver")) {
		put("System: ");
		put_hex8(sys_type);
		put_line();
		
		put("Screen: ");
		put_hex16(screen_size);
		put_line();
		return;
	}
	
	if (cmd_is("cls")) {
		screen_clear();
		return;
	}
	
	if (cmd_is("peek")) {
		x = parse_hex16(&cmd[5]);
		#asm
			ld	hl, (_x)
			ld	a, (hl)
			ld	(_c), a
		#endasm
		put_char('(');
		put_hex16(x);
		put(") = ");
		put_hex8(c);
		put(" = \"");
		put_char(c);
		put("\"\r");
		return;
	}
	
	if (cmd_is("poke")) {
		x = parse_hex16(&cmd[5]);
		c = parse_hex8(&cmd[10]);
		
		put_char('(');
		put_hex16(x);
		put(") := ");
		put_hex8(c);
		put(" = \"");
		put_char(c);
		put_char('"');
		// *(byte *)(x) = c;
		#asm
			ld	hl, (_x)
			ld	a, (_c)
			ld	(hl), a
		#endasm
		put_line();
		return;
	}
	
	
	
	if (cmd_is("dump2")) {
		// Hex-dump
		x = 0x0000;
		y = 0x0010;
		
		if (cmd[4+1] > 0) {
			x = parse_hex16(&cmd[5+1]);
			if (cmd[9+1] > 0)
				y = parse_hex16(&cmd[10+1]);
		}
		
		z = 0;
		while (y > 0) {
			#asm
				ld	hl, (_x)
				ld	a, (hl)
				ld	(_c), a
			#endasm
			
			buf[z++] = hexDigit(c >> 4);
			buf[z++] = hexDigit(c & 0x0f);
			//put_hex8(c);	// Also on screen
			x++;
			y--;
		}
		buf[z] = 0;	// Terminate string
		put(buf);
		//put_line();
		
		return;
	}
	if (cmd_is("dump")) {
		// Hex-dump
		x = parse_hex16(&cmd[5]);
		
		//while (1) {
			put_hex16(x);
			put_char(':');
			
			for (y = 0; y < 4; y++) {
				put_char(' ');
				#asm
					ld	hl, (_x)
					ld	a, (hl)
					ld	(_c), a
				#endasm
				put_hex8(c);
				x++;
			}
			put_line();
			//c = get_char();
			//if (c == 'q') break;
		//}
		
		return;
	}
	
	
	if (cmd_is("inject")) {
		// Put data into memory
		if (cmd_len < (6+1+4+1+2)) {
			put("Too less data\r");
			return;
		}
		x = parse_hex16(&cmd[7]);
		y = 6+1+4+1;
		while (y < cmd_len) {
			// Get one byte
			c = parse_hex8(&cmd[y]);
			
			// Put one byte
			#asm
				push hl
				ld	hl, (_x)
				ld	a, (_c)
				ld	(hl), a
				pop hl
			#endasm
			
			// Next
			y += 2;	// next 2-digit-hex
			x += 1;	// next memory location
		}
		
		return;
	}
	
	if (cmd_is("menu")) {
		// For MODEL4000
		#asm
			jp 0x0f63	; Jump back to where the auto-start branched to 0x8004
		#endasm
	}
	
	if (cmd_is("call")) {
		x = parse_hex16(&cmd[5]);
		
		//@TODO: Optional: Specify register values!
		//e.g. CALL 2C80 AA BB CC DD EE HH LL STACK STACK STACK...
		
		put("CALL ");
		put_hex16(x);
		put("...\r");
		
		#asm
			ld	hl, (_x)
			
			; Trickery: Use "call" to call a label that does not return. That way the "jp" magically becomes a "call"!
			call	_call_encap	; Call but do not ret there, so PC+3 gets on stack!
			jp	_call_end		; The "jp" below should return to this instruction
			_call_encap:
				jp	(hl)	; This actually becomes a fake "call"
				; Do not ret! This is intentionally left blank
			_call_end:
		#endasm
		return;
	}
	if (cmd_is("ret")) {
		if (cmd[3] == 0)	c = 0;
		else				c = parse_hex8(&cmd[4]);
		
		put("RET ");
		put_hex8(c);
		put("...\r");
		
		#asm
			; Get the number of POPs to perform
			ld	a, (_c)
			cp	0
			jp	z, _ret_do
			
			; pop a few addresses (via parameter)
			ld	b, a
			_ret_pop_loop:
				pop ix	; Poppin!
			djnz _ret_pop_loop
			
			_ret_do:
				pop	bc
				ret		; Bang!
		#endasm
		return;
	}
	
	
	
	if (cmd_is("inp")) {
		x = parse_hex8(&cmd[4]);
		#asm
			ld	hl, (_x)
			ld	c, l
			in	a, (c)
			ld	(_c), a
		#endasm
		put_char('p');
		put_hex8(x);
		put(" = ");
		put_hex8(c);
		put(" = \"");
		put_char(c);
		put("\"\r");
		return;
	}
	
	if (cmd_is("out")) {
		x = parse_hex8(&cmd[4]);
		c = parse_hex8(&cmd[7]);
		
		put_char('p');
		put_hex8(x);
		put(" := ");
		put_hex8(c);
		put(" = \"");
		put_char(c);
		put_char('"');
		#asm
			ld	hl, (_x)
			ld	c, l
			ld	a, (_c)
			out	(c), a
		#endasm
		put_line();
		return;
	}
	
	if (cmd_is("beep")) {
		beep();
		return;
	}
	if (cmd_is("sound")) {
		if (cmd[5] == 0)	x = 0x0202;
		else				x = parse_hex16(&cmd[6]);
		
		if (cmd[10] == 0)	y = 0x011f;
		else				y = parse_hex16(&cmd[11]);
		sound(x, y);
		return;
	}
	
	if (cmd_is("keyget")) {
		put("press a key\r");
		c = key_get_char();
		put_hex8(c);
		put_char('=');
		put_char(c);
		put_line();
		return;
	}
	
	
	if (cmd_is("screenreset")) {
		screen_reset();
		return;
	}
	if (cmd_is("cursorreset")) {
		cursor_reset();
		return;
	}
	
	
	/*
	if (cmd_is("putvramloop")) {
		for(x = 0; x < 255; x++) {
			print_hex_vram(x);
		}
		return;
	}
	if (cmd_is("putvram")) {
		put_direct("Direct access to RAM");
		return;
	}
	*/
	if (cmd_is("portput")) {
		for (x = 0; x < 20*4; x++) {
			out_0x0b('a' + (x % 26));
		}
		return;
	}
	
	
	
	#ifdef USE_PRINTER
	if (cmd_is("printerready")) {
		// Wait until BUSY line is cleared (1) or timeout (0)
		put("Printer is ");
		c = printer_isReady();
		//put_hex8(c);
		if (c == 1) put("ready\r");
		else put("busy\r");
		return;
	}
	
	if (cmd_is("printerputloop")) {
		// Put 256 characters to the parallel port
		for (x = 0; x < 255; x++) {
			printer_put_char(x);
		}
		return;
	}
	if (cmd_is("printerputchar")) {
		// Put given character to printer port
		if (cmd[12] == 0)
			c = get_char();
		else
			c = parse_hex8(&cmd[13]);
		printer_put_char(c);
		return;
	}
	#endif
	
	
	#ifdef USE_SOFTSERIAL
	if (cmd_is("serialgetchar")) {
		// Get data via bit-banging the parallel port lines as if it were a 9600 baud serial port
		
		do {
			c = serial_get_char();
		} while(c == 0);
		
		put("Received ");
		put_hex8(c);
		put(" = \"");
		put_char(c);
		put("\"");
		put_line();
		
		return;
	}
	/*
	if (cmd_is("serialgetline")) {
		// Get data via bit-banging the parallel port lines as if it were a 9600 baud serial port
		
		put("Receiving...");
		c = serial_get_line(&buf[0]);
		
		//buf[c] = 0;	// Terminate string
		put_hex8(c);
		put(" bytes: \"");
		put(buf);
		put("\"\r");
		
		return;
	}
	*/
	if (cmd_is("serialput")) {
		// Send via STROBE signal (because it stays on, in contrast to the data pins that only get pulsed shortly)
		if (cmd[9] == 0) {
			put("No data.\r");
			return;
		}
		//put("Sending...");
		serial_put(&cmd[10]);
		//put_line();
		return;
	}
	
	if (cmd_is("serialcmd")) {
		// Change to serial IO
		cmd_spawn(serial_put, serial_put_char, serial_get_char);
		return;
	}
	
	/*
	if (cmd_is("serialdump")) {
		// Hex-dump
		x = 0x0000;
		y = 0x0010;
		
		if (cmd[10] > 0) {
			x = parse_hex16(&cmd[11]);
			if (cmd[15] > 0)
				y = parse_hex16(&cmd[16]);
		}
		
		z = 0;
		while (y > 0) {
			#asm
				ld	hl, (_x)
				ld	a, (hl)
				ld	(_c), a
			#endasm
			
			buf[z++] = hexDigit(c >> 4);
			buf[z++] = hexDigit(c & 0x0f);
			//put_hex8(c);	// Also on screen
			x++;
			y--;
		}
		buf[z] = 0;	// Terminate string
		serial_put(buf);
		//put(buf);
		//put_line();
		
		return;
	}
	*/
	#endif
	
	
	#ifdef USE_EXT
	if (cmd_is("extinit")) {
		ext_init();
		return;
	}
	if (cmd_is("extput")) {
		if (cmd[6] == 0) {
			put("No data.\r");
			return;
		}
		ext_put(&cmd[7]);
		return;
	}
	if (cmd_is("extputchar")) {
		// Put given character to printer port
		if (cmd[10] == 0)
			c = get_char();
		else
			c = parse_hex8(&cmd[11]);
		ext_put_char(c);
		return;
	}
	if (cmd_is("extget")) {
		put("DI=");
		put_hex8(ext_get_char());
		put_line();
		return;
	}
	
	if (cmd_is("extcmd")) {
		// Change to ext IO
		cmd_spawn(ext_put, ext_put_char, ext_get_char);
		return;
	}
	
	if (cmd_is("extterm")) {	// Initiates terminal mode on external cartridge ("BUSFICKER")
		#ifdef FRIENDLY
		put("Terminal mode...\r");
		#endif
		ext_init();	// Activate BUSFICKER
		
		term_init();	// Reset terminal state
		
		//put("ready.\r");
		key_peek_arm();	// Start polling the keyboard
		while(1) {
			// Pipe from BUSFICKER DI to screen...
			c = ext_get_char();
			if (c != 0) {
				c = char_to_screen(c);	// Translate ASCII data to V-Tech style things
				put_char(c);
			}
			
			// Pipe from keyboard to BUSFICKER DO...
			c = key_peek_char();
			if (c != 0) {
				//if (c == KEY_BREAK) break;
				
				// Local echo
				//put_char(c);
				
				c = key_to_char(c); // Translate V-Tech keys to standardized chars
				if (c != 0) {
					//@TODO: Make term.h handle multi-byte translation!
					switch(c) {
						case KEY_BREAK:	ext_put("\x1b[[");	break;	// Escape
						case KEY_CURSOR_UP:	ext_put("\x1b[A");	break;
						case KEY_CURSOR_DOWN:	ext_put("\x1b[B");	break;
						case KEY_CURSOR_LEFT:	ext_put("\x1b[C");	break;
						case KEY_CURSOR_RIGHT:	ext_put("\x1b[D");	break;
						default:
							ext_put_char(c);
					}
				}
				
				key_peek_arm();	// Re-start keyboard handler
			}
		}
		return;
	}
	#endif
	
	
	#ifdef USE_MIDI
	if (cmd_is("midi")) {
		#ifdef FRIENDLY
		put("Use keyboard or MIDI in to play\r");
		#endif
		
		midi_init();
		
		z = 3;	// Base octave
		e = 0xff;	// Old note
		
		key_peek_arm();	// Start polling the keyboard
		while(1) {
			
			// cmd, chn, note, vel
			//midi_check(&a, &b, &c, &d);
			midi_c = midi_in();
			if (midi_c > 0) {
				a = midi_c & 0xf0;
				b = midi_c & 0x0f;
				
				switch(a) {
					case 0:
						// Ignore
						break;
					
					case MIDI_CMD_SENSE:
						// Ignore
						break;
					
					case MIDI_CMD_NOTE_ON:
						//put("IN #");	put_hex8(b);
					
						put("NOTE ON");	// Need to do something to delay! Print is fine.
						c = midi_in_next();
						put(" n=");	put_hex8(c);
						d = midi_in_next();
						put(" v=");	put_hex8(d);
						put_line();
						
						if (d > 0) {
							sound_note(c, 0x2000);
						}
						break;
					
					default:
						//put("IN #");	put_hex8(b);
						//put(" c=");	put_hex8(a);
						put(" ");	put_hex8(a + b);
						//put_line();
				}
			}
			
			/*
			// Pipe from BUSFICKER DI to screen...
			c = midi_in();
			if (c != 0) {
				put("MIDI in: ");
				put_hex8(c);
				put_line();
			}
			*/
			
			// Pipe from keyboard to BUSFICKER DO...
			c = key_peek_char();
			if (c != 0) {
				
				d = 0xff;
				
				// Map keys to notes
				switch(c) {
					case KEY_BREAK:
						return;
					
					// Switch octave
					case 0xf1: if (z > 0) z --; break;
					case 0xf0: if (z < 20) z ++; break;
					
					case 0x5c:	// KILL ALL
						for (e = 0; e < 127; e++) {
							midi_noteOff(e);
						}
						break;
					
					case 0x20:
						// Note off
						if (e != 0xff) {
							midi_noteOff(e);
							e = 0xff;
						}
						break;
					
					case 'y':	d = 12*0 +  0;	break;
					case 's':	d = 12*0 +  1;	break;
					case 'x':	d = 12*0 +  2;	break;
					case 'd':	d = 12*0 +  3;	break;
					case 'c':	d = 12*0 +  4;	break;
					case 'v':	d = 12*0 +  5;	break;
					case 'g':	d = 12*0 +  6;	break;
					case 'b':	d = 12*0 +  7;	break;
					case 'h':	d = 12*0 +  8;	break;
					case 'n':	d = 12*0 +  9;	break;
					case 'j':	d = 12*0 + 10;	break;
					case 'm':	d = 12*0 + 11;	break;
					case ',':	d = 12*1 +  0;	break;
					case 'l':	d = 12*1 +  1;	break;
					case '.':	d = 12*1 +  2;	break;
					//case '-':	d = 12*1 +  4;	break;
					
					case 'q':	d = 12*1 +  0;	break;
					case '2':	d = 12*1 +  1;	break;
					case 'w':	d = 12*1 +  2;	break;
					case '3':	d = 12*1 +  3;	break;
					case 'e':	d = 12*1 +  4;	break;
					case 'r':	d = 12*1 +  5;	break;
					case '5':	d = 12*1 +  6;	break;
					case 't':	d = 12*1 +  7;	break;
					case '6':	d = 12*1 +  8;	break;
					case 'z':	d = 12*1 +  9;	break;
					case '7':	d = 12*1 + 10;	break;
					case 'u':	d = 12*1 + 11;	break;
					case 'i':	d = 12*2 +  0;	break;
					case '9':	d = 12*2 +  1;	break;
					case 'o':	d = 12*2 +  2;	break;
					case '0':	d = 12*2 +  3;	break;
					case 'p':	d = 12*2 +  4;	break;
					
					default:
						// Local echo
						put("key=");
						put_hex8(c);
						put_line();
				}
				
				// Was a key pressed?
				if (d < 0xff) {
					
					// Silence previous note
					if (e != 0xff) {
						midi_noteOff(e);
						e = 0xff;
					}
					
					d += z*12;	// Add current octave
					
					put("note=");
					put_hex8(d);
					
					// Play note via MIDI
					midi_noteOn(d);
					e = d;	// Remember old note
					
					switch(d % 12) {
						case 0:	x = 0x0900;	break;
						case 1:	x = 0x087e;	break;
						case 2:	x = 0x0804;	break;
						case 3:	x = 0x0791;	break;
						case 4:	x = 0x0724;	break;
						case 5:	x = 0x06be;	break;
						case 6:	x = 0x065d;	break;
						case 7:	x = 0x0601;	break;
						case 8:	x = 0x05ab;	break;
						case 9:	x = 0x0559;	break;
						case 10:	x = 0x050d;	break;
						case 11:	x = 0x04c4;	break;
					}
					x = x >> (d/12);
					y = 0x0100 + (0x2000 / x);	// Length according to delay
					
					put(" x=");	put_hex16(x);
					
					sound(x, y);
					
					put_line();
				}
				
				key_peek_arm();	// Re-start keyboard handler
			}
		}
		
		return;
	}
	#endif
	
	#ifdef USE_SPI
	if (cmd_is("spi")) {
		c = parse_hex8(&cmd[4]);
		
		put("out: "); put_hex8(c); put("...");	//put_line();
		
		spi_init();
		
		c = spi_do(c);
		
		put("in: "); put_hex8(c); put_line();
		
		return;
	}
	#endif
	
	
	put("Unknown \"");
	put(cmd);
	put("\"");
	beep();
	put_line();
}

main() {
	
	vtech_init();	// Checks for system architecture and sets up stuff
	
	
	// Prepare command input
	cmd_len = 0;
	cmd_o = 0;
	cmd[0] = 0;
	
	
	
	screen_reset();	// Especially when you compile in "rom_autorun" mode (where the screen is not yet properly initialized)
	
	key_reset();
	
	screen_clear();	// Clear screen (contains garbage left in RAM)
	
	banner();
	
	beep();
	//get_char();	// Wait for key
	//put_line();
	
	
	/*
	if (sys_type == 3) {
		// Check if serial is connected.
		if (serial_isReady() == 1) {
			put("Auto-serial!");
			sound(0x0440, 0x0140);
			sound(0x0330, 0x0140);
			sound(0x0220, 0x0140);
			
			//	If so: go directly into serial console mode
			serial_cmd();
			sound(0x0440, 0x0140);
			sound(0x0330, 0x0140);
			sound(0x0220, 0x0140);
			
			put_line();
		}
	}
	*/
	
	// Start console...
	put_char(PROMPT_CHAR);
	
	// Main loop
	while (1) {
		
		
		//key_caps_off();
		c = get_char();
		//key_caps_on();
		
		// Debug scan codes
		//if (reportKeyCode) put_hex(c);
		
		// Text input
		switch(c) {
			
			case KEY_HELP:
				cmd_handle("help\0");
				break;
			
			case KEY_ACTIVITY_1:
				screen_reset();
				screen_clear();
				break;
			
			case KEY_CURSOR_LEFT:
				if (cmd_o > 0) {
					cmd_o--;
					
					if (cursor_col > 0) {
						cursor_col--;
					} else {
						if (cursor_row > 0) {
							cursor_row--;
							cursor_col = screen_cols-1;
						}
					}
				}
				cursor_update();
				break;
			
			case KEY_CURSOR_RIGHT:
				
				if (cmd_o < cmd_len) {
					cmd_o++;
					
					if (cursor_col < screen_cols) {
						cursor_col++;
					} else {
						if (cursor_row < screen_rows-1) {
							cursor_row++;
							cursor_col = 0;
						}
					}
				}
				cursor_update();
				break;
			
			case KEY_CURSOR_UP:
				break;
			case KEY_CURSOR_DOWN:
				break;
			
			case KEY_ENTER:
				cmd_oldC0 = cmd[0];
				cmd_oldC = cmd[cmd_o];
				cmd_oldO = cmd_o;
				cmd_oldLen = cmd_len;
			
				cmd[cmd_len] = 0;	// Terminate string
				
				// Output
				put_line();
				
				// Handle cmd[0..cmd_len-1]
				cmd_handle();
				
				// Prompt
				put_char(PROMPT_CHAR);
				cmd_len = 0;
				cmd_o = 0;
				cmd[0] = 0;
				break;
			
			case KEY_REPEAT:
				// Repeat previous command
				cmd[0] = cmd_oldC0;
				cmd_o = cmd_oldO;
				cmd_len = cmd_oldLen;
				cmd[cmd_o] = cmd_oldC;
				cmd[cmd_len] = 0;
				put(cmd);
				//cmd_handle();
				break;
			
			default:
				// Put to stdin
				cmd[cmd_o] = c;
				if (cmd_o < MAX_CMD) cmd_o++; else beep();
				if (cmd_o > cmd_len) cmd_len = cmd_o;
				put_char(c);
		}
		
		
		
		// Function keys
		switch(c) {
			
			case 0x1e:	// LEVEL foil button
				break;
			case 0x1f:	// PLAYERS foil button
				break;
			
			case 0x01:
				screen_reset();
				screen_clear();
				break;
			
			case 0x0a:
				// Sound!
				for (z = 0; z < 200; x++) {
					if ((z % 50) == 0) put_hex8(z);
					
					x = z * 0x0010;
					y = 0xa000 - x;
					x += 0x0100;	// at least 1 in H
					
					for (z = 0; z < 40; z++) {
						#asm
							di
							push hl
							
							; Speaker on
							ld	a, 8h
							out	(12h), a
							
							; Delay 1
							ld	hl, _x
							_sound_delay1_loop:
								dec	l
								jr	nc, _sound_delay1_loop
								dec	h
								jr	nc, _sound_delay1_loop
							
							
							; Speaker off
							ld	a, 0h
							out	(12h), a
							
							; Delay 2
							ld	hl, _y
							_sound_delay2_loop:
								dec	l
								jr	nc, _sound_delay2_loop
								dec	h
								jr	nc, _sound_delay2_loop
							
							pop	hl
							ei
						#endasm
					}
				}
				break;
		}
		
	}
	
}
