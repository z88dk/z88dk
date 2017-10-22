/*
 *	Debug Console
 *
 * 2017-10-01 Bernhard "HotKey" Slawik
 */

//#define USE_PRINTER
//#define USE_SOFTSERIAL
//#define USE_EXT


#include <stdio.h>
#include <string.h>	// for strlen
#include <sound.h>

#define IOCTL_OTERM_PAUSE 0xc042	// defined in target's auto-generated h file
#define IOCTL_OTERM_CLS 0x0102	// defined in target's auto-generated h file
#include <sys/ioctl.h>

#define byte unsigned char
#define word unsigned int
#define INPUT_SIZE 64
#define DUMP_SIZE 16
#define CMD_SIZE 16
// Access to all of the memory
extern byte memory[0x10000] @ 0x0000;

// ASM interfacing bytes
extern word c	@ 0xc600;
extern word x	@ 0xc602;
extern word y	@ 0xc604;

void cls() {
	ioctl(1, IOCTL_OTERM_CLS);
}

// Little helpers
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


//@TODO: Variable input stream
byte* getInput() {
	static byte result[INPUT_SIZE];
	putchar('>');
	if (!fgets(result, sizeof(result), stdin)) {
		//exit(1);
	}
	
	result[strlen(result) - 1] = '\0';
	return result;
}

//@TODO: Variable output stream
byte handle(byte *input) {
	// Handle
	byte cmd[CMD_SIZE];
	byte *p;
	//byte c;
	word l;
	word i;
	//word x;
	//word y;
	
	// Find cmd string
	l = strlen(input);
	if (l == 0) {
		return 0;
	}
	
	p = strchr(input, ' ');
	if (p == 0) {
		//strlcpy(cmd, input, strlen(input) + 1);	// including \0
		p = input + l;
	}
	strlcpy(cmd, input, (p-input) + 1);	// including \0
	strupr(cmd);	// uppercase it
	//strlwr(cmd);	// lowercase it
	
	#define cmd_is(STRING) (strcmp(cmd, "STRING") == 0)
	#define put(STRING) printf(STRING)
	#define put_hex8(INT) printf("%02X", INT)
	#define put_hex16(INT) printf("%04X", INT)
	
	if (strcmp(cmd, "HELP") == 0) {
		printf("This is all the help you get.\n");
		
	} else
	/*
	if (cmd_is("TEST")) {
		
		for(i = 0; i < 160; i++) {
			memory[0xdcef] = i;
			bit_beep(100, 880);
		}
		
	} else
	*/
	if (cmd_is("BEEP")) {
		bit_beep(100, 880);
		
	} else
	if (cmd_is("CLS")) {
		cls();
		
	} else
	if (cmd_is("SOUND")) {
		x = parse_hex16(&input[6]);
		bit_beep(200, x);
		
	} else
	if (cmd_is("PEEK")) {
		x = parse_hex16(&input[5]);
		c = memory[x];
		printf("(%04X) = %02X\n", x, c);
		
	} else
	if (cmd_is("POKE")) {
		x = parse_hex16(&input[5]);
		c = parse_hex8(&input[10]);
		printf("(%04X) := %02X\n", x, c);
		memory[x] = c;
		
	} else
	if (cmd_is("DUMP")) {
		x = parse_hex16(&input[5]);
		printf("%04X: ", x);
		for (i = 0; i < DUMP_SIZE; i++) {
			c = memory[x+i];
			printf("%02X", c);
		}
		printf("\n");
		
	} else
	if (cmd_is("INJECT")) {
		// Put data into memory
		if (l < (6+1+4+1+2)) {
			printf("Too less data\n");
			return;
		}
		x = parse_hex16(&input[7]);
		i = 6+1+4+1;
		while (i < l) {
			// Get one byte
			c = parse_hex8(&input[i]);
			// Put one byte
			memory[x] = c;
			// Next
			i += 2;	// next 2-digit-hex
			x += 1;	// next memory location
		}
		return;
	} else
	
	if (cmd_is("CALL")) {
		x = parse_hex16(&input[5]);
		
		//@TODO: Optional: Specify register values!
		//e.g. CALL 2C80 AA BB CC DD EE HH LL STACK STACK STACK...
		
		put("CALL ");
		put_hex16(x);
		put("...\n");
		
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
		
	} else
	
	if (cmd_is("OUT")) {
		x = parse_hex8(&input[4]);
		c = parse_hex8(&input[7]);
		printf("OUT (%02X) := %02X\n", x, c);
		//__builtin_out16(x, y);
		
		#asm
			ld hl, (_x)
			ld c, l
			ld a, (_c)
			out (c), a
		#endasm
		
	} else
	if (cmd_is("INP")) {
		x = parse_hex8(&input[4]);
		#asm
			ld hl, (_x)
			ld c, l
			in a, (c)
			ld (_c), a
		#endasm
		printf("INP (%02X) = %02X\n", x, c);
		
	} else


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
	
	
	{
		printf("UNKNOWN \"%s\"\n", cmd);
	}
}


main() {
	static byte run;
	static byte* input;			// User's input
	
	printf("Genius Leader DEBUG\n");
	//printf("2017 Bernhard Slawik");
	//getchar();
	
	
	run = 1;
	while(run > 0) {
		
		input = getInput();
		handle(input);
		
	}
}
