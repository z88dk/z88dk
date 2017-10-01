/*
 *	Debug Console
 *
 * 2017-10-01 Bernhard "HotKey" Slawik
 */


#include <stdio.h>
#include <string.h>
#define byte unsigned char
#define INPUT_SIZE 64

byte* getInput() {
	static byte result[INPUT_SIZE];
	putchar('>');
	if (!fgets(result, sizeof(result), stdin)) {
		//exit(1);
	}
	
	result[strlen(result) - 1] = '\0';
	return result;
}


#define CMD_SIZE 16
byte handle(byte *input) {
	// Handle
	byte cmd[CMD_SIZE];
	byte *p;
	byte l;
	
	// Find cmd string
	p = strchr(input, ' ');
	if (p == 0) {
		//strlcpy(cmd, input, strlen(input) + 1);	// including \0
		p = input + strlen(input);
	}
	strlcpy(cmd, input, (p-input) + 1);	// including \0
	strupr(cmd);	// lowercase it
	
	
	if (strcmp(cmd, "HELP") == 0) {
		printf("This is all the help you get.\n");
		
	} else {
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
