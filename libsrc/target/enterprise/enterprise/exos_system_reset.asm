;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_system_reset();
;
;
;	$Id: exos_system_reset.asm,v 1.4 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
	PUBLIC	exos_system_reset
	PUBLIC	_exos_system_reset

exos_system_reset:
_exos_system_reset:

	ld    c,l
	rst   30h
	defb  0

	ret
