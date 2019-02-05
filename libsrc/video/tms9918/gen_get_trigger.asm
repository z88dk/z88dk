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

IF FORm5
	in a,($30)	; keyboard row scan
	ld hl,0
	and $40	; mask the SPACE key
	ret z
	dec hl
	ret
ELSE
	ld	hl,0
	ret
ENDIF
