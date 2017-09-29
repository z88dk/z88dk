#define VAR_START 0xc000

#define VAR_START_VTECH VAR_START
#include <vtech.h>

#define VAR_START_SERIAL VAR_START + 32
#include <softserial.h>

#define VAR_START_USER VAR_START + 40
extern byte c				@ (VAR_START_USER + 0);
extern byte serBufLen			@ (VAR_START_USER + 2);
extern byte keyBufLen			@ (VAR_START_USER + 4);

#define MAX_BUF_LEN 256
extern byte serBuf[MAX_BUF_LEN]		@ (VAR_START_USER + 6);
extern byte keyBuf[MAX_BUF_LEN]		@ (VAR_START_USER + 6 + MAX_BUF_LEN);

main() {
	
	vtech_init();	// Checks for system architecture and sets up stuff
	
	screen_reset();	// Especially when you compile in "rom_autorun" mode (where the screen is not yet properly initialized)
	
	key_reset();
	
	screen_clear();	// Clear screen (contains garbage left in RAM)
	
	put("VTECH Terminal");
	put("\n2017 B HotKey Slawik");
	beep();
	
	key_peek_arm();	// Arm the system to detect next key
	keyBufLen = 0;
	
	while(1) {
		
		// Poll serial port
		
		// Receive data
		//cmd_len = serial_get_line(&cmd[0]);
		c = serial_get_char();
		while (c != 0) {
			// Output each byte to screen (slow)
			//put_char(c);
			
			// Buffer it
			serBufLen = 0;
			while ((serBufLen < MAX_BUF_LEN) && (c != 0)) {
				serBuf[serBufLen++] = c;
				c = serial_get_char();
			}
			serBuf[serBufLen] = 0;	// Terminate
			// Put to screen
			put(&serBuf[0]);
		}
		
		
		// Check for keyboard input
		//c = key_get_char();
		c = key_peek_char();
		if (c != 0) {
			// Store key
			keyBuf[keyBufLen++] = c;
			
			// Send it
			keyBuf[keyBufLen] = 0;	// Terminate string
			serial_put(&keyBuf[0]);
			
			keyBufLen = 0;
			key_peek_arm();	// Arm the system to detect next key
		}
		
		
	}
}

