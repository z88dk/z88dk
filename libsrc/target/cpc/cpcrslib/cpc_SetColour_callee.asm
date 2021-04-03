;
;       Amstrad CPC library
;       set color palette, flashing is useless so we forget the second color
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void __LIB__ __CALLEE__ cpc_SetColour_callee(int pen, int color);
;
;       $Id: cpc_SetColour_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SetColour_callee
        PUBLIC    _cpc_SetColour_callee
        PUBLIC    asm_cpc_SetColour

.cpc_SetColour_callee
._cpc_SetColour_callee


   pop hl
   pop de
   ex (sp),hl
   
   ; enter : l = color
   ;         e = color number

.asm_cpc_SetColour
	ld	a,l
  	LD BC,$7F00                     ;Gate Array 
	OUT (C),A                       ;Color number
	LD A,@01000000              	;Color (and Gate Array)
	ADD E
	OUT (C),A                       
	RET
	
	
