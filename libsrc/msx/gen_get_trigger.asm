;
;	z88dk library: Generic I/O support code for MSX family machines
;
;
;	extern bool __FASTCALL__ msx_get_trigger(unsigned char id);
;
;	get state of joystick button (trigger) number \a id, true = pressed
;
;	$Id: gen_get_trigger.asm,v 1.2 2015-01-19 01:32:57 pauloscustodio Exp $
;


	PUBLIC	msx_get_trigger


msx_get_trigger:

	ld	hl,0
	ret
