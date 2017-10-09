#define VGL
#include <stdio.h>
#include <sound.h>

unsigned char buffer[100];
unsigned char c;
unsigned char i;
extern unsigned int pos;
#asm
._pos
	defw 0x0000
#endasm

#define IOCTL_OTERM_PAUSE 0xc042	// defined in target's auto-generated h file

void main(void) {
	
	//ioctl(1, IOCTL_OTERM_PAUSE, 0);	// Switch off "pause after page is full". Also possible on compile time via OTERM_FLAGS when unsetting bit 6 (0x0040)
	
	printf("Tritone!\n");
	
	/*
	printf("Beeping...");
	bit_beep(100, 880);
	printf("!\n");
	*/
	
	//bit_play("G8Ab4G8FEb4DC");
	
	//song_synth();
	
	/*
	for (i=0; i < 8 ; i++ ) {
		printf("bit_fx(%d)\n",i);
		bit_fx(i);
	}
	*/
	
	
	
	
	// Prepare HL to point to music data...
	#asm
		EXTERN asm_bit_play_tritone
		
		ld hl, MUSICDATA
		push hl
	#endasm
	
	// Play loop
	printf("play_tritone: Veeblefetzer");
	//printf("play_tritone: Beeper RockNRoll");
	//printf("play_tritone: Airwolf");
	while(1) {
		// Play one row
		#asm
		pop hl
		di
		call asm_bit_play_tritone
		ei
		push hl
		//ld (_pos), hl
		#endasm
		
		// Time for UI
		printf(".");
		//printf("%04X ", pos);
		
	}
	
}

#include "song_veeblefetzer.inc"
//#include "song_airwolf.inc"
//#include "song_rr.inc"

#include "song_synth.inc"

