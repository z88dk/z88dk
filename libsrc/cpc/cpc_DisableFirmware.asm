;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_DisableFirmware.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_DisableFirmware
        PUBLIC    _cpc_DisableFirmware
		
		PUBLIC	backup

.cpc_DisableFirmware
._cpc_DisableFirmware

	DI
	LD HL,($0038)
	LD (backup),HL				
	LD HL,$0038
	LD (hl),$FB		;EI
	inc hl
	LD (hl),$C9	;RET
	EI
	RET

SECTION   bss_clib
.backup defw  0
