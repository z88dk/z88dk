#include <stdio.h>
unsigned char buffer[100];
unsigned char c;


unsigned char i;


#include <sound.h>


void main(void) {
	
	
	printf("Hello, World!\n");
	
	
	printf("Beeping...");
	bit_beep(440, 200);
	printf("!\n");
	
	printf(">");
	gets(buffer);
	printf("You entered: \"%s\"\n", buffer);
	
	while(1) {
		
		printf(">");
		
		//c = getc(stdin);
		c = getchar();
		
		sprintf(buffer, "%d:\"%c\"\n", c, c);
		printf(buffer);
		
	}
	
}
