;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	int exos_system_status(struct EXOS_INFO info);
;
;
;	$Id: exos_system_status.asm,v 1.3 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
	PUBLIC	exos_system_status
	PUBLIC	_exos_system_status

exos_system_status:
_exos_system_status:

	ex    de,hl
	rst   30h
	defb  20
	ld    h,0
	ld    l,b

	ret
