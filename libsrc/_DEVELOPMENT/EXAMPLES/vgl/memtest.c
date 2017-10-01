/*
 *	Test for RAM areas
 *	
 *	Should show "OK" for 0xC000 - 0xDFFF
 *
 */


#include <stdio.h>

#define byte unsigned char
#define MEM_CHUNK_SIZE 16
#define MEM_SKIP 16
byte c;
byte buffer[40];

unsigned int m;
byte mem[0x10000] @ 0x0000;	// All the memory
int i;

byte mem_test(unsigned int address, byte v_test) {
	byte v_old;
	byte v_read;
	byte err;
	
	err = 0;
	
	v_old = mem[address];	// Store old
	
	v_test = 0x00;
	mem[address] = v_test;	// Set
	v_read = mem[address];	// Read back
	if (v_read != v_test) err++;
	
	v_test = 0xff;
	mem[address] = v_test;	// Set
	v_read = mem[address];	// Read back
	if (v_read != v_test) err++;
	
	mem[address] = v_old;	// Restore
	
	return err;
}


main() {
	
	printf("memtest...\n");
	
	m = 0x0000;
	
	while(1) {
		sprintf(buffer, "%04X", m);
		printf(buffer);
		
		for (i = 0; i < MEM_CHUNK_SIZE; i++) {
			
			if (mem_test(m, 0x00) == 0)
				printf("o");
			else
				printf("X");
			
			m++;
		}
		m -= MEM_CHUNK_SIZE;
		m += MEM_SKIP;
		
		printf("\n");
		//c = getchar();
	}
}
