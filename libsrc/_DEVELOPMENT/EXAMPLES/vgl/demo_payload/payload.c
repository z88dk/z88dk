/*
	Let's test a simple program that can be loaded into RAM at runtime.
	It will be especially tricky to correctly link it to any existing stdio of the host
*/

//#include <stdio.h>

/*
// Make sure the first bytes are valid instructions
#asm
	jp _main
#endasm
*/

unsigned char VRAM[20*4] @ 0xdca0;
unsigned char DISPLAY_REFRESH_2000[2] @ 0xdceb;
unsigned char DISPLAY_REFRESH_4000[4] @ 0xdcf0;

void delay() {
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

void display_refresh() {
	//DISPLAY_REFRESH_2000[0] = 1;
	//DISPLAY_REFRESH_2000[1] = 1;
	
	DISPLAY_REFRESH_4000[0] = 1;
	DISPLAY_REFRESH_4000[1] = 1;
	DISPLAY_REFRESH_4000[2] = 1;
	DISPLAY_REFRESH_4000[3] = 1;
	
	delay();
}


unsigned char a = 0x41;	// When giving it an initial value, it will be PREpended to the main() code section, else it will be APpended as heap
unsigned char b = 0x42;	// When giving it an initial value, it will be PREpended to the main() code section, else it will be APpended as heap
unsigned char c = 0x43;	// When giving it an initial value, it will be PREpended to the main() code section, else it will be APpended as heap
unsigned char i;	// When giving it an initial value, it will be PREpended to the main() code section, else it will be APpended as heap
unsigned char j;	// When giving it an initial value, it will be PREpended to the main() code section, else it will be APpended as heap

main() {
	/*
	#asm
		defb 0
		defb 0
		defb 0
	#endasm
	*/
	
	//printf("Hello world!\n");
	c = 0x40;
	
	for(j = 0; j < 20; j++) {
		c = j;
		for (i = 0; i < 80; i++) {
			VRAM[i] = (0x41 + (c % 26));
			c += 1;
			
		}
		display_refresh();
	}
	
	/*
	#asm
		defb 0
		defb 0
		defb 0
	#endasm
	*/
}
