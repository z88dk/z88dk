;
;


	        SECTION   code_clib
		PUBLIC	cpc_setmode
		PUBLIC	_cpc_setmode

		INCLUDE "cpcfirm.def"
		EXTERN	firmware


cpc_setmode:
_cpc_setmode:
	ld	a,l
	call	firmware
	defw	scr_set_mode
	ret
