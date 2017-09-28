#include <stdio.h>
#include <sound.h>

unsigned char buffer[100];
unsigned char c;
unsigned char i;

#define IOCTL_OTERM_PAUSE 0xc042	// defined in target's auto-generated h file

/*
#define __VGL_KEY_STATUS_ADDRESS  0xdb00
#define __VGL_KEY_CURRENT_ADDRESS  0xdb01

#define __VGL_DISPLAY_COLS  20
#define __VGL_DISPLAY_ROWS  4
#define __VGL_DISPLAY_CONTROL_PORT  0x0a
#define __VGL_DISPLAY_REFRESH_ADDRESS  0xdcf0
#define __VGL_DISPLAY_CURSOR_X_ADDRESS  0xdcf4
#define __VGL_DISPLAY_CURSOR_Y_ADDRESS  0xdcf5
#define __VGL_DISPLAY_CURSOR_MODE_ADDRESS  0xdcf6
#define __VGL_DISPLAY_CLEAR_ADDRESS  0xdcf7
#define __VGL_VRAM_ADDRESS_START  0xdca0

#define __VGL_SYSTEM_ARCHITECTURE_0006 0x0006
#define __VGL_SYSTEM_ARCHITECTURE_0038 0x0038
#define __VGL_SYSTEM_ARCHITECTURE_4000 0x4000
#define __VGL_SYSTEM_ARCHITECTURE_801E 0x801E

#define __VGL_DISPLAY_CURSOR_OFFSET_MODEL2000 0xdcef		// Current column + 64*row
#define __VGL_DISPLAY_CURSOR_MODE_MODEL2000 0xdced		// Show cursor (0=off, 1=block 2=line)
*/

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
void delay() {
	for(i = 0; i < 50; i++) {
		for (c = 0; c < 200; c++) {
			delay_0x010f();
		}
	}
}


void main(void) {
	
	//ioctl(1, IOCTL_OTERM_PAUSE, 0);	// Switch off "pause after page is full". Also possible on compile time via OTERM_FLAGS when unsetting bit 6 (0x0040)
	
	printf("Hello, World!\n");
	
	//delay();
	
	getchar();
	
	
	/*
	printf("Beeping...");
	bit_beep(100, 880);
	printf("!\n");
	*/
	
	printf("Enter something: ");
	gets(buffer);
	printf("You entered: \"%s\"\n", buffer);
	
	
	while(1) {
		
		printf("key>");
		
		//c = getc(stdin);
		c = getchar();
		
		sprintf(buffer, "%d:\"%c\"\n", c, c);
		printf(buffer);
	}
	
}
