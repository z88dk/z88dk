/*

MIDI for the V-Tech Genius LEADER using my DIY "BusFicker" external latch/register

2017-02-19 Bernhard "HotKey" Slawik

*/

#define byte unsigned char
#define word unsigned short

#ifndef EXT_DO
	// Where is the BusFicker at
	#define EXT_DO 0xa000
	#define EXT_DI 0xa000

	extern byte ext_DO			@ (EXT_DO);
	extern byte ext_DI			@ (EXT_DI);
#endif

#define MIDI_CMD_NOTE_ON 0x90
#define MIDI_CMD_NOTE_OFF 0x80
#define MIDI_CMD_SENSE 0xf0


// Where should we keep the variables? You can #define this prior to including this header to overwrite its default
#ifndef VAR_START_MIDI
	// Default: 0xc000 and up
	#define VAR_START_MIDI 0xc080
#endif

//extern p_midi_on_data			@ (VAR_START_MIDI + 0);
extern byte midi_c			@ (VAR_START_MIDI + 0);
//extern byte midi_chn			@ (VAR_START_MIDI + 3);
//extern byte midi_cmd			@ (VAR_START_MIDI + 4);
//extern byte midi_note			@ (VAR_START_MIDI + 5);
//extern byte midi_velocity		@ (VAR_START_MIDI + 6);

#define VAR_SIZE_MIDI 2

void midi_init() {	//void *onData) {
	
	//p_midi_on_data = onData;
	
	// Switch some high address lines high to activate the BUSFICKER function decoder
	#asm
		push af
		ld a, 81h
		out	(3h), a
		pop af
	#endasm
}
void midi_out(byte c) {
	ext_DO = c;
}
byte midi_in() {
	return ext_DI;
}

/*
void midi_delay() {
	//delay_010f();
	//delay_010f();
	//delay_010f();
	//delay_0x1fff();
}
*/
byte midi_in_next() {
	
	//delay_010f();
	//delay_0x1fff();
	
	do {
		midi_c = midi_in();
	} while(midi_c == 0);
	
	return midi_c;
}


void midi_check(byte *midi_cmd, byte *midi_chn, byte *midi_note, byte *midi_velocity) {
	
	midi_c = midi_in();
	//if (midi_c == 0) return;
	*midi_cmd = midi_c & 0xf0;
	*midi_chn = midi_c & 0x0f;
	
	switch (midi_cmd) {
		case MIDI_CMD_NOTE_ON:	// Note on
			//midi_delay();
			*midi_note = midi_in_next();
			
			//midi_delay();
			*midi_velocity = midi_in_next();
			break;
		
		default:
			*midi_note = 0;
			*midi_velocity = 0;
	}
	
}

void midi_noteOn(byte n) {
	midi_out(MIDI_CMD_NOTE_ON + 0);	// Note on (channel)
	midi_out(n);	// Note
	midi_out(100);	// Velocity
}
void midi_noteOff(byte n) {
	midi_out(MIDI_CMD_NOTE_OFF + 0);	// Note on (channel)
	midi_out(n);	// Note
	midi_out(100);	// Velocity
}
