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
;       $Id: cpc_GetSp_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_GetSp_callee
        PUBLIC    _cpc_GetSp_callee
		
		EXTERN    cpc_GetSp0
		
		EXTERN    anchox
		EXTERN    suma_siguiente_lineax

		
.cpc_GetSp_callee
._cpc_GetSp_callee

; dibujar en pantalla el sprite

		; Entradas	bc-> Alto Ancho
		;			de-> origen
		;			hl-> destino
		; Se alteran hl, bc, de, af			
	
	pop	hl	; ret addr
	pop	de
	
	pop bc	; ancho
	ld	a,c
    ld (anchox+1),a		;actualizo rutina de captura
	dec a
	cpl
	ld (suma_siguiente_lineax+1),a    ;comparten los 2 los mismos valores.		
	
	pop bc	; alto
	ld	a,c
	
	ex (sp),hl
	ex	de,hl
	
	jp cpc_GetSp0

