;
;       Amstrad CPC library
;       Set Border Color
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_SetBorder.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SetBorder
        PUBLIC    _cpc_SetBorder
        
        EXTERN firmware

        INCLUDE "target/cpc/def/cpcfirm.def"              


.cpc_SetBorder
._cpc_SetBorder
	ld	c,l
	ld	b,c
	call firmware
	defw scr_set_border
	ret
