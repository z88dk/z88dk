/*

Terminal Utils for the V-Tech Genius notebook

2017-03-09 Bernhard "HotKey" Slawik

*/

#define byte unsigned char
#define word unsigned short

// Where should we keep the variables? You can #define this prior to including this header to overwrite its default
#ifndef VAR_START_TERM
	// Default: 0xc000 and up
	#define VAR_START_TERM 0xc080
#endif
extern byte term_esc @ (VAR_START_TERM + 0);

#define VAR_SIZE_TERM 2


byte key_to_char(byte keyCode) {
	switch(keyCode) {
		//case KEY_ASTERISK:	return 27;
		//case KEY_BREAK:	return 0x03;	// Ctrl+C
		
		case KEY_ENTER:	return 0x0a;
		
		case KEY_REPEAT:	return 0x08;	// Ctrl+H / BACKSPACE
		case KEY_DELETE:	return 0x7f;	// Ctrl+? / DEL
		
		case KEY_HELP:	return 0x09;	// TAB
		case KEY_TAB:	return 0x09;	// TAB
	}
	return keyCode;
}

byte char_to_screen(byte charCode) {
	
	// Handle Escape sequences
	if (term_esc == 1) {
		
		// https://de.wikipedia.org/wiki/ANSI-Escapesequenz#Control_Sequence_Intro
		if (charCode == 0x5b)	{	// Bracket
			// Start <ESC>[ Control Sequence
			term_esc = 2;
			return 0;
		}
	}
	if (term_esc == 2) {
		switch(charCode) {
			case 'm':
				// End of Control sequence
				term_esc = 0;
				//@TODO: Handle control sequence!
				return 0;
			
			case 'J':
				// Back one char (backspace)
				//@TODO: Scroll rest of line to the left
				cursor_col -= 1;
				cursor_ofs = cursor_row * screen_cols + cursor_col;
				return 0;
			
			default:
				//@TODO: Gather Escape sequence parameters
				return 0;
		}
	}
	
	// Translate a char
	switch(charCode) {
		case 0x07:	beep();	// BELL
		
		case 0x0c:	return 0;	// Only CR or LF, not both
		
		case 0x1b:	// Escape character
			term_esc = 1;
			return 0;
		
	}
	return charCode;
}

void term_init() {
	term_esc = 0;
}