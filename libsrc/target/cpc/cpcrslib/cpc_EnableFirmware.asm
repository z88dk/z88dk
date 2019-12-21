;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_EnableFirmware.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_EnableFirmware
        PUBLIC    _cpc_EnableFirmware
		
		EXTERN	backup

.cpc_EnableFirmware
._cpc_EnableFirmware

	DI
	LD de,(backup)
				
	LD HL,$0038
	LD (hl),e		;EI
	inc hl
	LD (hl),d	;RET
	EI
	RET

