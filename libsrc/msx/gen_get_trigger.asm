;
;	z88dk library: Generic I/O support code for MSX family machines
;
;
;	extern bool __FASTCALL__ msx_get_trigger(unsigned char id);
;
;	get state of joystick button (trigger) number \a id, true = pressed
;
;	$Id: gen_get_trigger.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_get_trigger
	PUBLIC	_msx_get_trigger


msx_get_trigger:
_msx_get_trigger:

	ld	hl,0
	ret
