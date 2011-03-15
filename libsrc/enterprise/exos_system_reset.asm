;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_system_reset();
;
;
;	$Id: exos_system_reset.asm,v 1.2 2011-03-15 14:34:08 stefano Exp $
;

	XLIB	exos_system_reset

exos_system_reset:

	ld    c,l
	rst   30h
	defb  0

	ret
