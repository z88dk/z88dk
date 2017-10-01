/*
	Let's test a simple program that can be loaded into RAM at runtime.
	It will be especially tricky to correctly link it to any existing stdio of the host
*/

#include <stdio.h>

/*
// Make sure the first bytes are valid instructions
#asm
	jp _main
#endasm
*/

unsigned char a = 0x41;	// When giving it an initial value, it will be PREpended to the main() code section, else it will be APpended as heap
unsigned char b = 0x42;	// When giving it an initial value, it will be PREpended to the main() code section, else it will be APpended as heap
unsigned char c = 0x43;	// When giving it an initial value, it will be PREpended to the main() code section, else it will be APpended as heap

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
	
	/*
	#asm
		defb 0
		defb 0
		defb 0
	#endasm
	*/
}
