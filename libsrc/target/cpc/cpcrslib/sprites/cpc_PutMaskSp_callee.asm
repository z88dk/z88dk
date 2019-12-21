;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PutMaskSp(int *sprite, char *alto, char *ancho, int *posicion);
;
;       $Id: cpc_PutMaskSp_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PutMaskSp_callee
        PUBLIC    _cpc_PutMaskSp_callee
		
		EXTERN    cpc_PutMaskSp0
		
		EXTERN    ancho_m0
		EXTERN    suma_siguiente_linea_m0

		
		
.cpc_PutMaskSp_callee
._cpc_PutMaskSp_callee

; dibujar en pantalla el sprite

		; Entradas	bc-> Alto Ancho
		;			de-> origen
		;			hl-> destino
		; Se alteran hl, bc, de, af			
	
	pop	hl	; ret addr
	pop	de
	
	pop bc	; ancho
	ld	a,c
    ld (ancho_m0+1),a		;actualizo rutina de captura
	dec a
	cpl
	ld (suma_siguiente_linea_m0+1),a    ;comparten los 2 los mismos valores.		
	
	pop bc	; alto
	ld	a,c
	
	ex (sp),hl
	ex	de,hl
	
	jp cpc_PutMaskSp0

