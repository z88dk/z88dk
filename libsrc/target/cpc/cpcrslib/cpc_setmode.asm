;
;       Amstrad CPC library
;       Set mode via firmware
;
;       $Id: cpc_setmode.asm $
;


	        SECTION   code_clib
		PUBLIC	cpc_setmode
		PUBLIC	_cpc_setmode
		PUBLIC	cpc_SetModo
		PUBLIC	_cpc_SetModo

		INCLUDE "target/cpc/def/cpcfirm.def"
		EXTERN	firmware


cpc_setmode:
_cpc_setmode:
cpc_SetModo:
_cpc_SetModo:

	ld	a,l
	call	firmware
	defw	scr_set_mode
	ret
