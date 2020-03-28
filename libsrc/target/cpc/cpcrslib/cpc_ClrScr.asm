;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_ClrScr.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_ClrScr
        PUBLIC    _cpc_ClrScr
        


.cpc_ClrScr
._cpc_ClrScr

	XOR A
	LD HL,$c000
	LD DE,$c001
	LD BC,16383
	LD (HL),A
	LDIR
	RET

