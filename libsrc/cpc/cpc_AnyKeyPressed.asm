;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_AnyKeyPressed.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_AnyKeyPressed
        PUBLIC    _cpc_AnyKeyPressed
        
        EXTERN cpc_TestKeyboard


.cpc_AnyKeyPressed
._cpc_AnyKeyPressed
	LD A,$40
.bucle_deteccion_tecla	
	PUSH AF
	call cpc_TestKeyboard					;en A vuelve los valores de la linea
	OR A
	JP NZ, tecla_pulsada					; retorna si no se ha pulsado ninguna tecla
	POP AF
	INC A
	CP $4A
	JP NZ, bucle_deteccion_tecla
	LD HL,0
	RET
	
.tecla_pulsada
	POP AF
	LD HL,1
	RET
