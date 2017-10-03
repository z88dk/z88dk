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
#define PAYLOAD_ORG 0xd000

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
	
	printf("LOADER\n");
	
	c = 0x40;	// Test variable access
	
	printf("Loading");
	//getchar();
	printf("...");
	
	// Load payload into mem
	#asm
		ld bc, (_payload_size)
		
		ld hl, _payload_data	; Source address
		;ld hl, _payload	; Source address
		
		ld de, PAYLOAD_ORG	; Destination address
		ldir	; Copy BC chars from (HL) to (DE)
	#endasm
	
	printf("OK\n");
	//getchar();
	
	
	printf("Press key to run\n");
	getchar();
	
	printf("Calling");
	//getchar();
	printf("...");
	
	#asm
		call PAYLOAD_ORG
	#endasm
	
	printf("OK\n");
	getchar();
	
	printf("END OF LOADER\n");
	getchar();
	
	/*
	#asm
		defb 0
		defb 0
		defb 0
	#endasm
	*/
}

void payload() {
#asm
#include "payload.inc"
#endasm
}
