;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_system_reset();
;
;
;	$Id: exos_system_reset.asm,v 1.3 2015-01-19 01:32:42 pauloscustodio Exp $
;

	PUBLIC	exos_system_reset

exos_system_reset:

	ld    c,l
	rst   30h
	defb  0

	ret
