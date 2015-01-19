;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	int exos_system_status(struct EXOS_INFO info);
;
;
;	$Id: exos_system_status.asm,v 1.2 2015-01-19 01:32:43 pauloscustodio Exp $
;

	PUBLIC	exos_system_status

exos_system_status:

	ex    de,hl
	rst   30h
	defb  20
	ld    h,0
	ld    l,b

	ret
