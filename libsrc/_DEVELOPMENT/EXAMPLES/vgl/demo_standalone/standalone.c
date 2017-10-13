/*

A "hand crafted" V-Tech ROM that does not depend on stdlib
(You can remove the stdlib include and printf's and substitute them with put() )

Mostly done via reverse-engineering
2017-01-08 Bernhard "HotKey" Slawik

*/

// Where should we keep the variables? You can #define this prior to including this header to overwrite its default
#define VAR_START 0xc000

#define VAR_START_VTECH VAR_START
#include "vtech.h"
#define VAR_START_USER (VAR_START_VTECH + VAR_SIZE_VTECH)



unsigned char buffer[100];
unsigned char c;
unsigned char i;

void pause() {
	beep();
	for(i=0; i<10; i++) {
		delay_1fff();
	}
}

void main(void) {
	
	vtech_init();	// Checks for system architecture and sets up stuff
	
	screen_reset();	// Especially when you compile in "rom_autorun" mode (where the screen is not yet properly initialized)
	
	cursor_reset();
	//key_reset();
	
	screen_clear();	// Clear screen (contains garbage left in RAM). Cursor will NOT show if not done!
	
	
	beep();
	for (c = 0; c < 160; c++) {
		screen_put_char(0x40 + (c % 26));
		//MEMORY[0xdca0 + c] = 0x40 + (c % 26);
		//screen_refresh_all();
		delay_1fff();
	}
	
	put("STAND");	pause();
	put("ALONE");	pause();
	put("STAND");	pause();
	put("ALONE");	pause();
	put("STAND");	pause();
	put("ALONE");	pause();
	put("\n");
	pause();
	put("2017 B HotKey Slawik");
	pause();
	beep();
	key_get_char();
	put("\n");
	
	//sprintf(buffer, "%d", 123); printf(buffer); pause();
	//printf("New\nLine");
	//pause();
	
	//for (c=0; c<10; c++) { printf("ABC"); pause(); }
	
	//key_peek_arm();	// Arm the system to detect next key
	
	//gets(buffer);
	//printf("\"%s\"", buffer);
	c = 10;
	
	while(1) {
		
		put_char('>');
		
		
		//c = getc(stdin);	// stdio (experimental)
		//c = getchar();	// stdio (experimental)
		c = key_get_char();
		
		//put_char(c);
		//sprintf(buffer, "%d:\"%c\"\n", c, c);
		//put(buffer);
		put("0x"); put_hex8(c);
		put(": \""); put_char(c); put("\"\n");
	}
	
	
	//sprintf(buffer, "Hello World\n");
}
