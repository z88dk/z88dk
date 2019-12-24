;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PutSp(int *sprite, char *alto, char *ancho, int *posicion);
;
;       $Id: cpc_PutSp.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PutSp
        PUBLIC    _cpc_PutSp
		
		EXTERN    cpc_PutSp0
		
		EXTERN    ancho0
		EXTERN    suma_siguiente_linea0
		
        EXTERN    PutSp0_xormode


.cpc_PutSp
._cpc_PutSp

; dibujar en pantalla el sprite

		; Entradas	bc-> Alto Ancho
		;			de-> origen
		;			hl-> destino
		; Se alteran hl, bc, de, af			
		
	xor a
	ld	(PutSp0_xormode),a
	
	ld ix,2
	add ix,sp
	
	ld l,(ix+0)
	ld h,(ix+1)
	
	ld a,(ix+4)	; ancho
    ld (ancho0+1),a		;actualizo rutina de captura
	dec a
	cpl
	ld (suma_siguiente_linea0+1),a    ;comparten los 2 los mismos valores.		
	
	ld a,(ix+2)  ; alto
	
   	ld e,(ix+6)
	ld d,(ix+7)
	
	jp cpc_PutSp0
