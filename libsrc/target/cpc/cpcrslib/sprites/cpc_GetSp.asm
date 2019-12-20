;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_GetSp(int *sprite, char *alto, char *ancho, int *posicion);
;
;       $Id: cpc_GetSp.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_GetSp
        PUBLIC    _cpc_GetSp
		
		EXTERN    cpc_GetSp0
		
		EXTERN    anchox
		EXTERN    suma_siguiente_lineax
		

.cpc_GetSp
._cpc_GetSp

; dibujar en pantalla el sprite

		; Entradas	bc-> Alto Ancho
		;			de-> origen
		;			hl-> destino
		; Se alteran hl, bc, de, af			
		
	ld ix,2
	add ix,sp
	
	ld l,(ix+0)
	ld h,(ix+1)
	
	ld a,(ix+4)	; ancho
    ld (anchox+1),a		;actualizo rutina de captura
	dec a
	cpl
	ld (suma_siguiente_lineax+1),a    ;comparten los 2 los mismos valores.		
	
	ld a,(ix+2)  ; alto
	
   	ld e,(ix+6)
	ld d,(ix+7)
	
	jp cpc_GetSp0
